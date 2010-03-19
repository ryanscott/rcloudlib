#import <UIKit/UIKit.h>

@interface ImageButton : UIImageView {
	id _begin_target;
	SEL _begin_action;

	id _end_target;
	SEL _end_action;
}

@property (retain) id _begin_target;
@property (assign) SEL _begin_action;

@property (retain) id _end_target;
@property (assign) SEL _end_action;

- (void)addBeginTarget:(id)target action:(SEL)action;
- (void)addEndTarget:(id)target action:(SEL)action;

@end
