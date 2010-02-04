#import "FieldEditController.h"
#import "Util.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor-Expanded.h"

static NSString *const kFECCopyFont = @"Helvetica";
static NSString *const kFECLabelFont = @"Helvetica-Bold";

static const CGFloat kFECLabelFontSize = 16.0f;
static const CGFloat kFECHeadingFontSize = 18.0f;

static const int kToolbarUnknown = -1;
static const int kToolbarDefault = 0;
static const int kToolbarDone = 1;

@implementation FieldEditController

@synthesize _titleBar;
@synthesize _titleLabel;

@synthesize _titleButton;
@synthesize _doneButton;
@synthesize _flexibleSpace;
@synthesize _fixedSpace;
@synthesize _currentToolbar;

@synthesize _cellImage;
@synthesize _inputField;

@synthesize _doneTarget;
@synthesize _doneCallback;
@synthesize _userContext;

@synthesize _inView;

#pragma mark Initialization Methods

-(void)setDefaultToolbar
{
	[self._titleBar setItems:[NSArray arrayWithObjects:self._flexibleSpace, self._titleButton, self._flexibleSpace, nil]];	
}

-(void)setToolbarWithDoneButton
{	
	[self._titleBar setItems:[NSArray arrayWithObjects:self._doneButton, self._titleButton, self._fixedSpace, nil]];	
}

-(void)chooseToolbar
{
	int new_toolbar = kToolbarDefault;
	
	if ( UIKeyboardTypeNumberPad == self._inputField.keyboardType || UIKeyboardTypePhonePad == self._inputField.keyboardType )
		new_toolbar = kToolbarDone;
	
	if ( new_toolbar != self._currentToolbar )
	{
		self._currentToolbar = new_toolbar;
		if ( kToolbarDone == self._currentToolbar )
			[self setToolbarWithDoneButton];
		else
			[self setDefaultToolbar];
	}
}

-(void)initToolbar
{
	CGFloat width = 320.0f;
	CGFloat height = 44.0f;
	CGFloat x = 0.0f;
	CGFloat y = 0.0f;
	CGRect l_frame = CGRectMake(x, y, width, height);
	
	self._titleBar = [[UIToolbar alloc] initWithFrame:l_frame];

	// TODO: testing out toolbar tinting
	// YES! this works
	//self._titleBar.tintColor = [UIColor colorWithHexString: @"e56100"];

	width = 200.0f;
	x = 160.0f - (width / 2.0f);
	height = 22.0f;
	y = 22.0f - (height / 2.0f);
	l_frame = CGRectMake(x, y, width, height);
	
	self._titleLabel = [[UILabel alloc] initWithFrame:l_frame];
	self._titleLabel.text = @"";
	self._titleLabel.font = [UIFont fontWithName:kFECLabelFont size:kFECHeadingFontSize];
	self._titleLabel.textColor = [UIColor whiteColor];
	self._titleLabel.backgroundColor = [UIColor clearColor];
	self._titleLabel.numberOfLines = 1;
	self._titleLabel.textAlignment = UITextAlignmentCenter;
	
	self._titleButton = [[UIBarButtonItem alloc] initWithCustomView:self._titleLabel];
	self._flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];	
	self._doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTapped)];
	self._fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	self._fixedSpace.width = self._doneButton.width;
	
	self._currentToolbar = kToolbarUnknown;
}

-(void)initControls
{
	self._userContext = nil;
	
	// this is 264 with no titlebar, and 220 with a 44px titlebar
	CGFloat contentHeight = 220.0f;
	
	CGFloat width = 302.0f;
	CGFloat height = 45.0f;
	CGFloat x = 9.0f;
	CGFloat y = 44.0f + ( (contentHeight / 2.0f) - (height / 2.0f) );
	
	// 302 x 45	
	CGRect l_frame = CGRectMake(x, y, width, height);
	self._cellImage = [[UIImageView alloc] initWithImage:[Util loadImage:@"1_bar_table_transcorners"]];
	self._cellImage.frame = l_frame;	
	
	x += 9.0f;
	y += 11.0f;
	height = 22.0f;
	width -= 18.0f;
	
	l_frame = CGRectMake(x, y, width, height);
	self._inputField = [[UITextField alloc] initWithFrame:l_frame];
	self._inputField.text = @"";
	
	self._inputField.font = [UIFont fontWithName:kFECCopyFont size:kFECLabelFontSize];
	self._inputField.textColor = [UIColor blackColor];
	self._inputField.backgroundColor = [UIColor clearColor];
//	self._inputField.backgroundColor = [UIColor colorWithHexString:@"ff6666"];	
	self._inputField.textAlignment = UITextAlignmentLeft;
	self._inputField.delegate = self;
	self._inputField.returnKeyType =  UIReturnKeyDone;
	//self._inputField.keyboardAppearance = UIKeyboardAppearanceAlert;	
}

-(void)initSelf
{	
	[self initToolbar];
	[self initControls];
	[self setDefaultToolbar];
}

-(id)init
{
	if ( self = [super init] )
	{
		self._doneTarget = nil;
		self._doneCallback = nil;		
		[self initSelf];
	}
	
	return self;		
}

-(id)initWithTarget:(id)callbackTarget doneCallback:(SEL)callbackMethod
{
	if ( self = [super init] )
	{
		self._doneTarget = callbackTarget;
		self._doneCallback = callbackMethod;
		[self initSelf];
	}
	
	return self;	
}

-(void)loadView 
{
	CGRect content_frame = [[UIScreen mainScreen] applicationFrame];
	UIView *contentView = [[UIView alloc] initWithFrame:content_frame];
	contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
	self.view = contentView;
	[contentView release];		
}

- (void)viewDidLoad {
	// we have 200 pixels to work with between the keyboard at the bottom, and the nav bar at the top
	// 264 with no chrome at the top

	[self.view addSubview:self._titleBar];
	[self.view addSubview:self._cellImage];		
	[self.view addSubview:self._inputField];	
}

- (void)viewDidAppear:(BOOL)animated
{
	[self chooseToolbar];
	[self._inputField becomeFirstResponder];	
}
	
- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)dealloc {
	[_titleBar release];
	[_titleLabel release];
	
	[_titleButton release];
	[_doneButton release];
	[_flexibleSpace release];
	[_fixedSpace release];
	
	[_cellImage release];
	[_inputField release];
	
	[super dealloc];
}

#pragma mark Instance Methods

-(void)setTitle:(NSString*)newText
{
	self._titleLabel.text = newText;
}

-(void)setPlaceholderText:(NSString*)newText
{
	self._inputField.placeholder = newText;
}

-(void)setText:(NSString*)newText
{
	self._inputField.text = newText;
}

-(void)setTarget:(id)newTarget callback:(SEL)newCallback
{
	self._doneTarget = newTarget;
	self._doneCallback = newCallback;	
}

-(void)setKeyboardType:(UIKeyboardType)newKeyboard
{
	self._inputField.keyboardType = newKeyboard;
}

-(void)animateInView
{
	CATransition *transition = [CATransition animation];
	transition.duration = 0.25;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transition.type = kCATransitionPush;	
	transition.subtype = kCATransitionFromRight;
	
	// Now to set the type of transition. Since we need to choose at random, we'll setup a couple of arrays to help us.
	//	NSString *types[4] = {kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade};
	//	NSString *subtypes[4] = {kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom};
	
	[self._inView.layer addAnimation:transition forKey:nil];
	[self viewWillAppear:YES];
	[self._inView addSubview:self.view];
	[self viewDidAppear:YES];
	
	//	view1.hidden = YES;
	//	view2.hidden = NO;
}

-(void)showInView:(UIView*)inView
{
	self._inView = inView;
	[self animateInView];
	
//	[self viewWillAppear:YES];
//  [inView addSubview:self.view];
//	[self viewDidAppear:YES];
}

-(void)animateOutView
{
	CATransition *transition = [CATransition animation];
	transition.duration = 0.25;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transition.type = kCATransitionPush;	
	transition.subtype = kCATransitionFromLeft;
	
	// Now to set the type of transition. Since we need to choose at random, we'll setup a couple of arrays to help us.
	//	NSString *types[4] = {kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade};
	//	NSString *subtypes[4] = {kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom};
	
	[self._inView.layer addAnimation:transition forKey:nil];
	[self viewWillDisappear:YES];
	[self.view removeFromSuperview];
	[self viewDidDisappear:YES];
	
	//	view1.hidden = YES;
	//	view2.hidden = NO;
}

-(NSString*)getText
{
	return self._inputField.text;
}

#pragma mark Button Handlers

-(void)doneTapped
{
	[self textFieldShouldReturn:self._inputField];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	// [ryan:8-3-9] the order of these (callback & resignFirstResponder) might be off, but I think this will work as is
	[self._inputField resignFirstResponder];	

	if ( self._doneTarget && self._doneCallback)
	{
		[self._doneTarget performSelector:self._doneCallback withObject:self];
  }
		
	[self animateOutView];
	
	// reset all values back to defaults
	self._inView = nil;
	[self setTitle:@""];
	[self setPlaceholderText:@""];
	[self setText:@""];
	self._inputField.keyboardType = UIKeyboardTypeDefault;
	
	return NO;
}

@end
