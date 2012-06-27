
#import "MapViewController.h"
#import "MKMapView+AnnotationGrouping.h"
#import "SingleAnnotation.h"
#import "GroupedAnnotation.h"

@implementation MapViewController

- (id)init
{
	self = [super initWithNibName:nil bundle:nil];
	if(!self)
		return nil;
	
	melbourneCBD.latitude = -37.81303878836988f;
	melbourneCBD.longitude = 144.96331214904785f;

	annotations = [[NSMutableArray array] retain];
	for(int i=0 ; i<50 ; i++)
	{
		CLLocationCoordinate2D annoLocation = melbourneCBD;
		annoLocation.latitude += -0.5f + (float)rand()/RAND_MAX;
		annoLocation.longitude += -0.5f + (float)rand()/RAND_MAX;
		[annotations addObject:[[[SingleAnnotation alloc] initWithCoordinate:annoLocation] autorelease]];
	}	
	
	return self;
}

-(void) dealloc
{
	[annotations release];
	[super dealloc];
}

-(void) loadView
{
	self.view = mapView = [[MKMapView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	mapView.delegate = self;
}

- (void)viewDidLoad
{	
	MKCoordinateRegion region;
	region.center = melbourneCBD;
	region.span.latitudeDelta = 1.0f;
	region.span.longitudeDelta = 1.0f;
	[mapView setRegion:region animated:TRUE];
}

- (void)mapView:(MKMapView *)mapViewParam regionDidChangeAnimated:(BOOL)animated
{
	[mapView removeAnnotations:mapView.annotations];
	[mapView addAnnotations:annotations withGroupDistance:20.0f];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapViewParam viewForAnnotation:(id <MKAnnotation>)annotation
{
	MKPinAnnotationView* pinView;
	pinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"id"];
	if(!pinView)
	{
		pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"id"];
		pinView.canShowCallout = YES;
	}
	
	if([annotation class] == [SingleAnnotation class])
	{
		pinView.pinColor = MKPinAnnotationColorRed;
	}
	if([annotation class] == [GroupedAnnotation class])
	{
		pinView.pinColor = MKPinAnnotationColorGreen;
	}
	
	return pinView;
}

@end
