#import "UIView-Expanded.h"
#import <UIKit/UIViewController.h>

@implementation UIView (UIView_Expanded)

-(void)setOrigin:(CGPoint)newOrigin
{
	CGPoint i_center = self.center;
	CGSize i_size = self.bounds.size;
	
	i_center.x += newOrigin.x - ( i_center.x - (i_size.width / 2 ) );
	i_center.y += newOrigin.y - ( i_center.y - (i_size.height / 2 ) );

	[self setCenter:i_center];
}

-(void)setSize:(CGSize)heightWidth
{
	CGRect newFrame = self.frame;
	newFrame.size = heightWidth;
	[self setFrame:newFrame];
}

@end
