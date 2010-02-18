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
}

@property (nonatomic, retain) UIActivityIndicatorView* _activityView;
@property (nonatomic, retain) RoundedView* _rectView;
@property (nonatomic, retain) UILabel* _busyMessage;
@property (nonatomic, assign) bool _isVisible;

+(BusyViewController*)instance;

+(void)show;
+(void)hide;

@end