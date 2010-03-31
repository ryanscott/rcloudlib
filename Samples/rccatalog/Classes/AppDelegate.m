#import "AppDelegate.h"
#import "MainView.h"

@implementation AppDelegate

@synthesize window;
@synthesize _mainView;

- (void)applicationDidFinishLaunching:(UIApplication *)application
{ 
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	
	RCLog(@"intmax = %d", INT_MAX);

	self._mainView = [[MainView alloc] init];
	
	[window addSubview:self._mainView.view];
	[window makeKeyAndVisible];
}

- (void)dealloc 
{
	[_mainView release];
	[window release];
	[super dealloc];
}


@end
