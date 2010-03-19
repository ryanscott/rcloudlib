#import "ImageButton.h"

@implementation ImageButton

@synthesize _begin_target;
@synthesize _begin_action;

@synthesize _end_target;
@synthesize _end_action;

#pragma mark Initialization

- (id)initWithImage:(UIImage *)image
{
	if (self = [super initWithImage:image]) 
	{
		self.userInteractionEnabled = YES;
		self._begin_target = nil;
		self._begin_action = nil;
		self._end_target = nil;
		self._end_action = nil;
	}
	return self;
}

- (void)dealloc
{
	[super dealloc];
}

#pragma mark Instance Methods

- (void)addBeginTarget:(id)target action:(SEL)action
{
	self._begin_target = target;
	self._begin_action = action;
}

- (void)addEndTarget:(id)target action:(SEL)action
{
	self._end_target = target;
	self._end_action = action;
}

#pragma mark Touch Handlers

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if ( self._begin_target && self._begin_action )
	{
		[self._begin_target performSelector:self._begin_action];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if ( self._end_target && self._end_action )
	{
		[self._end_target performSelector:self._end_action];
	}
}

@end
