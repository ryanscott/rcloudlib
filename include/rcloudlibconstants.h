typedef enum
{
	VerticalAlignmentTop = 0, // default
	VerticalAlignmentMiddle,
	VerticalAlignmentBottom,
} VerticalAlignment;

extern const CGFloat kDefaultToolbarHeight;
extern const CGFloat kDefaultTabBarHeight;
extern const CGFloat kKeyboardHeight;

extern const CGFloat kDefaultTransitionDuration;
extern const CGFloat kDefaultFastTransitionDuration;
extern const CGFloat kDefaultFlipTransitionDuration;

extern const CGFloat kSoftCornerRadius;
extern const CGFloat kDefaultCornerRadius;
extern const CGFloat kHardCornerRadius;

extern CGRect kApplicationFrame;
extern CGRect kTabViewFrame;

// setup global state, and other initialization
// this should be the first line in applicationDidFinishLaunching
void initRCLib();

// call this from applicationDidReceiveMemoryWarning and RCLib will attempt to
// free up as much memory as it can, by dumping things like image cache, image picker,
// and any other yet to be determined global memory allocations that can more or less
// safely be discarded then later re-allocated on demand
void RCLibFreeMemory();

// release memory allocated in initRCLib
// this should be in applicationWillTerminate
void terminateRCLib();