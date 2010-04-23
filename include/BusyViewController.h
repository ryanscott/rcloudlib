#import <UIKit/UIKit.h>

@class RoundedView;

@interface BusyViewController : UIViewController 
{
	UIActivityIndicatorView* _activityView;
	RoundedView* _rectView;
	UILabel* _busyMessage;
	bool _isVisible;
	
@private
	CGRect _mainBounds;
	
	// this is just a flag to determine if we can safely free the memory if we get a low-memory warning
	bool _safeToRelease;
}

@property (nonatomic, retain) UIActivityIndicatorView* _activityView;
@property (nonatomic, retain) RoundedView* _rectView;
@property (nonatomic, retain) UILabel* _busyMessage;
@property (nonatomic, assign) bool _isVisible;
@property (nonatomic, assign) bool _safeToRelease;

+(BusyViewController*)instance;

+(void)show;
+(void)hide;

+(void)freeMemory;

@end