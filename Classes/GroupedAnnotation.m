

#import "GroupedAnnotation.h"


@implementation GroupedAnnotation

- (NSString *)subtitle
{
	return @"";
}
- (NSString *)title
{
	return [NSString stringWithFormat:@"grouping of %d",count];
}

-(CLLocationCoordinate2D) coordinate
{
	return coordinate;
}

-(id) initWithCoordinate:(CLLocationCoordinate2D)cord count:(int)cnt
{
	self = [super init];
	if(!self)
		return nil;
	
	coordinate = cord;
	count = cnt;
	
	return self;
}

@end
