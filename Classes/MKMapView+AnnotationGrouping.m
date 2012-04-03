
#import "MKMapView+AnnotationGrouping.h"
#import "GroupedAnnotation.h"

@implementation MKMapView(AnnotationGrouping)

static inline CGFloat getDist(CGPoint point1,CGPoint point2)
{
	CGFloat dx = point2.x - point1.x;
	CGFloat dy = point2.y - point1.y;
	return sqrt(dx*dx + dy*dy );
}

-(NSArray*) findFirstGroupingWithAnnotations:(NSArray*)annos withGroupDistance:(float)groupDist
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

-(NSArray*) findAllGroupingWithAnnotations:(NSArray*)annos withGroupDistance:(float)dist
{
	NSMutableArray* groupings = [NSMutableArray array];
    NSMutableArray* singles = [[NSMutableArray alloc] initWithArray:annos copyItems:FALSE];
	while(TRUE)
	{
		NSArray* grouping = [self findFirstGroupingWithAnnotations:singles withGroupDistance:dist];
		if(grouping)
		{
			[groupings addObject:grouping];
			[singles removeObjectsInArray:grouping];
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

-(void) addAnnotations:(NSArray*)annos withGroupDistance:(float)dist
{
    NSMutableArray* singleAnnotationsMinusGrouped = [[NSMutableArray alloc] initWithArray:annos copyItems:FALSE];
	NSArray* groupings = [self findAllGroupingWithAnnotations:annos withGroupDistance:dist];
	for(NSArray* group in groupings)
	{
		CLLocationCoordinate2D coord = [self midPointForAnnotations:group];
		NSObject<MKAnnotation>* groupedAnnotation = [[[GroupedAnnotation alloc] initWithCoordinate:coord 
																		 count:[group count]] autorelease];
        
        [self addAnnotation:groupedAnnotation];
        [singleAnnotationsMinusGrouped removeObjectsInArray:group];
	}
	
	[self addAnnotations:singleAnnotationsMinusGrouped];
}

@end
