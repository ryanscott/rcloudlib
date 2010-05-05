#import "AppDelegate_Phone.h"

@implementation AppDelegate_Phone

@synthesize window;

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{
	window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];	
	window.backgroundColor = [UIColor blueColor];
	[window makeKeyAndVisible];
	
	return YES;
}

-(void)dealloc 
{
	[window release];
	[super dealloc];
}


@end
