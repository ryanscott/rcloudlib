#import <UIKit/UIKit.h>

@interface UISwitch (tagged)

+(UISwitch*)allocSwitchWithLeftText:(NSString*)yesText andRight:(NSString*)noText;

@property (nonatomic, readonly)	UILabel* label1;
@property (nonatomic, readonly)	UILabel* label2;

@end
