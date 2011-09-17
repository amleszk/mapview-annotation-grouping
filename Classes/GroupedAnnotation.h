

@interface GroupedAnnotation : NSObject <MKAnnotation>
{
	CLLocationCoordinate2D coordinate;
	int count;
}

-(id) initWithCoordinate:(CLLocationCoordinate2D)cord count:(int)cnt;

@end
