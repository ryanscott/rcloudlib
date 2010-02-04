#import <UIKit/UIKit.h>

@interface FieldEditController : UIViewController <UITextFieldDelegate>  
{
	UIToolbar* _titleBar;	
	UILabel* _titleLabel;
	
	UIBarButtonItem* _titleButton;
	UIBarButtonItem* _doneButton;
	UIBarButtonItem* _flexibleSpace;
	UIBarButtonItem* _fixedSpace;
	int _currentToolbar;
	
	UIImageView* _cellImage;
	UITextField* _inputField;
	
	id _doneTarget;
	SEL _doneCallback;
	void* _userContext;
	
	UIView* _inView;
}

@property (nonatomic, retain) UIToolbar* _titleBar;
@property (nonatomic, retain) UILabel* _titleLabel;
@property (nonatomic, retain) UIBarButtonItem* _titleButton;
@property (nonatomic, retain) UIBarButtonItem* _doneButton;
@property (nonatomic, retain) UIBarButtonItem* _flexibleSpace;
@property (nonatomic, retain) UIBarButtonItem* _fixedSpace;
@property (nonatomic, assign) int _currentToolbar;

@property (nonatomic, retain) UIImageView* _cellImage;
@property (nonatomic, retain) UITextField* _inputField;

@property (nonatomic, assign) id _doneTarget;
@property (nonatomic, assign) SEL _doneCallback;
@property (nonatomic, assign) void* _userContext;
@property (nonatomic, assign) UIView* _inView;

-(id)init;
-(id)initWithTarget:(id)callbackTarget doneCallback:(SEL)callbackMethod;

-(void)setTitle:(NSString*)newText;
-(void)setPlaceholderText:(NSString*)newText;
-(void)setText:(NSString*)newText;
-(void)setTarget:(id)newTarget callback:(SEL)newCallback;
-(void)setKeyboardType:(UIKeyboardType)newKeyboard;

-(void)showInView:(UIView*)inView;

-(NSString*)getText;

@end
