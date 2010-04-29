#import "rciphonetemplateAppDelegate.h"

@implementation rciphonetemplateAppDelegate

@synthesize window;

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{
	window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	[window makeKeyAndVisible];
	
	return YES;
}


-(void)dealloc 
{
	[window release];
	[super dealloc];
}


@end
