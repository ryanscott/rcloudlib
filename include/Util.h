#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#if (DEBUG || ADHOC)
#define RCLog(format, ...) [Util log:[NSString stringWithFormat:@"<%@:(%d) %p::%s> %@",[[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, self, __PRETTY_FUNCTION__, [NSString stringWithFormat:format, ##__VA_ARGS__] ]]
#else
#define RCLog(format, ...)
#endif

#ifdef DEBUG
#define RCLogIf(condition, xx, ...) { if ((condition)) { \
RCLog(xx, ##__VA_ARGS__); \
} \
}
#else
#define RCLogIf(condition, xx, ...)
#endif

#ifdef DEBUG
#define RCAssert(xx) { if(!(xx)) { TTDPRINT(@"assert failed: %s", #xx); } }
#else
#define RCAssert(xx)
#endif


@interface Util : NSObject 
{

}

+(void)freeMemory;

+(void)randomize;

// Image
+(UIImage*)loadImage:(NSString*)imageName;
+(UIImage*)loadImageCached:(NSString*)imageName;
+(UIImage*)loadImageNoCache:(NSString*)imageName;

+(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
//+(UIImage*)imageWithImage:(UIImage*)image rotate:(UIImageOrientation)orient scale:(CGSize)newSize; 

// Bitmap
+(CGContextRef)CreateARGBBitmapContext:(CGImageRef)inImage size:(CGSize)inSize;
+(unsigned char*)RequestImagePixelData:(UIImage*)inImage;

// File
+(NSString *)generateFullPathFromFilename:(NSString *) filename;

// String
+(NSString*)filterConsecutiveNewlines:(NSString*)stringToFilter;
+(bool)stringNotEmpty:(NSString*)str;

// UITextField
+(void)setField:(UITextField*)tf fromString:(NSString*)newString;

// Convenience
+(void)simpleAlertWithTitle:(NSString*)title message:(NSString*)message;
+(NSString*)createUUID;

// Logging
+(void)log:(NSString*)nsLogString;
+(void)logRect:(CGRect)rectToLog rectName:(NSString*)rectName;
+(void)logSize:(CGSize)sizeToLog sizeName:(NSString*)sizeName;

// View
+(void)constrainToView:(UIView*)view item:(UIView*)item;

// Accelerometer
+(BOOL)accelerationIsShaking:(UIAcceleration*)last current:(UIAcceleration*)current threshold:(double)threshold;

// Math
+(CGPoint)centerPointBetweenTwoPoints:(CGPoint)firstPoint secondPoint:(CGPoint)secondPoint;
+(CGFloat)distanceBetweenTwoPoints:(CGPoint)fromPoint toPoint:(CGPoint)toPoint;

+(void)swapf:(CGFloat*)v1 with:(CGFloat*)v2;

+(int)boundi_floor:(int)x floor_val:(int)floor_val;
+(int)boundi_ceil:(int)x ceil_val:(int)ceil_val;
+(int)boundi_floor_zero:(int)x;

+(float)boundf_floor:(float)x floor_val:(float)floor_val;
+(float)boundf_ceil:(float)x ceil_val:(float)ceil_val;
+(float)boundf_floor_zero:(float)x;



@end
