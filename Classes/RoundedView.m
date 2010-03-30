#import "RoundedView.h"

@implementation RoundedView

@synthesize _cornerRadius;
@synthesize _viewColor;

#pragma mark Custom Accessors

//-(CGFloat)_cornerRadius
//{
//	return _cornerRadius;
//}
//
//- (UIColor *)_viewColor
//{
//	return _viewColor;
//}
//
//- (void)set_cornerRadius:(CGFloat)radius
//{
//	if (_cornerRadius != radius)
//	{
//		_cornerRadius = radius;
//		[self setNeedsDisplay];
//	}
//}
//
//- (void)set_viewColor: (UIColor *)color
//{
//	if (_viewColor != color)
//	{
//		[_viewColor release];
//		_viewColor = [color retain];
//		[self setNeedsDisplay];
//	}
//}

#pragma mark Factory Methods

+(RoundedView*)viewWithFrame:(CGRect)viewframe color:(UIColor*)viewColor
{
	RoundedView* newView = [[RoundedView alloc] initWithFrame:viewframe];
	
	if ( nil != viewColor )
	{
		newView._viewColor = viewColor;
	}
	
	return newView;
}

#pragma mark Initialization

-(id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame])
	{
		// default corner to 8.0, a reasonable number
		self._cornerRadius = kDefaultCornerRadius;
		self._viewColor = [UIColor darkGrayColor];
		super.opaque = NO;
	}
	return self;
}

- (void)dealloc
{
	[_viewColor release];
	[super dealloc];
}

#pragma Drawing

- (void)drawRect: (CGRect)rect
{
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextBeginPath(ctx);

	CGFloat width = self.bounds.size.width;
	CGFloat height = self.bounds.size.height;
	CGFloat radius = self._cornerRadius;
		
	CGContextMoveToPoint(ctx, 0.0f, radius);
	CGContextAddLineToPoint(ctx, 0.0f, height - radius);
	CGContextAddArcToPoint(ctx, 0.0f, height, radius, height, radius);
	CGContextAddLineToPoint(ctx, width - radius, height);
	CGContextAddArcToPoint(ctx, width, height, width, height - radius, radius);
	CGContextAddLineToPoint(ctx, width, radius);
	CGContextAddArcToPoint(ctx, width, 0.0f, width - radius, 0.0f, radius);
	CGContextAddLineToPoint(ctx, radius, 0.0f);
	CGContextAddArcToPoint(ctx, 0.0f, 0.0f, 0.0f, radius, radius);
	
	CGContextSetFillColorWithColor(ctx, self._viewColor.CGColor);
	CGContextClip(ctx);
	CGContextFillRect(ctx, rect);
}

#pragma mark Overrides

- (void)setOpaque:(BOOL)opaque
{
}

@end
