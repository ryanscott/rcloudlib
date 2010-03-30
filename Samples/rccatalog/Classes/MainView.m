#import "MainView.h"
#import "rcloud.h"
#import "UIImageAdditions.h"
#import <QuartzCore/QuartzCore.h>

@implementation MainView

@synthesize _drawButton;

#pragma mark Initialization

-(void)initControls
{
//	CGFloat x = 10.0f;
	CGFloat x = 160.0f;
	CGFloat y = 10.0f;
	CGFloat width = 135.0f;
	CGFloat height = 35.0f;
	
	CGRect l_frame = CGRectMake(x, y, width, height);
	
	self._drawButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[self._drawButton setFrame:l_frame];
	[self._drawButton setTitle:@"run test" forState:UIControlStateNormal];
	[self._drawButton addTarget:self action:@selector(clickedDraw) forControlEvents:UIControlEventTouchUpInside];

}

-(id)init
{
	if ( self = [super init] )
	{
		[self initControls];
	}
	return self;
}

-(void)loadView 
{
	CGRect content_frame = [[UIScreen mainScreen] applicationFrame];
	UIView *content_view = [[UIView alloc] initWithFrame:content_frame];
	content_view.backgroundColor = [UIColor whiteColor];
	self.view = content_view;
	[content_view release];
}

-(void)addSubviews
{
	[self.view addSubview:self._drawButton];
}

-(void)viewDidLoad 
{
	[self addSubviews];
	[super viewDidLoad];
}

- (void)didReceiveMemoryWarning 
{
	[super didReceiveMemoryWarning];
}

- (void)dealloc 
{
	[_drawButton release];
	[super dealloc];
}

#pragma mark Implementation Methods

#pragma mark Button Handlers

-(void)clickedDraw
{
//	UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];  
	//	imagePicker.delegate = self;
//#if TARGET_IPHONE_SIMULATOR
//	imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//#else
//	imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//#endif	
//	[self presentModalViewController:imagePicker animated:YES];
//	[imagePicker release];

#if TARGET_IPHONE_SIMULATOR
	[ImagePickerController pickImageWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary rlDelegate:self hook:self];
#else
	[ImagePickerController pickImageWithSourceType:UIImagePickerControllerSourceTypeCamera rlDelegate:self hook:self];
#endif	

	return;
	
//	UIImage* icon = [Util loadImage:@"Icon"];
////	icon = [icon roundCorners:15.0f];
//
//	UIImageView* iconView = [[UIImageView alloc] initWithImage:icon];
//	[iconView setOrigin:CGPointZero];
//	
//	iconView.layer.cornerRadius = 15.0f;
//	iconView.layer.masksToBounds = YES;
//
//	[self.view addSubview:iconView];
	
//	[icon drawInRect:CGRectMake(20.0f, 100.0f, 57.0f, 57.0f)];
//	[iconView.image drawInRect:CGRectMake(20.0f, 100.0f, 57.0f, 57.0f)];
//	[iconView.image drawInRect:CGRectMake(5.0f, 5.0f, 57.0f, 57.0f)];
//	[icon drawInRect:CGRectMake(20.0f, 200.0f, 57.0f, 57.0f) radius:5.0f];
}

#pragma mark ImagePickerController delegate methods

-(void)userPickedImage:(UIImage*)pickedImage
{
//	UIImage* icon = [Util loadImage:@"Icon"];
	//	icon = [icon roundCorners:15.0f];
	
//	UIImageView* iconView = [[UIImageView alloc] initWithImage:pickedImage];
//	[iconView setOrigin:CGPointMake(10.0f, 450.0f)];	
//	iconView.layer.cornerRadius = 15.0f;
//	iconView.layer.masksToBounds = YES;
//	
//	[self.view addSubview:iconView];	
	
//	UIImageView* smallerImageView = [[UIImageView alloc] initWithImage:[pickedImage roundCorners:15.0f]];

	UIImageView* smallerImageView = [[UIImageView alloc] initWithImage:[[pickedImage transformWidth:300.0f height:300.0f rotate:NO] roundCorners:15.0f]];
	[smallerImageView setOrigin:CGPointMake(10.0f, 100.0f)];	
	
	[self.view addSubview:smallerImageView];	
	
	[BusyViewController performSelector:@selector(show) withObject:nil afterDelay:5.0];
}



@end
