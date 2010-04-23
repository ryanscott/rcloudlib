#import "BitmapView.h"

@implementation BitmapView

@synthesize _bitmap;
@synthesize _size;

-(void)initVars
{
	self.userInteractionEnabled	= YES;
	self.multipleTouchEnabled = NO;
	
	_bitmap = NULL;
	_size = CGSizeMake( 0.0f, 0.0f );
}

-(id)initWithFrame:(CGRect)aFrame
{
	if ( self = [super initWithFrame: aFrame] ) 
	{
		[self initVars];
	}
	
	return self;
}

-(id)initWithImage:(UIImage*)newImage
{
	if ( self = [super initWithImage:newImage] ) 
	{
		[self initVars];
		[self setImage:newImage];
//		CGRect frame = [self frame];
//		frame.origin = CGPointMake( 0.0f, kSwatchTitleViewVisibleHeight );
//		[self setFrame:frame];
	}
	
	return self;
}

-(void) dealloc
{
	if (_bitmap) 
		free(_bitmap);
	[super dealloc];
}

#pragma mark Instance Methods

//-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event 
//{
//	long startByte = (int)((point.y * _size.width) + point.x) * 4;
//	int alpha = (unsigned char) _bitmap[startByte];
//	return (alpha > 0.5);
//}

-(void)setImage:(UIImage *)anImage
{
	[super setImage:anImage];

	if (_bitmap) 
		free(_bitmap);

	_bitmap = [Util RequestImagePixelData:anImage];
	_size = [anImage size];
}

-(UIColor*)getColorAtPoint:(CGPoint)pt
{
	long startByte = (int)((pt.y * _size.width) + pt.x) * 4;
	
	return [UIColor colorWithRed: (float) (_bitmap[startByte+1]/255.0f)
												 green: (float) (_bitmap[startByte+2]/255.0f)
													blue:  (float) (_bitmap[startByte+3]/255.0f)
												 alpha: 1.0f];
}



//#pragma mark Touch Handling
///*
// -(void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
// {
// CGPoint pt = [[touches anyObject] locationInView:self];
// long startByte = (int)((pt.y * size.width) + pt.x) * 4;
// 
// // Note these points are slightly off in the simulator
// [self viewWithTag:CROSSHAIR_TAG].center = pt;
// 
// // Output RGB values. The alpha value has offset 0
// //	 printf("[%3d, %3d] %3dR %3dG %3dB\n", (int)pt.x, (int)pt.y, 
// //	 (unsigned char) bitmap[startByte+1], 
// //	 (unsigned char) bitmap[startByte+2], 
// //	 (unsigned char) bitmap[startByte+3]); 
// 
// [self viewWithTag:COLOR_VIEW_TAG].backgroundColor = [UIColor 
// colorWithRed: (float) (bitmap[startByte+1]/255.0f)
// green: (float) (bitmap[startByte+2]/255.0f)
// blue:  (float) (bitmap[startByte+3]/255.0f)
// alpha: 1.0f];
// }
// */
//
//-(bool)touchInsideRing:(UITouch*)touch
//{
//	if ( [[self subviews] count] > 0 )
//	{
//		RingView* ring_view = (RingView*)[[self subviews] objectAtIndex:0];
//	
//		CGPoint ring_pt = [touch locationInView:ring_view];
//	
//		CGFloat ring_side = ring_view.frame.size.width;
//		CGFloat half_side = ring_side / 2.0f;
//		
//		CGPoint pt;
//		
//		// normalize with centered origin
//		pt.x = (ring_pt.x - half_side) / half_side;
//		pt.y = (ring_pt.y - half_side) / half_side;
//		
//		// x^2 + y^2 = radius
//		float xsquared = pt.x * pt.x;
//		float ysquared = pt.y * pt.y;
//		
//		// If the radius < 1, the point is within the clipped circle
//		if ((xsquared + ysquared) < 1.0) return true;
//	}
//	return false;
//}
//
//
//-(void)moveRingToPoint:(CGPoint)center_point
//{
//	if ( [[self subviews] count] > 0 )
//	{
//		RingView* ring_view = (RingView*)[[self subviews] objectAtIndex:0];
//		ring_view.center = center_point;
//		[[NSNotificationCenter defaultCenter] postNotificationName:kEventRingMoved object:ring_view];		
//	}
//}
//
//-(void)updateRingRadius:(float)new_radius
//{
//	if ( [[self subviews] count] > 0 )
//	{
//		RingView* ring_view = (RingView*)[[self subviews] objectAtIndex:0];
//		[ring_view updateRadius:new_radius];
//		[[NSNotificationCenter defaultCenter] postNotificationName:kEventRingMoved object:ring_view];		
//	}
//}
//
//-(void)clearTouches {
//	initialDistance = -1;
//}
//
//-(void)touchesCanceled {
//	[self clearTouches];	
//}
//
//-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
//{
//	//NSSet *allTouches = [event allTouches];
//	NSSet* allTouches = [event touchesForView:self];
//	
//	NSUInteger touch_count = [allTouches count];
//
//	if ( 1 == touch_count )
//	{
//		//NSLog(@"TouchesBegain, touch_count = 1");
//		//Single touch
//		
//		//Get the first touch.
//		UITouch* touch = [[allTouches allObjects] objectAtIndex:0];		
//		CGPoint pt = [touch locationInView:self];
//
//		// [ryan:5-6-9] if we get a single touch that is inside the existing ring view, we don't move it...to keep the ring from always
//		// sliding around.  this only applies to toucesBegan, not touchesMoved...so if you touch then drag, the ring will start to move again.
//		if ( ![self touchInsideRing:touch] )
//		{
//			[self moveRingToPoint:pt];
//		}
//	}
//	else if ( 2 == touch_count )
//	{
//		//NSLog(@"TouchesBegain, touch_count = 2");
//		UITouch *touch1 = [[allTouches allObjects] objectAtIndex:0];
//		UITouch *touch2 = [[allTouches allObjects] objectAtIndex:1];
//		
//		CGPoint pt1 = [touch1 locationInView:self]; 
//		CGPoint pt2 = [touch2 locationInView:self]; 
////
//		//		CGPoint pt1 = [self convertPoint:[touch1 locationInWindow] fromView:nil]; 
//		//		CGPoint pt2 = [self convertPoint:[touch2 locationInWindow] fromView:nil]; 
//
//		initialDistance = [Util distanceBetweenTwoPoints:pt1 toPoint:pt2];		
//		
//		CGPoint centerPoint = [Util centerPointBetweenTwoPoints:pt1 secondPoint:pt2];
//		[self moveRingToPoint:centerPoint];
//	}
//}
//
//-(void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
//{
//	CGPoint pt = [[touches anyObject] locationInView:self];
//	[self moveRingToPoint:pt];
//	
//	//NSSet *allTouches = [event allTouches];
//	NSSet* allTouches = [event touchesForView:self];
//	
//	NSUInteger touch_count = [allTouches count];
//	
//	if ( 1 == touch_count )
//	{
//		//NSLog(@"TouchesMoved, touch_count = 1");
//		//Single touch
//		
//		//Get the first touch.
//		UITouch* touch = [[allTouches allObjects] objectAtIndex:0];		
//		CGPoint pt = [touch locationInView:self];
//		[self moveRingToPoint:pt];
//	}
//	else if ( 2 == touch_count )
//	{
//		//NSLog(@"TouchesMoved, touch_count = 2");
//		//The image is being zoomed in or out.
//		
//		UITouch *touch1 = [[allTouches allObjects] objectAtIndex:0];
//		UITouch *touch2 = [[allTouches allObjects] objectAtIndex:1];
//		
//		CGPoint pt1 = [touch1 locationInView:self]; 
//		CGPoint pt2 = [touch2 locationInView:self]; 
////		CGPoint pt1 = [self convertPoint:[touch1 locationInWindow] fromView:nil]; 
////		CGPoint pt2 = [self convertPoint:[touch2 locationInWindow] fromView:nil]; 
//		
//		//Calculate the distance between the two fingers.
//		CGFloat finalDistance = [Util distanceBetweenTwoPoints:pt1 toPoint:pt2];		
//			
//		CGPoint centerPoint = [Util centerPointBetweenTwoPoints:pt1 secondPoint:pt2];
//		[self moveRingToPoint:centerPoint];
//		
//		[self updateRingRadius:finalDistance];
//	
//		/*
//		//Check if zoom in or zoom out.
//		if(initialDistance < finalDistance) {
//			//NSLog(@"Zoom Out");
//		} 
//		else {
//			//NSLog(@"Zoom In");
//		}
//		*/
//		initialDistance = finalDistance;
//	}
//}
//
//-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
//{ 
//	[self clearTouches];
//}
//
///*
//-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
//{
//	// Retrieve the touch point
//	CGPoint pt = [[touches anyObject] locationInView:self];
//	startLocation = pt;
//	[[self superview] bringSubviewToFront:self];
//	[[NSNotificationCenter defaultCenter] postNotificationName:kEventRingMoved object:self];
//	
//}
//*/
///*
//-(void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
//{
//	// Move relative to the original touch point
//	CGPoint pt = [[touches anyObject] locationInView:self];
//	CGRect frame = [self frame];
//	frame.origin.x += pt.x - startLocation.x;
//	frame.origin.y += pt.y - startLocation.y;
//	[self setFrame:frame];
//	[[NSNotificationCenter defaultCenter] postNotificationName:kEventRingMoved object:self];
//}
//*/

@end
