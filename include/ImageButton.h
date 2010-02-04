#import <UIKit/UIKit.h>

@interface ImageButton : UIImageView {
	id _target;
	SEL _action;
}

@property (retain) id _target;
@property (assign) SEL _action;

- (void)addTarget:(id)target action:(SEL)action;

@end
