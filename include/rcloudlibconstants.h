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

extern CGRect kApplicationFrame;
extern CGRect kTabViewFrame;

// setup global state, and other initialization
// this should be the first line in applicationDidFinishLaunching
void initRCLib();

// release memory allocated in initRCLib
// this should be in applicationWillTerminate
void terminateRCLib();