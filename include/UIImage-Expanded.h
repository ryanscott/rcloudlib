#import <UIKit/UIKit.h>

@interface UIImage (INResizeImageAllocator)

- (UIImage*)scaleImageToSize:(CGSize)newSize;
- (UIImage*)rotate:(UIImageOrientation)orient scale:(CGSize)newSize; 

@end
