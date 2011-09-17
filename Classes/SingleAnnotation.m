

#import "SingleAnnotation.h"


@implementation SingleAnnotation

- (NSString *)subtitle
{
	return @"";
}
- (NSString *)title
{
	return [NSString stringWithFormat:@"single at %.2f %.2f",coordinate.latitude,coordinate.longitude];
}

-(CLLocationCoordinate2D) coordinate
{
	return coordinate;
}

-(id) initWithCoordinate:(CLLocationCoordinate2D)cord
{
	self = [super init];
	if(!self)
		return nil;
	
	coordinate = cord;

	return self;
}



@end
