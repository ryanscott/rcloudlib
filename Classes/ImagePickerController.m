#import "ImagePickerController.h"
#import "rcloudlib.h"

@implementation ImagePickerController

static ImagePickerController* gImagePicker = nil;

@synthesize _rlDelegate;
@synthesize _hook;
@synthesize _ipActionSheet;
@synthesize _imagePicker;
@synthesize _safeToRelease;

#pragma mark Initialization

-(void)trySetSourceType:(UIImagePickerControllerSourceType)newSourceType
{
	// Attempt to use the requested source type...and fall back in order of usefulness
	if ([UIImagePickerController isSourceTypeAvailable:newSourceType])
	{
		self._imagePicker.sourceType = newSourceType;
	}
	else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
	{
		self._imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	}
	else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
	{
		self._imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	}
	else
	{
		RCLog(@"no picker type not available on device, not sure what to do");
	}	
}

-(id)initWithDelegate:(id<ImagePickerDelegate>)rlDelegate
{
	if ( self = [super init] )
	{
		_safeToRelease = true;
		_ipActionSheet = nil;
		_imagePicker = nil;
		_rlDelegate = rlDelegate;
	}

	return self;
}

-(void)initPicker
{
	if ( nil == self._imagePicker )
	{
		self._imagePicker = [[UIImagePickerController alloc] init];
		self._imagePicker.delegate = self;
	}

	if ( [_rlDelegate respondsToSelector:@selector(allowImageEditing)] )
		self._imagePicker.allowsImageEditing = [_rlDelegate allowImageEditing];
	else
		self._imagePicker.allowsImageEditing = NO;
}

- (void)dealloc 
{
	[_ipActionSheet release];
	[_imagePicker release];
	[super dealloc];
}

#pragma mark UIImagePickerControllerDelegate Methods

UIImage *scaleAndRotateImage(UIImage *image)
{
	int kMaxResolution = 480; // Or whatever
	
	CGImageRef imgRef = image.CGImage;
	
	CGFloat width = CGImageGetWidth(imgRef);
	CGFloat height = CGImageGetHeight(imgRef);
	
	CGAffineTransform transform = CGAffineTransformIdentity;
	CGRect bounds = CGRectMake(0, 0, width, height);
	if (width > kMaxResolution || height > kMaxResolution) {
		CGFloat ratio = width/height;
		if (ratio > 1) {
			bounds.size.width = kMaxResolution;
			bounds.size.height = bounds.size.width / ratio;
		}
		else {
			bounds.size.height = kMaxResolution;
			bounds.size.width = bounds.size.height * ratio;
		}
	}
	
	CGFloat scaleRatio = bounds.size.width / width;
	CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
	CGFloat boundHeight;
	UIImageOrientation orient = image.imageOrientation;
	switch(orient) {
			
		case UIImageOrientationUp: //EXIF = 1
			transform = CGAffineTransformIdentity;
			break;
			
		case UIImageOrientationUpMirrored: //EXIF = 2
			transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
			transform = CGAffineTransformScale(transform, -1.0, 1.0);
			break;
			
		case UIImageOrientationDown: //EXIF = 3
			transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
			transform = CGAffineTransformRotate(transform, M_PI);
			break;
			
		case UIImageOrientationDownMirrored: //EXIF = 4
			transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
			transform = CGAffineTransformScale(transform, 1.0, -1.0);
			break;
			
		case UIImageOrientationLeftMirrored: //EXIF = 5
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
			transform = CGAffineTransformScale(transform, -1.0, 1.0);
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
			break;
			
		case UIImageOrientationLeft: //EXIF = 6
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
			break;
			
		case UIImageOrientationRightMirrored: //EXIF = 7
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeScale(-1.0, 1.0);
			transform = CGAffineTransformRotate(transform, M_PI / 2.0);
			break;
			
		case UIImageOrientationRight: //EXIF = 8
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
			transform = CGAffineTransformRotate(transform, M_PI / 2.0);
			break;
			
		default:
			[NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
			
	}
	
	UIGraphicsBeginImageContext(bounds.size);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
		CGContextScaleCTM(context, -scaleRatio, scaleRatio);
		CGContextTranslateCTM(context, -height, 0);
	}
	else {
		CGContextScaleCTM(context, scaleRatio, -scaleRatio);
		CGContextTranslateCTM(context, 0, -height);
	}
	
	CGContextConcatCTM(context, transform);
	
	CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
	UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
		
	return imageCopy;
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{	
//	[[self parentViewController] dismissModalViewControllerAnimated:YES];
//	[gImagePicker._hook dismissModalViewControllerAnimated:YES];
	[self._hook dismissModalViewControllerAnimated:YES];
	
//	NSString *const UIImagePickerControllerMediaType;
//	NSString *const UIImagePickerControllerOriginalImage;
//	NSString *const UIImagePickerControllerEditedImage;
//	NSString *const UIImagePickerControllerCropRect;
//	NSString *const UIImagePickerControllerMediaURL;
	
	UIImage* pickedImage = nil;
	
	// TODO: this doesn't work in 2.0
//	if ( self.allowsImageEditing )
//		pickedImage = [info objectForKey:UIImagePickerControllerEditedImage];
//	else
		pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];

	[Util logSize:pickedImage.size sizeName:@"pickedImage::rcloudlib"];

	bool shouldResize = false;
	
	if ( [_rlDelegate respondsToSelector:@selector(doNotResize)] )
		shouldResize = ![_rlDelegate doNotResize];
		
	if ( shouldResize )
	{
		bool scaledResize = false;
		
		if ( [_rlDelegate respondsToSelector:@selector(scaledResize)] )
			scaledResize = [_rlDelegate scaledResize];

		// default to portrait
		CGFloat width = 320.0f;
		CGFloat height = 480.0f;

		// flip dimensions for landscape
		if ( pickedImage.size.width > pickedImage.size.height )
		{
			[Util swapf:&width with:&height];
		}
		
		if ( scaledResize )
		{		
			if ( pickedImage.size.height > pickedImage.size.width )
			{
				// portrait
				float aspect = pickedImage.size.height / pickedImage.size.width;
				
				if ( aspect > 1.5 )
					height = width * aspect;
				else
					width = height / aspect;
			}
			else
			{
				// landscape
				float aspect = pickedImage.size.width / pickedImage.size.height;
				
				// special case for square: make it 480x480 rather than 320x320, and let the imageview sort it out
				if ( 1 == aspect )
					width = height;
				else if( aspect > 1.5 )
					width = height * aspect;
				else
					height = width / aspect;
			}
		}
		
		// [ryan:5-3-9] if the imaage was taken with the camera, we always need to resize it
		if ( ( pickedImage.size.width != width ) || ( pickedImage.size.height != height ) || UIImagePickerControllerSourceTypeCamera == picker.sourceType )
		{
			CGSize newSize = CGSizeMake( width, height );
			[Util logSize:newSize sizeName:@"newsize::rcloudlib"];

			//pickedImage = [pickedImage scaleImageToSize:newSize];
			pickedImage = [Util imageWithImage:pickedImage scaledToSize:newSize];
//			UIImageOrientation newOrientation = height > width ? UIImageOrientationUp : UIImageOrientationRight;
//			pickedImage = [Util imageWithImage:pickedImage rotate:newOrientation scale:newSize];
		}		
	}
	
	[_rlDelegate userPickedImage:pickedImage];
	_safeToRelease = true;
//	[_rlDelegate userPickedImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
//	[[self parentViewController] dismissModalViewControllerAnimated:YES];
//	[gImagePicker._hook dismissModalViewControllerAnimated:YES];
	[self._hook dismissModalViewControllerAnimated:YES];
	
	if ( [_rlDelegate respondsToSelector:@selector(pickerCancelled)] )
		[_rlDelegate pickerCancelled];
	_safeToRelease = true;
}

-(void)pickImageWithSourceType:(UIImagePickerControllerSourceType)inSourceType
{
	[self initPicker];	
	[self trySetSourceType:inSourceType];
	[self._hook presentModalViewController:self._imagePicker animated:YES];				
}

-(void)initActionSheet
{
//	-(NSString*)actionSheetTitle;
//	-(NSString*)actionSheetCameraButtonTitle;
//	-(NSString*)actionSheetLibraryButtonTitle;
//	
//	NSString* sheet_title = @"";
//	
//	if ( [_rlDelegate respondsToSelector:@selector(doNotResize)] )
//		shouldResize = ![_rlDelegate doNotResize];

	NSString* sheetTitle = [_rlDelegate respondsToSelector:@selector(actionSheetTitle)] ? [_rlDelegate actionSheetTitle] : @"Choose a Photo";
	NSString* libraryButtonTitle = [_rlDelegate respondsToSelector:@selector(actionSheetLibraryButtonTitle)] ? [_rlDelegate actionSheetLibraryButtonTitle] : @"Choose Existing Photo";

	if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] )
	{
		NSString* cameraButtonTitle = [_rlDelegate respondsToSelector:@selector(actionSheetCameraButtonTitle)] ? [_rlDelegate actionSheetCameraButtonTitle] : @"Take New Photo";

		// open a dialog with two custom buttons
//		self._ipActionSheet = [[UIActionSheet alloc] initWithTitle:@"Match Paint Color from Photo"
//																											delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil
//																						 otherButtonTitles:@"Take New Photo", @"Choose Existing Photo", @"Cancel", nil];
		self._ipActionSheet = [[UIActionSheet alloc] initWithTitle:sheetTitle
																											delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil
																						 otherButtonTitles:cameraButtonTitle, libraryButtonTitle, @"Cancel", nil];
		self._ipActionSheet.destructiveButtonIndex = 2;	// make the second button red (destructive)
	}
	else
	{
		self._ipActionSheet = [[UIActionSheet alloc] initWithTitle:sheetTitle
																													delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil
																								 otherButtonTitles:libraryButtonTitle, @"Cancel", nil];
		self._ipActionSheet.destructiveButtonIndex = 1;	// make the second button red (destructive)
	}
	
	self._ipActionSheet.actionSheetStyle = UIActionSheetStyleDefault;
}


#pragma mark UIActionSheetDelegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	// buttonIndex -> actions list:
	// 0 -> Take New Photo
	// 1 -> Choose Existing Photo
	// 2 -> Cancel
	
	if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] )
	{
		if ( 0 == buttonIndex )
		{
			[self pickImageWithSourceType:UIImagePickerControllerSourceTypeCamera];
		}
		else if ( 1 == buttonIndex )
		{
			[self pickImageWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
		}
	}
	else if ( 0 == buttonIndex )
	{
		[self pickImageWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
	}
}

#pragma mark API Methods

+(void)pickImageWithSourceType:(UIImagePickerControllerSourceType)inSourceType rlDelegate:(id<ImagePickerDelegate>)rlDelegate hook:(UIViewController*)newHook
{
	if ( nil == gImagePicker )
		gImagePicker = [[ImagePickerController alloc] initWithDelegate:rlDelegate];
	else
	{
		gImagePicker._rlDelegate = rlDelegate;
	}
	[gImagePicker initPicker];
	
	[gImagePicker trySetSourceType:inSourceType];
	gImagePicker._hook = newHook;
	
	gImagePicker._safeToRelease = false;
	[gImagePicker._hook presentModalViewController:gImagePicker._imagePicker animated:YES];				
}

+(void)pickImageInView:(UIView*)inView rlDelegate:(id<ImagePickerDelegate>)rlDelegate hook:(UIViewController*)newHook
{
	if ( nil == gImagePicker )
		gImagePicker = [[ImagePickerController alloc] initWithDelegate:rlDelegate];
	else
	{
		gImagePicker._rlDelegate = rlDelegate;		
	}
	gImagePicker._hook = newHook;
	
	if ( nil == gImagePicker._ipActionSheet )
		[gImagePicker initActionSheet];
	
	gImagePicker._safeToRelease = false;	
	[gImagePicker._ipActionSheet showInView:inView];
}

+(void)freeMemory
{
	if ( nil != gImagePicker && gImagePicker._safeToRelease )
		[gImagePicker release];
}


@end
