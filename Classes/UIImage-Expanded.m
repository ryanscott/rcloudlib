#import "UIImage-Expanded.h"
#import "Util.h"

static CGRect swapWidthAndHeight(CGRect rect)
{
	CGFloat  swap = rect.size.width;
	
	rect.size.width  = rect.size.height;
	rect.size.height = swap;
	
	return rect;
}


@implementation UIImage (INResizeImageAllocator)

- (UIImage*)scaleImageToSize:(CGSize)newSize
{
	return [Util imageWithImage:self scaledToSize:newSize];
}

-(UIImage*)rotate:(UIImageOrientation)orient scale:(CGSize)newSize
{
	CGRect             bnds = CGRectZero;
	UIImage*           copy = nil;
	CGContextRef       ctxt = nil;
	CGImageRef         imag = self.CGImage;
	CGRect             rect = CGRectZero;
	CGAffineTransform  tran = CGAffineTransformIdentity;
	
//	rect.size.width  = CGImageGetWidth(imag);
//	rect.size.height = CGImageGetHeight(imag);
	rect.size.width  = newSize.width;
	rect.size.height = newSize.height;
	
	bnds = rect;
	CGFloat scaleRatio = bnds.size.width / self.size.width;
	
	switch (orient)
	{
		case UIImageOrientationUp:
			tran = CGAffineTransformIdentity;
			break;
			
		case UIImageOrientationUpMirrored:
			tran = CGAffineTransformMakeTranslation(rect.size.width, 0.0);
			tran = CGAffineTransformScale(tran, -1.0, 1.0);
			break;
			
		case UIImageOrientationDown:
			tran = CGAffineTransformMakeTranslation(rect.size.width,
																							rect.size.height);
			tran = CGAffineTransformRotate(tran, M_PI);
			break;
			
		case UIImageOrientationDownMirrored:
			tran = CGAffineTransformMakeTranslation(0.0, rect.size.height);
			tran = CGAffineTransformScale(tran, 1.0, -1.0);
			break;
			
		case UIImageOrientationLeft:
			bnds = swapWidthAndHeight(bnds);
			tran = CGAffineTransformMakeTranslation(0.0, rect.size.width);
			tran = CGAffineTransformRotate(tran, 3.0 * M_PI / 2.0);
			break;
			
		case UIImageOrientationLeftMirrored:
			bnds = swapWidthAndHeight(bnds);
			tran = CGAffineTransformMakeTranslation(rect.size.height,
																							rect.size.width);
			tran = CGAffineTransformScale(tran, -1.0, 1.0);
			tran = CGAffineTransformRotate(tran, 3.0 * M_PI / 2.0);
			break;
			
		case UIImageOrientationRight:
			bnds = swapWidthAndHeight(bnds);
			tran = CGAffineTransformMakeTranslation(rect.size.height, 0.0);
			tran = CGAffineTransformRotate(tran, M_PI / 2.0);
			break;
			
		case UIImageOrientationRightMirrored:
			bnds = swapWidthAndHeight(bnds);
			tran = CGAffineTransformMakeScale(-1.0, 1.0);
			tran = CGAffineTransformRotate(tran, M_PI / 2.0);
			break;
			
		default:
			// orientation value supplied is invalid
			assert(false);
			return nil;
	}
	
	UIGraphicsBeginImageContext(bnds.size);
	ctxt = UIGraphicsGetCurrentContext();
	
	switch (orient)
	{
		case UIImageOrientationLeft:
		case UIImageOrientationLeftMirrored:
		case UIImageOrientationRight:
		case UIImageOrientationRightMirrored:
//			CGContextScaleCTM(ctxt, -1.0, 1.0);
			CGContextScaleCTM(ctxt, -scaleRatio, scaleRatio);
			CGContextTranslateCTM(ctxt, -rect.size.height, 0.0);
			break;
			
		default:
//			CGContextScaleCTM(ctxt, 1.0, -1.0);
			CGContextScaleCTM(ctxt, scaleRatio, -scaleRatio);
			CGContextTranslateCTM(ctxt, 0.0, -rect.size.height);
			break;
	}
	
	CGContextConcatCTM(ctxt, tran);
	CGContextDrawImage(UIGraphicsGetCurrentContext(), rect, imag);
	
	copy = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return copy;
}

@end
