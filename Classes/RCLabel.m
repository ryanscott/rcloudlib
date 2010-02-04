#import "RCLabel.h"
#import "UIView-Expanded.h"

@implementation RCLabel

#pragma mark Initialization

-(id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (!self) return nil;
	
	_verticalAlignment = VerticalAlignmentTop;
	
	return self;
}

-(void)dealloc
{
	[super dealloc];
}

#pragma mark Custom Properties

-(VerticalAlignment) verticalAlignment
{
	return _verticalAlignment;
}

-(void) setVerticalAlignment:(VerticalAlignment)value
{
	_verticalAlignment = value;
	[self setNeedsDisplay];
}

#pragma mark Instance Methods

// align text block according to vertical alignment settings
-(CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
	CGRect rect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
	CGRect result;
	switch (_verticalAlignment)
	{
		case VerticalAlignmentTop:
			result = CGRectMake(bounds.origin.x, bounds.origin.y, rect.size.width, rect.size.height);
			break;
		case VerticalAlignmentMiddle:
			result = CGRectMake(bounds.origin.x, bounds.origin.y + (bounds.size.height - rect.size.height) / 2, rect.size.width, rect.size.height);
			break;
		case VerticalAlignmentBottom:
			result = CGRectMake(bounds.origin.x, bounds.origin.y + (bounds.size.height - rect.size.height), rect.size.width, rect.size.height);
			break;
		default:
			result = bounds;
			break;
	}
	return result;
}

-(void)drawTextInRect:(CGRect)rect
{
	CGRect r = [self textRectForBounds:rect limitedToNumberOfLines:self.numberOfLines];
	[super drawTextInRect:r];
}

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
