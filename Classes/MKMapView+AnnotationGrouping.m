
#import "MKMapView+AnnotationGrouping.h"
#import "GroupedAnnotation.h"

@implementation MKMapView(AnnotationGrouping)

static inline CGFloat getDist(CGPoint point1,CGPoint point2)
{
	CGFloat dx = point2.x - point1.x;
	CGFloat dy = point2.y - point1.y;
	return sqrt(dx*dx + dy*dy );
}

-(NSArray*) singleMultiMarkerGroupingWithLocations:(NSArray*)annos 
							  withGroupDistance:(int)minDist
{
	NSMutableArray* annosToGroup = [NSMutableArray array];
	for(id<MKAnnotation> a1 in annos)
	{
		CGPoint p1 = [self convertCoordinate:a1.coordinate toPointToView:nil];
		for(id<MKAnnotation> a2 in annos)
		{
			if(a1==a2)
				continue;
			
			CGPoint p2 = [self convertCoordinate:a2.coordinate toPointToView:nil];
			CGFloat dist = getDist(p1,p2);
			if(dist<minDist)
			{
				[annosToGroup addObject:a2];
			}
			
		}
		if([annosToGroup count])
		{
			[annosToGroup addObject:a1];
			return annosToGroup;
		}
	}
	return nil;
}

-(NSArray*) multiMarkerGroupingsWithLocations:(NSMutableArray*)mutableAnnos withGroupDistance:(int)minDist
{
	NSMutableArray* groupings = [NSMutableArray array];
	while(TRUE)
	{
		NSArray* grouping = [self singleMultiMarkerGroupingWithLocations:mutableAnnos 
													withGroupDistance:minDist];
		if(grouping)
		{
			[groupings addObject:grouping];
			[mutableAnnos removeObjectsInArray:grouping];
		}
		else 
		{
			break;
		}
	}
	
	return groupings;
}

-(CLLocationCoordinate2D) midPointForAnnotations:(NSArray*)annos
{
	CGPoint midpoint = CGPointMake(0, 0);
	for(CLLocation* l in annos)
	{
		CGPoint point = [self convertCoordinate:l.coordinate toPointToView:nil];
		midpoint.x += point.x;
		midpoint.y += point.y;
	}
	midpoint.x /= [annos count];
	midpoint.y /= [annos count];
	
	return [self convertPoint:midpoint toCoordinateFromView:nil];	
}

-(NSArray*) getMultiMarkerGroupings:(NSMutableArray*)mutableAnnos withGroupDistance:(int)minDist
{
	NSArray* groupings = [self multiMarkerGroupingsWithLocations:mutableAnnos
											withGroupDistance:minDist];
		
	NSMutableArray* groupedAnnos = [NSMutableArray array];
	for(NSArray* group in groupings)
	{
		CLLocationCoordinate2D coord = [self midPointForAnnotations:group];
		[groupedAnnos addObject:[[[GroupedAnnotation alloc] initWithCoordinate:coord 
																		 count:[group count]] autorelease]];
	}
	
	return groupedAnnos;
}

-(void) addAnnotations:(NSArray*)annos withGroupDistance:(int)minDist
{
	NSMutableArray* singleAnnotationsMinusGrouped = [[NSMutableArray alloc] initWithArray:annos copyItems:FALSE];
	NSArray* groupedAnnos = [self getMultiMarkerGroupings:singleAnnotationsMinusGrouped 
									 withGroupDistance:minDist];
	[self addAnnotations:groupedAnnos];
	[self addAnnotations:singleAnnotationsMinusGrouped];
	
}

@end
