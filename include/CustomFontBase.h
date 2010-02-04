#import <UIKit/UIKit.h>

@interface CustomFontBase : UIView {
	NSMutableString *curText;
	UIColor *fontColor;
	UIColor *bgColor;
	int fontSize;
	NSString *fontName;
	NSString *fontExtension;
	float autoSizeWidth;
	int glyphOffset;
	BOOL isGlowing;
	UIColor *glowColor;
	bool isCentered;
	bool isOutlined;
	UIColor *outlineColor;
	BOOL shouldAutosize;
}

- (void)updateTextColor:(UIColor*)textColor;
- (void)updateText:(NSString*)newText;
- (void)initTextWithSize:(float)size color:(UIColor*)color bgColor:(UIColor*)bgColor;
- (void)setGlow:(BOOL)glowing withColor:(UIColor*)color;
- (void)setOutline:(BOOL)shouldOutline withColor:(UIColor*)newColor;
- (void)setShouldAutosize:(BOOL)newShouldAutosize;
- (void)setCentered;

@property (nonatomic, retain) NSMutableString *curText;
@property (nonatomic, retain) UIColor *fontColor;
@property (nonatomic, retain) UIColor *bgColor;
@property (nonatomic, retain) UIColor *glowColor;
@property (nonatomic, retain) UIColor *outlineColor;

@end