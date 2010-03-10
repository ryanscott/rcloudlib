#import <UIKit/UIKit.h>

@protocol ImagePickerDelegate <NSObject>
@required
-(void)userPickedImage:(UIImage*)pickedImage;

@optional
-(bool)doNotResize;  // defaults to resizing the image
-(bool)scaledResize;  // defaults to nonscaled
-(bool)allowImageEditing; // defaults to not allowing image editing
-(void)pickerCancelled;

// these are all to customize the display of the action sheet, only used via +pickImageInView 
-(NSString*)actionSheetTitle;
-(NSString*)actionSheetCameraButtonTitle;
-(NSString*)actionSheetLibraryButtonTitle;

@end


//@interface ImagePickerController : UIImagePickerController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> 
@interface ImagePickerController : NSObject <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> 
{
	@private
	id<ImagePickerDelegate> _rlDelegate;
	UIViewController* _hook;
	
	UIActionSheet* _ipActionSheet;
	UIImagePickerController* _imagePicker;
	
	// this is just a flag to determine if we can safely free the memory if we get a low-memory warning
	bool _safeToRelease;
}

@property (nonatomic, retain) id<ImagePickerDelegate> _rlDelegate;
@property (nonatomic, retain) UIViewController* _hook;

@property (nonatomic, retain) UIActionSheet* _ipActionSheet;
@property (nonatomic, retain) UIImagePickerController* _imagePicker;
@property (nonatomic, assign) bool _safeToRelease;

+(void)pickImageWithSourceType:(UIImagePickerControllerSourceType)inSourceType rlDelegate:(id<ImagePickerDelegate>)rlDelegate hook:(UIViewController*)newHook;

+(void)pickImageInView:(UIView*)inView rlDelegate:(id<ImagePickerDelegate>)rlDelegate hook:(UIViewController*)newHook;

+(void)freeMemory;

@end
