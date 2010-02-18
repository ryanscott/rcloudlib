#import <UIKit/UIKit.h>

@interface RoundedView : UIView 
{
	CGFloat _cornerRadius;
	UIColor*	_viewColor;
}

@property (nonatomic, assign)	CGFloat _cornerRadius;
@property (nonatomic, retain)	UIColor* _viewColor;

+(RoundedView*)viewWithFrame:(CGRect)viewframe color:(UIColor*)viewColor;

@end
