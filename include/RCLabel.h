#import <UIKit/UIKit.h>
#import "rcloudlibconstants.h"

@interface RCLabel : UILabel
{
@private
	VerticalAlignment _verticalAlignment;
}

@property (nonatomic) VerticalAlignment verticalAlignment;

-(void)resizeToFit;

@end
