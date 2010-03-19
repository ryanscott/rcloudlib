#import "UIControl-Expanded.h"

@implementation UIControl (UIControl_Expanded)

-(void)removeAllTargets
{
	for ( id i_target in [self allTargets] )
	{
		[self removeTarget:i_target action:NULL forControlEvents:UIControlEventAllEvents];
	}
}

@end
