#import "ImageButton.h"

@implementation ImageButton

@synthesize _target;
@synthesize _action;

#pragma mark Initialization

- (id)initWithImage:(UIImage *)image
{
	if (self = [super initWithImage:image]) 
	{
		self.userInteractionEnabled = YES;
	}
	return self;
}

- (void)dealloc
{
	[super dealloc];
}

#pragma mark Instance Methods

- (void)addTarget:(id)target action:(SEL)action
{
	self._target = target;
	self._action = action;
}

#pragma mark Touch Handlers

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if ( self._target && self._action )
	{
		[self._target performSelector:self._action];
	}
}

@end
