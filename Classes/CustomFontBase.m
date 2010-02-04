#import "CustomFontBase.h"
#import "UIColor-Expanded.h"

@implementation CustomFontBase

@synthesize curText;
@synthesize fontColor;
@synthesize bgColor;
@synthesize glowColor;
@synthesize outlineColor;

#pragma mark Initialization Methods

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		// set defaults
		[self setBackgroundColor:[UIColor clearColor]];
		self.bgColor = [UIColor clearColor];
		[self setCurText: [[NSMutableString alloc] initWithString:@""] ];
		self.fontColor = [UIColor whiteColor];
		fontSize = 15;
		isGlowing = FALSE;
		glowColor = nil;
		isCentered = false;
		isOutlined = false;
		outlineColor = nil;
		shouldAutosize = NO;
		[self setContentMode:UIViewContentModeTopLeft];  // make sure it doesn't scale/deform when setFrame is called 
	}
	return self;
}

// call this after creating the LandscapeText object to set the styling
- (void)initTextWithSize:(float)size color:(UIColor*)color bgColor:(UIColor*)txtBgColor {
	// store font properties
	self.fontColor = color;
	fontSize = size;
	self.bgColor = txtBgColor;
	
	// autoscale height to font size
	//[self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, fontSize)];
}

- (void)dealloc {
	[curText release];
	[super dealloc];
}

#pragma mark Instance Methods

//void UIGraphicsBeginImageContext(CGSize size);

- (void)autoSizeWidthNow {
	//printf( "autoSizeWidth = %f \n", autoSizeWidth );
	[self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, autoSizeWidth, fontSize)];
}

- (void)drawRect:(CGRect)rect {
	// get context and flip for normal coordinates
	CGContextRef context =  UIGraphicsGetCurrentContext();
	CGContextTranslateCTM ( context, 0, self.bounds.size.height );
	CGContextScaleCTM ( context, 1.0, -1.0 );
	
	// Get the path to our custom font and create a data provider.
	NSString *fontPath = [[NSBundle mainBundle] pathForResource:fontName ofType:fontExtension];
	CGDataProviderRef fontDataProvider = CGDataProviderCreateWithFilename([fontPath UTF8String]);
	// Create the font with the data provider, then release the data provider.
	CGFontRef customFont = CGFontCreateWithDataProvider(fontDataProvider);
	CGDataProviderRelease(fontDataProvider); 
	// Set the customFont to be the font used to draw.
	CGContextSetFont(context, customFont);
	
	// prepare characters for printing
	NSString *theText = [NSString stringWithString: curText];
	int length = [theText length];
	unichar chars[length];
	CGGlyph glyphs[length];
	[theText getCharacters:chars range:NSMakeRange(0, length)];
	
	// draw bg
	// [ryan:8-5-9] this does not work correctly with autosize
	if( self.bgColor != [UIColor clearColor] )
	{
		CGRect bgRect = CGRectMake (0, 0, self.bounds.size.width, self.bounds.size.height);
		CGContextSetFillColorWithColor( context, self.bgColor.CGColor );
		CGContextFillRect( context, bgRect );
	}
	
	// Set how the context draws the font, what color, how big.
	CGContextSetTextDrawingMode(context, kCGTextFill);
	CGContextSetFillColorWithColor(context, self.fontColor.CGColor );
	CGContextSetFontSize(context, fontSize);
	
	// set a glow?
	if( isGlowing ) 
	{
		//CGContextSetShadow(context, CGSizeMake(0,0), 3 );
		CGContextSetShadowWithColor( context, CGSizeMake(0,0), 3, glowColor.CGColor );
	}
	
	if ( isOutlined )
	{
		CGContextSetStrokeColorWithColor( context, outlineColor.CGColor );
		CGContextSetTextDrawingMode( context, kCGTextFillStroke );
	}
	else
	{
		CGContextSetTextDrawingMode(context, kCGTextFill);
	}
	
	// Loop through the entire length of the text.
	for (int i = 0; i < length; ++i) {
		// Store each letter in a Glyph and subtract the MagicNumber to get appropriate value.
		glyphs[i] = [theText characterAtIndex:i] + glyphOffset;
	}

	if ( isCentered )
	{
		CGContextSetTextDrawingMode( context, kCGTextInvisible );
		
		// draw the glyphs to get the width
		CGContextShowGlyphsAtPoint( context, 0, 0 + fontSize * .25, glyphs, length ); // hack the y-point to make sure it's not cut off below font baseline - this creates a perfect vertical fit
		
		// get width of text for autosizing the frame later (perhaps)
		CGPoint textEnd = CGContextGetTextPosition( context );
		float adjustment = ( self.frame.size.width - textEnd.x ) / 2.0f;

		// draw the glyphs for real
		CGContextShowGlyphsAtPoint( context, adjustment, 0 + fontSize * .25, glyphs, length ); // hack the y-point to make sure it's not cut off below font baseline - this creates a perfect vertical fit
	}
	else
	{
		// draw the glyphs
		CGContextShowGlyphsAtPoint( context, 0, 0 + fontSize * .25, glyphs, length ); // hack the y-point to make sure it's not cut off below font baseline - this creates a perfect vertical fit
	}
	
	// get width of text for autosizing the frame later (perhaps)
	CGPoint textEnd = CGContextGetTextPosition( context ); 
	autoSizeWidth = textEnd.x;
	
	if ( shouldAutosize )
		[self autoSizeWidthNow];
	
	// clean up the font
	CGFontRelease( customFont );
}

- (void)updateTextColor:(UIColor*)textColor
{
	self.fontColor = textColor;
}

// set new text to display
- (void)updateText:(NSString*)newText {
	[self setCurText: [NSString stringWithString:newText] ];
	[self setNeedsDisplay];
}

- (void)setGlow:(BOOL)glowing withColor:(UIColor*)color {
	glowColor = color;
	isGlowing = glowing;
}

- (void)setOutline:(BOOL)shouldOutline withColor:(UIColor*)newColor
{
	isOutlined = shouldOutline;
	outlineColor = newColor;
}

- (void)setShouldAutosize:(BOOL)newShouldAutosize
{
	shouldAutosize = newShouldAutosize;
}

-(void)setCentered
{
	isCentered = true;
	
	// really not sure if this is necessary, and at that...not sure if this isn't too late of a palce to do it
	[self setContentMode:UIViewContentModeCenter];
}


@end