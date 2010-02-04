#import <UIKit/UIKit.h>

@protocol ImagePickerDelegate <NSObject>
@required
-(void)userPickedImage:(UIImage*)pickedImage;

@optional
-(bool)doNotResize;  // defaults to resizing the image
-(bool)scaledResize;  // defaults to nonscaled
-(bool)allowImageEditing; // defaults to not allowing image editing
-(void)pickerCancelled;
@end


@interface ImagePickerController : UIImagePickerController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> 
{
	@private
	id<ImagePickerDelegate> _rlDelegate;
	UIViewController* _hook;
}

@property (nonatomic, retain) id<ImagePickerDelegate> _rlDelegate;
@property (nonatomic, retain) UIViewController* _hook;

+(void)pickImageWithSourceType:(UIImagePickerControllerSourceType)sourceType rlDelegate:(id<ImagePickerDelegate>)rlDelegate hook:(UIViewController*)newHook;

// initialization methods
//-(id)initWithSourceType:(UIImagePickerControllerSourceType)newSourceType;

@end
