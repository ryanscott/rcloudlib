#import "BusyViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation BusyViewController

@synthesize _activityView;
@synthesize _rectView;
@synthesize _busyMessage;
@synthesize _isVisible;

#pragma mark Singleton

static BusyViewController *gBusyViewControllerInstance = NULL;

+(BusyViewController*)instance
{
	@synchronized(self)
	{
    if (gBusyViewControllerInstance == NULL)
		{
			gBusyViewControllerInstance = [[self alloc] init];
		}
	}
	return(gBusyViewControllerInstance);
}

#pragma mark Initialization Methods

- (CGImageRef)gradientBackgroundImage
{
	CGContextRef ctx;
	CGAffineTransform transform;
	CGPoint centerPoint;
	CGPoint newCenter;
	CGFloat	alpha;
	NSArray	*colors;
	CGGradientRef gradient;
	UIImage *image;
	
	UIGraphicsBeginImageContext([UIScreen mainScreen].bounds.size);
	ctx = UIGraphicsGetCurrentContext();
	transform = CGAffineTransformMakeScale(1.0f, 1.1f);
	centerPoint = CGPointMake(CGRectGetMidX([UIScreen mainScreen].bounds), CGRectGetMidY([UIScreen mainScreen].bounds));
	newCenter = CGPointApplyAffineTransform(centerPoint, CGAffineTransformInvert(transform));
	transform = CGAffineTransformTranslate(transform, newCenter.x - centerPoint.x, newCenter.y - centerPoint.y);
	CGContextConcatCTM(ctx, transform);
	alpha = 0.4f;
	
	colors = [NSArray arrayWithObjects: (id)[UIColor colorWithWhite: 0.1f alpha: alpha].CGColor,
						(id)[UIColor colorWithWhite: 0.7f alpha: alpha].CGColor, nil];
	
	gradient = CGGradientCreateWithColors(CGColorGetColorSpace((CGColorRef)[colors objectAtIndex:0]), (CFArrayRef)colors, NULL);
	
	CGContextDrawRadialGradient(ctx, gradient, centerPoint, 120, centerPoint, 0,
															kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
	CGGradientRelease(gradient);
	image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return (image.CGImage);
}

-(void)initControls
{
//	// we want to center this view in the overlay window
//	_mainBounds = [UIScreen mainScreen].bounds;
//	
////	CGFloat win_width = _mainBounds.size.width;
////	CGFloat win_height = _mainBounds.size.height;
//	
//	// the (int) is to make sure these line up on pixel boundaries, to avoid an anti-aliasing nightmare
//	int win_center_x = (int)( _mainBounds.size.width / 2.0f );
//	int win_center_y = (int)( _mainBounds.size.height / 2.0f );
//	
//	CGFloat width = 160.0f;
//	CGFloat height = 160.0f;
//	
//	int view_center_x = (int)( width / 2.0f );
//	int view_center_y = (int)( height / 2.0f );
//
//	CGFloat x = win_center_x - view_center_x;
//	CGFloat y = win_center_y - view_center_y;
//	

	CGFloat x = 0.0f;
	CGFloat y = 0.0f;	
	CGFloat width = 160.0f;
	CGFloat height = 160.0f;
	
	CGRect l_frame = CGRectMake(x, y, width, height);
	
	self._rectView = [RoundedView viewWithFrame:l_frame color:[UIColor colorWithWhite: 0.2f alpha: 0.9f]];

	self._activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[self._activityView centerInView:self._rectView];

	//	self._activityView.center = CGPointMake(view_center_x, view_center_y);

	self._busyMessage = [[UILabel alloc] initWithFrame: CGRectZero];
	self._busyMessage.font = [UIFont systemFontOfSize: [UIFont labelFontSize]];
	self._busyMessage.text = @"Loading...";
	[self._busyMessage sizeToFit];
	self._busyMessage.backgroundColor = [UIColor clearColor];
	self._busyMessage.textColor = [UIColor whiteColor];
	self._busyMessage.opaque = NO;
	self._busyMessage.center = CGPointMake((int)(width / 2.0f), (int)(height - self._busyMessage.bounds.size.height));

	//	self._busyMessage.center = CGPointMake(view_center_x, (int)(height - self._busyMessage.bounds.size.height));

	//	self._busyMessage.frame = CGRectIntegral(label.frame);
	
//	self._busyMessage.center = CGPointMake(CGRectGetMidX(l_frame), CGRectGetMaxY(l_frame) - self._busyMessage.bounds.size.height);
//	self._busyMessage.frame = CGRectIntegral(self._busyMessage.frame);
	
}

-(id)init
{
	if ( self = [super init] )
	{
		self._activityView = nil;
		self._isVisible = false;
		[self initControls];
	}
	return self;
}

- (void)loadView 
{
	CGRect content_frame = [[UIScreen mainScreen] applicationFrame];
	UIWindow* content_view = [[UIWindow alloc] initWithFrame:content_frame];
	content_view.layer.contents = (id)[self gradientBackgroundImage];
	content_view.hidden = YES;
	
	// should show above the keyboard but below alerts
	content_view.windowLevel = (UIWindowLevelNormal + UIWindowLevelAlert) / 2.0f;
	
	self.view = content_view;
	[content_view release];
}

//-(void)initEvents
//{
//	//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notify:) name:@"Event" object:notificationSender];	
//}

//-(void)stopEvents
//{
//	//[[NSNotificationCenter defaultCenter] removeObserver:self @"Event" object:notificationSender];
//}

-(void)addSubviews
{
	[self._rectView centerInView:self.view];
	
	[self._rectView addSubview:self._activityView];
	[self._rectView addSubview:self._busyMessage];
	[self.view addSubview:self._rectView];
}

-(void)viewDidLoad 
{
	//	[self initEvents];
	
	[self addSubviews];
	[super viewDidLoad];
}

- (void)didReceiveMemoryWarning 
{
	[super didReceiveMemoryWarning];
}

- (void)dealloc 
{
	//	[self stopEvents];
	
	[_activityView release];
	[_rectView release];
	[_busyMessage release];
	[super dealloc];
}

#pragma mark Instance Methods

const static CGFloat kTransitionScale = 1.2f;

- (void)show
{
	BOOL bPrevAnimationEnabled;
	
	if (NO == self._isVisible)
	{
		// if the view is still visible, then it must be in-flight, so don't touch it
		if (self.view.hidden == YES)
		{
			bPrevAnimationEnabled = [UIView areAnimationsEnabled];
			[UIView setAnimationsEnabled: NO];
			self.view.alpha = 0.0f;
			self.view.transform = CGAffineTransformMakeScale(kTransitionScale, kTransitionScale);
			self.view.hidden = NO;
			[UIView setAnimationsEnabled: bPrevAnimationEnabled];
		}
		
		[UIView beginAnimations: @"Overlay showing" context: NULL];
		[UIView setAnimationBeginsFromCurrentState: YES];
		self.view.alpha = 1.0f;
		self.view.transform = CGAffineTransformIdentity;
		[UIView commitAnimations];
		[self._activityView startAnimating];
		self._isVisible = YES;
		[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
	}
}

- (void)hide
{
	if (YES == self._isVisible)
	{
		[self._activityView stopAnimating];
		[UIView beginAnimations: @"OverlayView hiding" context: NULL];
		[UIView setAnimationDelegate: self];
		[UIView setAnimationDidStopSelector: @selector(animationFinished:finished:context:)];
		self.view.alpha = 0.0f;
		self.view.transform = CGAffineTransformMakeScale(kTransitionScale, kTransitionScale);
		[UIView commitAnimations];
		self._isVisible = NO;
		[[UIApplication sharedApplication] endIgnoringInteractionEvents];
	}
}

- (void)animationFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context
{
	// ignore the finished arg, it seems to be inverted and therefore untrustworthy
	if (NO == self._isVisible)
	{
		self.view.hidden = YES;
	}
}

#pragma mark Convenience Class Methods

+(void)show
{
	[[BusyViewController instance] show];
}

+(void)hide
{
	[[BusyViewController instance] hide];
}


@end
