
@interface MapViewController : UIViewController <MKMapViewDelegate>
{
	MKMapView* mapView;
	CLLocationCoordinate2D melbourneCBD;
	NSMutableArray* annotations;
}

@end
