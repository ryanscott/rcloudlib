#import "Util.h"

static CGRect swapWidthAndHeight(CGRect rect)
{
	CGFloat  swap = rect.size.width;
	
	rect.size.width  = rect.size.height;
	rect.size.height = swap;
	
	return rect;
}

static NSMutableDictionary* __imageCache = nil;

@implementation Util

+(void)randomize
{
	srandom(time(NULL));
}

#pragma mark Image

+(void)initImageCache
{
	__imageCache = [[NSMutableDictionary alloc] initWithCapacity:10];
}

+ (UIImage*)loadImage:(NSString*)imageName
{
	NSString *fileLocation = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
	return [UIImage imageWithContentsOfFile:fileLocation];	
}

+ (UIImage*)loadImageCached:(NSString*)imageName
{
	NSString *fileLocation = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];

	if ( nil == __imageCache )
		[Util initImageCache];
	
	UIImage* cached_image = [__imageCache objectForKey:imageName];
	if ( nil == cached_image )
	{
		cached_image = [UIImage imageWithContentsOfFile:fileLocation];
		[__imageCache setObject:cached_image forKey:imageName];
	}
	
	return cached_image;
	
//	NSString* image_name_full = [imageName stringByAppendingString:@".png"];
//	return [UIImage imageNamed:image_name_full]; 
}

+(UIImage*)loadImageNoCache:(NSString*)imageName;
{
	[Util log:@"Util::LoadImageNoCache is deprecated, just use loadImage, it executes the exact same code"];
	return [self loadImage:imageName];
//	NSString *fileLocation = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
//	return [UIImage imageWithContentsOfFile:fileLocation];
}

+(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
	if ( newSize.height > newSize.width )
	{
		UIGraphicsBeginImageContext( newSize );
		[image drawInRect:CGRectMake( 0, 0, newSize.width, newSize.height)];
		UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		
		return newImage;
	}
	else
	{
		UIGraphicsBeginImageContext(newSize);
		
		CGContextRef context = UIGraphicsGetCurrentContext();
		CGContextTranslateCTM(context, 0, newSize.height);
		CGContextScaleCTM(context, 1.0, -1.0);
		CGContextDrawImage(context, CGRectMake( 0, 0, newSize.width, newSize.height), image.CGImage);
		UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
		
		UIGraphicsEndImageContext();
		return scaledImage;
	}
}

//+(UIImage*)imageWithImage:(UIImage*)image rotate:(UIImageOrientation)orient scale:(CGSize)newSize
//{
//
//	CGRect             bnds = CGRectZero;
//	UIImage*           copy = nil;
//	CGContextRef       ctxt = nil;
//	CGImageRef         imag = image.CGImage;
//	CGRect             rect = CGRectZero;
//	CGAffineTransform  tran = CGAffineTransformIdentity;
//	
//	//	rect.size.width  = CGImageGetWidth(imag);
//	//	rect.size.height = CGImageGetHeight(imag);
//	rect.size.width  = newSize.width;
//	rect.size.height = newSize.height;
//	
//	bnds = rect;
//	CGFloat scaleRatio = bnds.size.width / image.size.width;
//
////	switch (orient)
////	{
////		case UIImageOrientationUp:
////			tran = CGAffineTransformIdentity;
////			break;
////			
////		case UIImageOrientationUpMirrored:
////			tran = CGAffineTransformMakeTranslation(rect.size.width, 0.0);
////			tran = CGAffineTransformScale(tran, -1.0, 1.0);
////			break;
////			
////		case UIImageOrientationDown:
////			tran = CGAffineTransformMakeTranslation(rect.size.width,
////																							rect.size.height);
////			tran = CGAffineTransformRotate(tran, M_PI);
////			break;
////			
////		case UIImageOrientationDownMirrored:
////			tran = CGAffineTransformMakeTranslation(0.0, rect.size.height);
////			tran = CGAffineTransformScale(tran, 1.0, -1.0);
////			break;
////			
////		case UIImageOrientationLeft:
////			//bnds = swapWidthAndHeight(bnds);
////			tran = CGAffineTransformMakeTranslation(0.0, rect.size.width);
////			tran = CGAffineTransformRotate(tran, 3.0 * M_PI / 2.0);
////			break;
////			
////		case UIImageOrientationLeftMirrored:
////			//bnds = swapWidthAndHeight(bnds);
////			tran = CGAffineTransformMakeTranslation(rect.size.height,
////																							rect.size.width);
////			tran = CGAffineTransformScale(tran, -1.0, 1.0);
////			tran = CGAffineTransformRotate(tran, 3.0 * M_PI / 2.0);
////			break;
////			
////		case UIImageOrientationRight:
////			//bnds = swapWidthAndHeight(bnds);
////			tran = CGAffineTransformMakeTranslation(rect.size.height, 0.0);
////			tran = CGAffineTransformRotate(tran, M_PI / 2.0);
////			break;
////			
////		case UIImageOrientationRightMirrored:
////			//bnds = swapWidthAndHeight(bnds);
////			tran = CGAffineTransformMakeScale(-1.0, 1.0);
////			tran = CGAffineTransformRotate(tran, M_PI / 2.0);
////			break;
////			
////		default:
////			// orientation value supplied is invalid
////			assert(false);
////			return nil;
////	}
//	
//	UIGraphicsBeginImageContext(bnds.size);
//	ctxt = UIGraphicsGetCurrentContext();
//	
//	switch (orient)
//	{
//		case UIImageOrientationLeft:
//		case UIImageOrientationLeftMirrored:
//		case UIImageOrientationRight:
//		case UIImageOrientationRightMirrored:
//			//			CGContextScaleCTM(ctxt, -1.0, 1.0);
//			CGContextScaleCTM(ctxt, -scaleRatio, scaleRatio);
//			CGContextTranslateCTM(ctxt, -rect.size.height, 0.0);
//			
//			break;
//			
//		default:
//			//			CGContextScaleCTM(ctxt, 1.0, -1.0);
//			CGContextScaleCTM(ctxt, scaleRatio, -scaleRatio);
//			CGContextTranslateCTM(ctxt, 0.0, -rect.size.height);
//			break;
//	}
//	
//	CGContextConcatCTM(ctxt, tran);
//	CGContextDrawImage(UIGraphicsGetCurrentContext(), rect, imag);
//	
//	copy = UIGraphicsGetImageFromCurrentImageContext();
//	UIGraphicsEndImageContext();
//	
//	return copy;
//}

#pragma mark Bitmap

+(CGContextRef)CreateARGBBitmapContext:(CGImageRef)inImage size:(CGSize)inSize
{
	CGContextRef    context = NULL;
	CGColorSpaceRef colorSpace;
	void *          bitmapData;
	int             bitmapByteCount;
	int             bitmapBytesPerRow;
	
	size_t pixelsWide = inSize.width;
	size_t pixelsHigh = inSize.height;
	bitmapBytesPerRow   = (pixelsWide * 4);
	bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
	colorSpace = CGColorSpaceCreateDeviceRGB();
	
	if (colorSpace == NULL)
	{
		fprintf(stderr, "Error allocating color space\n");
		return NULL;
	}
	
	// allocate the bitmap & create context
	bitmapData = malloc( bitmapByteCount );
	if (bitmapData == NULL)
	{
		fprintf (stderr, "Memory not allocated!");
		CGColorSpaceRelease( colorSpace );
		return NULL;
	}
	
	context = CGBitmapContextCreate (bitmapData, pixelsWide, pixelsHigh, 8,
																	 bitmapBytesPerRow, colorSpace,
																	 kCGImageAlphaPremultipliedFirst);
	if (context == NULL)
	{
		free (bitmapData);
		fprintf (stderr, "Context not created!");
	}
	
	CGColorSpaceRelease( colorSpace );
	return context;	
}

+(unsigned char*)RequestImagePixelData:(UIImage*)inImage
{
	CGImageRef img = [inImage CGImage];
	CGSize size = [inImage size];
	
	CGContextRef cgctx = [Util CreateARGBBitmapContext:img size:size];
	if (cgctx == NULL) return NULL;
	
	CGRect rect = {{0,0},{size.width, size.height}};
	CGContextDrawImage(cgctx, rect, img);
	unsigned char *data = CGBitmapContextGetData (cgctx);
	CGContextRelease(cgctx);
	
	return data;
}

#pragma mark File
// File
+(NSString *)generateFullPathFromFilename:(NSString *) filename {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *docDir = [paths objectAtIndex: 0];
	NSString *result = [docDir stringByAppendingPathComponent: filename];
	return result;
}

#pragma mark String
// String
+(NSString*)filterConsecutiveNewlines:(NSString*)stringToFilter
{
	int len = [stringToFilter length];
	unichar lastChar;
	unichar curChar;
	NSMutableString* goodLabel = [[NSMutableString alloc] initWithCapacity:len];
	
	for ( int i = 0; i < len; i++)
	{
		curChar = [stringToFilter characterAtIndex:i];
		if ( i == 0 )
			lastChar = curChar;
		
		if (curChar != '\n' || lastChar != '\n') 
		{
			[goodLabel appendFormat:@"%C",curChar];
		}
		
		lastChar = curChar;			
	}
	
	return goodLabel;
}

+(bool)stringNotEmpty:(NSString*)str
{
	NSString* no_white = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

	return ( ( nil != str ) &&  ([str length] > 0 ) && ([no_white length] > 0 ) );
}

#pragma mark UITextField

+(void)setField:(UITextField*)tf fromString:(NSString*)newString
{
	if ( nil != tf )
	{
		if ( ( nil != newString  ) )
			tf.text = newString;
		else
			tf.text = @"";
	}
}

#pragma mark Convenience

+ (void)simpleAlertWithTitle:(NSString*)title message:(NSString*)message
{
	// open an alert with just an OK button
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message
												   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];	
	[alert release];
}

+(NSString*)createUUID
{
	CFUUIDRef uid = CFMakeCollectable(CFUUIDCreate(NULL));
	CFStringRef uidStr = CFMakeCollectable(CFUUIDCreateString(NULL, uid));
	NSString* newuid = [[NSString alloc] initWithString:(NSString *)uidStr];
	[(id)uid release];
	[(id)uidStr release];
	
	return newuid;
}

#pragma mark Logging

+(void)log:(NSString*)nsLogString
{
#ifdef DEBUG
	//NSLog(nsLogString);
	NSLog( @"<%@:(%d) %p::%s> %@",  [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, self, __PRETTY_FUNCTION__, nsLogString );
#endif	
}

+(void)logRect:(CGRect)rectToLog rectName:(NSString*)rectName
{
	if ( nil != rectName )
		RCLog(@"Rect %@ dimensions: origin( %.1f, %.1f ) :: width:%.1f height:%.1f", rectName, rectToLog.origin.x, rectToLog.origin.y, rectToLog.size.width, rectToLog.size.height );
	else
		RCLog(@"Rect dimensionts: origin( %.1f, %.1f ) :: width:%.1f height:%.1f", rectToLog.origin.x, rectToLog.origin.y, rectToLog.size.width, rectToLog.size.height );
}

+(void)logSize:(CGSize)sizeToLog sizeName:(NSString*)sizeName
{	
	if ( nil != sizeName )
		RCLog(@"Size %@ dimensions :: width:%.1f height:%.1f", sizeName, sizeToLog.width, sizeToLog.height );
	else
		RCLog(@"Size dimensions :: width:%.1f height:%.1f", sizeToLog.width, sizeToLog.height );
}
	
#pragma mark View Methods

+(void)constrainToView:(UIView*)view item:(UIView*)item
{
	CGRect itemFrame = [item frame];
	CGRect viewFrame = [view frame];
	
	CGFloat itemFrameRight = itemFrame.origin.x + itemFrame.size.width;
	CGFloat itemFrameBottom = itemFrame.origin.y + itemFrame.size.height;
	
	CGFloat viewFrameRight = viewFrame.size.width;
	CGFloat viewFrameBottom = viewFrame.size.height;
	
	if ( itemFrame.origin.x < 0.0 )
		itemFrame.origin.x = 0.0;
	if ( itemFrame.origin.y < 0.0 )
		itemFrame.origin.y = 0.0;
	if ( itemFrameRight > viewFrameRight )
		itemFrame.origin.x -= itemFrameRight - viewFrameRight;
	if ( itemFrameBottom > viewFrameBottom )
		itemFrame.origin.y -= itemFrameBottom - viewFrameBottom;
	
	[item setFrame:itemFrame];
}

#pragma mark Accelerometer Methods

+(BOOL)accelerationIsShaking:(UIAcceleration*)last current:(UIAcceleration*)current threshold:(double)threshold
{
	double
	deltaX = fabs(last.x - current.x),
	deltaY = fabs(last.y - current.y),
	deltaZ = fabs(last.z - current.z);
	
	return
	(deltaX > threshold && deltaY > threshold) ||
	(deltaX > threshold && deltaZ > threshold) ||
	(deltaY > threshold && deltaZ > threshold);
}


#pragma mark Math Point methods

+(CGPoint)centerPointBetweenTwoPoints:(CGPoint)firstPoint secondPoint:(CGPoint)secondPoint 
{
	float dx = fabs( firstPoint.x - secondPoint.x);
	float dy = fabs( firstPoint.y - secondPoint.y);
	
	float x =  firstPoint.x > secondPoint.x ? secondPoint.x : firstPoint.x;
	float y =  firstPoint.y > secondPoint.y ? secondPoint.y : firstPoint.y;
	
	return CGPointMake( x + (dx/2), y + (dy/2) );
}

+(CGFloat)distanceBetweenTwoPoints:(CGPoint)fromPoint toPoint:(CGPoint)toPoint {	
	float x = toPoint.x - fromPoint.x;
	float y = toPoint.y - fromPoint.y;
	
	return sqrt(x * x + y * y);
}

#pragma mark utility Float methods

+(void)swapf:(CGFloat*)v1 with:(CGFloat*)v2
{
	CGFloat t = *v1;
	*v1 = *v2;
	*v2 = t;
}

#pragma mark int bound methods

+(int)boundi_floor:(int)x floor_val:(int)floor_val
{
	return ( x < floor_val ) ? floor_val : x;
}

+(int)boundi_ceil:(int)x ceil_val:(int)ceil_val
{
	return ( x > ceil_val ) ? ceil_val : x;
}

+(int)boundi_floor_zero:(int)x
{
	return ( x < 0 ) ? 0 : x;
}

#pragma mark float bound methods

+(float)boundf_floor:(float)x floor_val:(float)floor_val
{
	return ( x < floor_val ) ? floor_val : x;
}

+(float)boundf_ceil:(float)x ceil_val:(float)ceil_val
{
	return ( x > ceil_val ) ? ceil_val : x;
}

+(float)boundf_floor_zero:(float)x
{
	return ( x < 0.0 ) ? 0.0 : x;
}

@end

