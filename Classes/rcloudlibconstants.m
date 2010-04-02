#import "rcloudlibconstants.h"
#import "Util.h"

const CGFloat kDefaultToolbarHeight = 44.0f;
const CGFloat kDefaultTabBarHeight = 49.0f;
const CGFloat kKeyboardHeight = 216.0f;

const CGFloat kDefaultTransitionDuration = 0.3f;
const CGFloat kDefaultFastTransitionDuration = 0.2f;
const CGFloat kDefaultFlipTransitionDuration = 0.7f;

const CGFloat kSoftCornerRadius = 15.0f;
const CGFloat kDefaultCornerRadius = 8.0f;
const CGFloat kHardCornerRadius = 5.0f;

CGRect kApplicationFrame;
CGRect kTabViewFrame;

#pragma mark Private Methods

void RCRandomize() { srandom(time(NULL)); }

void initRCConstants()
{
	CGRect app_frame = [UIScreen mainScreen].applicationFrame;
	kApplicationFrame = CGRectMake(0.0f, 0.0f, app_frame.size.width, app_frame.size.height);	
	kTabViewFrame = CGRectMake(0.0f, 0.0f, app_frame.size.width, app_frame.size.height - kDefaultTabBarHeight);
}

void releaseRCConstants()
{
	//	[kDarkBrownBackgroundColor release];	
}

void rcUncaughtExceptionHandler(NSException *exception) 
{
	NSLog(@"Uncaught Exception: %@ - Reason: %@", exception.name, exception.reason);
	//	[FlurryAPI logError:@"Uncaught Exception" message:@"Crash!" exception:exception];
}

#pragma mark Library Initialization Methods

void initRCLib()
{
	NSSetUncaughtExceptionHandler(&rcUncaughtExceptionHandler);
	RCRandomize();
	initRCConstants();	
}

void RCLibFreeMemory()
{
	[ImagePickerController freeMemory];
}

void terminateRCLib()
{
	releaseRCConstants();
}

