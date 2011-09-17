
#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{
	mapViewController = [[MapViewController alloc] init];
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[window addSubview:mapViewController.view];
    [window makeKeyAndVisible];
	
    return YES;
}

-(void) dealloc
{
	[window release];
	[mapViewController release];
	[super dealloc];
}


@end
