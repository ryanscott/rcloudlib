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

-(void)centerInView:(UIView*)containingView
{
	[self centerInView:containingView xOffset:0.0f yOffset:0.0f];
}

-(void)centerInView:(UIView*)containingView xOffset:(CGFloat)x_offset yOffset:(CGFloat)y_offset
{
	CGFloat container_center_x = containingView.bounds.size.width / 2.0f;
	CGFloat container_center_y = containingView.bounds.size.height / 2.0f;
	
	CGFloat view_center_x = self.bounds.size.width / 2.0f;
	CGFloat view_center_y = self.bounds.size.height / 2.0f;

	CGFloat new_x = container_center_x - view_center_x;
	CGFloat new_y = container_center_y - view_center_y;

	CGRect new_frame = CGRectIntegral(CGRectMake(new_x + x_offset, new_y + y_offset, self.bounds.size.width, self.bounds.size.height));

	[self setFrame:new_frame];
}


@end
