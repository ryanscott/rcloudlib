#import <UIKit/UIKit.h>


@interface UIView (UIView_Expanded)

-(void)setOrigin:(CGPoint)newOrigin;
-(void)setSize:(CGSize)heightWidth;

-(void)centerInView:(UIView*)containingView;
-(void)centerInView:(UIView*)containingView xOffset:(CGFloat)x_offset yOffset:(CGFloat)y_offset;

-(UIImage*)getImageForView;

@end
