#import <UIKit/UIKit.h>

@interface MainView : UIViewController <ImagePickerDelegate>
{
	UIButton* _drawButton;
}

@property (nonatomic, retain) UIButton* _drawButton;

@end
