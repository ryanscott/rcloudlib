#import "UIImageAdditions.h"

/**
 * Additions.
 */
@implementation UIImage (TTCategory)

///////////////////////////////////////////////////////////////////////////////////////////////////
// private

- (void)addRoundedRectToPath:(CGContextRef)context rect:(CGRect)rect radius:(float)radius {
  CGContextBeginPath(context);
  CGContextSaveGState(context);

  if (radius == 0) {
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextAddRect(context, rect);
  } else {
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, radius, radius);
    float fw = CGRectGetWidth(rect) / radius;
    float fh = CGRectGetHeight(rect) / radius;
    
    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
  }

  CGContextClosePath(context);
  CGContextRestoreGState(context);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// public

- (UIImage*)transformWidth:(CGFloat)width height:(CGFloat)height rotate:(BOOL)rotate {
  CGFloat destW = width;
  CGFloat destH = height;
  CGFloat sourceW = width;
  CGFloat sourceH = height;
  if (rotate) {
    if (self.imageOrientation == UIImageOrientationRight
        || self.imageOrientation == UIImageOrientationLeft) {
      sourceW = height;
      sourceH = width;
    }
  }
  
  CGImageRef imageRef = self.CGImage;
  CGContextRef bitmap = CGBitmapContextCreate(NULL, destW, destH,
    CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), CGImageGetColorSpace(imageRef),
    CGImageGetBitmapInfo(imageRef));

  if (rotate) {
    if (self.imageOrientation == UIImageOrientationDown) {
      CGContextTranslateCTM(bitmap, sourceW, sourceH);
      CGContextRotateCTM(bitmap, 180 * (M_PI/180));
    } else if (self.imageOrientation == UIImageOrientationLeft) {
      CGContextTranslateCTM(bitmap, sourceH, 0);
      CGContextRotateCTM(bitmap, 90 * (M_PI/180));
    } else if (self.imageOrientation == UIImageOrientationRight) {
      CGContextTranslateCTM(bitmap, 0, sourceW);
      CGContextRotateCTM(bitmap, -90 * (M_PI/180));
    }
  }

  CGContextDrawImage(bitmap, CGRectMake(0,0,sourceW,sourceH), imageRef);

  CGImageRef ref = CGBitmapContextCreateImage(bitmap);
  UIImage* result = [UIImage imageWithCGImage:ref];
  CGContextRelease(bitmap);
  CGImageRelease(ref);

  return result;
}

- (CGRect)convertRect:(CGRect)rect withContentMode:(UIViewContentMode)contentMode {
  if (self.size.width != rect.size.width || self.size.height != rect.size.height) {
    if (contentMode == UIViewContentModeLeft) {
      return CGRectMake(rect.origin.x,
                        rect.origin.y + floor(rect.size.height/2 - self.size.height/2),
                        self.size.width, self.size.height);
    } else if (contentMode == UIViewContentModeRight) {
      return CGRectMake(rect.origin.x + (rect.size.width - self.size.width),
                        rect.origin.y + floor(rect.size.height/2 - self.size.height/2),
                        self.size.width, self.size.height);
    } else if (contentMode == UIViewContentModeTop) {
      return CGRectMake(rect.origin.x + floor(rect.size.width/2 - self.size.width/2),
                        rect.origin.y,
                        self.size.width, self.size.height);
    } else if (contentMode == UIViewContentModeBottom) {
      return CGRectMake(rect.origin.x + floor(rect.size.width/2 - self.size.width/2),
                        rect.origin.y + floor(rect.size.height - self.size.height),
                        self.size.width, self.size.height);
    } else if (contentMode == UIViewContentModeCenter) {
      return CGRectMake(rect.origin.x + floor(rect.size.width/2 - self.size.width/2),
                        rect.origin.y + floor(rect.size.height/2 - self.size.height/2),
                        self.size.width, self.size.height);
    } else if (contentMode == UIViewContentModeBottomLeft) {
      return CGRectMake(rect.origin.x,
                        rect.origin.y + floor(rect.size.height - self.size.height),
                        self.size.width, self.size.height);
    } else if (contentMode == UIViewContentModeBottomRight) {
      return CGRectMake(rect.origin.x + (rect.size.width - self.size.width),
                        rect.origin.y + (rect.size.height - self.size.height),
                        self.size.width, self.size.height);
    } else if (contentMode == UIViewContentModeTopLeft) {
      return CGRectMake(rect.origin.x,
                        rect.origin.y,
                        
                        self.size.width, self.size.height);
    } else if (contentMode == UIViewContentModeTopRight) {
      return CGRectMake(rect.origin.x + (rect.size.width - self.size.width),
                        rect.origin.y,
                        self.size.width, self.size.height);
    } else if (contentMode == UIViewContentModeScaleAspectFill) {
      CGSize imageSize = self.size;
      if (imageSize.height < imageSize.width) {
        imageSize.width = floor((imageSize.width/imageSize.height) * rect.size.height);
        imageSize.height = rect.size.height;
      } else {
        imageSize.height = floor((imageSize.height/imageSize.width) * rect.size.width);
        imageSize.width = rect.size.width;
      }
      return CGRectMake(rect.origin.x + floor(rect.size.width/2 - imageSize.width/2),
                        rect.origin.y + floor(rect.size.height/2 - imageSize.height/2),
                        imageSize.width, imageSize.height);
    } else if (contentMode == UIViewContentModeScaleAspectFit) {
      CGSize imageSize = self.size;
      if (imageSize.height < imageSize.width) {
        imageSize.height = floor((imageSize.height/imageSize.width) * rect.size.width);
        imageSize.width = rect.size.width;
      } else {
        imageSize.width = floor((imageSize.width/imageSize.height) * rect.size.height);
        imageSize.height = rect.size.height;
      }
      return CGRectMake(rect.origin.x + floor(rect.size.width/2 - imageSize.width/2),
                        rect.origin.y + floor(rect.size.height/2 - imageSize.height/2),
                        imageSize.width, imageSize.height);
    }
  }
  return rect;
}

- (void)drawInRect:(CGRect)rect contentMode:(UIViewContentMode)contentMode {
  BOOL clip = NO;
  CGRect originalRect = rect;
  if (self.size.width != rect.size.width || self.size.height != rect.size.height) {
    clip = contentMode != UIViewContentModeScaleAspectFill
           && contentMode != UIViewContentModeScaleAspectFit;
    rect = [self convertRect:rect withContentMode:contentMode];
  }
  
  CGContextRef context = UIGraphicsGetCurrentContext();
  if (clip) {
    CGContextSaveGState(context);
    CGContextAddRect(context, originalRect);
    CGContextClip(context);
  }

  [self drawInRect:rect];

  if (clip) {
    CGContextRestoreGState(context);
  }
}

- (void)drawInRect:(CGRect)rect radius:(CGFloat)radius {
  [self drawInRect:rect radius:radius contentMode:UIViewContentModeScaleToFill];
}

- (void)drawInRect:(CGRect)rect radius:(CGFloat)radius contentMode:(UIViewContentMode)contentMode {
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSaveGState(context);
  if (radius) {
    [self addRoundedRectToPath:context rect:rect radius:radius];
    CGContextClip(context);
  }
  
  [self drawInRect:rect contentMode:contentMode];
  
  CGContextRestoreGState(context);
}

-(UIImage*)roundCorners:(CGFloat)radius
{
	CGRect             bnds = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
	CGImageRef         imag = self.CGImage;
	CGContextRef       ctxt = nil;
	UIImage*           copy = nil;

	UIGraphicsBeginImageContext(bnds.size);
	ctxt = UIGraphicsGetCurrentContext();

//	[self addRoundedRectToPath:ctxt rect:bnds radius:radius];
//	CGContextClip(ctxt);

	[self drawInRect:bnds radius:radius];

//	CGContextDrawImage(UIGraphicsGetCurrentContext(), bnds, imag);
	
	copy = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return copy;
}


@end
