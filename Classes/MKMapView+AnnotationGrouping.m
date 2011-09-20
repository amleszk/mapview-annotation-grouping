
#import "MKMapView+AnnotationGrouping.h"
#import "GroupedAnnotation.h"

@implementation MKMapView(AnnotationGrouping)

static inline CGFloat getDist(CGPoint point1,CGPoint point2)
{
	CGFloat dx = point2.x - point1.x;
	CGFloat dy = point2.y - point1.y;
	return sqrt(dx*dx + dy*dy );
}

-(NSArray*) groupingWithAnnotations:(NSArray*)annos withGroupDistance:(int)groupDist
{
	NSMutableArray* annotationsToGroup = [NSMutableArray array];
	for(id<MKAnnotation> a1 in annos)
	{
		CGPoint p1 = [self convertCoordinate:a1.coordinate toPointToView:nil];
		for(id<MKAnnotation> a2 in annos)
		{
			if(a1==a2)
				continue;
			
			CGPoint p2 = [self convertCoordinate:a2.coordinate toPointToView:nil];
			CGFloat dist = getDist(p1,p2);
			if(dist<groupDist)
			{
				[annotationsToGroup addObject:a2];
			}
			
		}
		if([annotationsToGroup count])
		{
			[annotationsToGroup addObject:a1];
			return annotationsToGroup;
		}
	}
	return nil;
}

-(NSArray*) groupAnnotations:(NSMutableArray*)mutableAnnotations withGroupDistance:(int)dist
{
	NSMutableArray* groupings = [NSMutableArray array];
	while(TRUE)
	{
		NSArray* grouping = [self groupingWithAnnotations:mutableAnnotations withGroupDistance:dist];
		if(grouping)
		{
			[groupings addObject:grouping];
			[mutableAnnotations removeObjectsInArray:grouping];
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

-(NSArray*) convertToGroupedAnnotationWithAnnotations:(NSMutableArray*)mutableAnnos withGroupDistance:(int)dist
{
	NSArray* groupings = [self groupAnnotations:mutableAnnos withGroupDistance:dist];
	NSMutableArray* groupedAnnos = [NSMutableArray array];
	for(NSArray* group in groupings)
	{
		CLLocationCoordinate2D coord = [self midPointForAnnotations:group];
		[groupedAnnos addObject:[[[GroupedAnnotation alloc] initWithCoordinate:coord 
																		 count:[group count]] autorelease]];
	}
	
	return groupedAnnos;
}

-(void) addAnnotations:(NSArray*)annos withGroupDistance:(int)dist
{
	NSMutableArray* singleAnnotationsMinusGrouped = [[NSMutableArray alloc] initWithArray:annos copyItems:FALSE];
	NSArray* groupedAnnos = [self convertToGroupedAnnotationWithAnnotations:singleAnnotationsMinusGrouped 
									 withGroupDistance:dist];
	[self addAnnotations:groupedAnnos];
	[self addAnnotations:singleAnnotationsMinusGrouped];
	
}

@end
