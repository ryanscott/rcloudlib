#import "UITextView-Expanded.h"
#import "UIView-Expanded.h"

@implementation UITextView (UITextView_Expanded)

// this resizes the bounds of the textview to fit the text.  It has the net effect of
// making the text be top-aligned, rather than middle-aligned, which is the idiotic default
-(void)resizeToFit
{
	CGSize myStringSize = [self.text sizeWithFont:self.font 
														 constrainedToSize:CGSizeMake(self.bounds.size.width, 9999)
																 lineBreakMode:UILineBreakModeWordWrap];
	
	[self setSize:CGSizeMake(self.bounds.size.width, (myStringSize.height * 1.1 ))];
}

@end
