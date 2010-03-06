#import <UIKit/UIKit.h>

@class MainView;

@interface AppDelegate : NSObject <UIApplicationDelegate> 
{
	UIWindow *window;
	MainView *_mainView;	
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) MainView *_mainView;

@end

