
@interface BitmapView : UIImageView 
{
	unsigned char *_bitmap;
	CGSize _size;
}

@property (nonatomic, readonly) unsigned char* _bitmap;
@property (nonatomic, readonly) CGSize _size;

-(UIColor*)getColorAtPoint:(CGPoint)pt;

@end
