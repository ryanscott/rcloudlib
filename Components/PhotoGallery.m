//
//  PhotoGallery.m
//  rcloudlib
//
//  Created by ryan on 5/12/10.
//  Copyright 2010 R.Cloud LLC. All rights reserved.
//

#import "PhotoGallery.h"

//@interface PhotoGallery (_PrivateMethods)
//-(void)layoutGallery;
//@end

@implementation PhotoGallery

@synthesize _thumbnails;
	
@synthesize _lineCount;  
@synthesize _thumbSize;
@synthesize _viewSize;

@synthesize _marginOffset; 
@synthesize _vertical; 

@synthesize _scroller;
@synthesize _gallery;


#pragma mark Initialization

#pragma mark Initialization

-(void)initScroller
{
	CGFloat width = self._viewSize.width;
	CGFloat height = self._viewSize.height;
	CGFloat x = 0.0f;
	CGFloat y = 0.0f;
	
	CGRect l_frame = CGRectMake(x, y, width, height);
	
	self._scroller = [[UIScrollView alloc] initWithFrame:l_frame];
	
	self._scroller.pagingEnabled = NO;
//	self._scroller.contentSize = CGSizeMake(width * pageCount, height);
	self._scroller.showsHorizontalScrollIndicator = NO;
	self._scroller.showsVerticalScrollIndicator = NO;
	self._scroller.scrollsToTop = NO;
	//	self._scroller.delegate = self;
}

-(void)initControls
{
	if ( nil == self._gallery || nil == self._scroller )
	{
		self._gallery = [[UIView alloc] init];
		[self initScroller];
	}
}

-(void)initSelf
{
	self.title = @"Photo Gallery";

	self._thumbnails = nil;	
	self._gallery = nil;
	self._scroller = nil;
	
	self._viewSize = kApplicationFrame.size;
	self._thumbSize = CGSizeMake(75.0f, 75.0f);
	self._lineCount = 4;
	
	self._vertical = true;
	self._marginOffset = CGSizeMake(0.0f, 0.0f);
}

-(id)init
{
	if ( self = [super init] )
	{
		[self initSelf];
	}
	return self;
}

//-(void)initEvents
//{
//	//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notify:) name:@"Event" object:notificationSender];	
//}

//-(void)stopEvents
//{
//	//[[NSNotificationCenter defaultCenter] removeObserver:self @"Event" object:notificationSender];
//}

-(void)addSubviews
{
	[self._scroller addSubview:self._gallery];
	[self.view addSubview:self._scroller];
}

-(void)viewDidLoad 
{
	//	[self initEvents];

	[self initControls];	
	[self layoutGallery];
	[self addSubviews];
	[super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated
{
	if ( self._scroller.showsVerticalScrollIndicator )
		[self._scroller flashScrollIndicators];
}

#pragma mark Memory Management

-(void)didReceiveMemoryWarning 
{
	[super didReceiveMemoryWarning];
}

//-(void)viewDidUnload 
//{
//}

-(void)dealloc 
{
	//	[self stopEvents];
	[_thumbnails release];
	[_scroller release];
	[_gallery release];
	
	[super dealloc];
}

#pragma mark Singleton Methods

#pragma mark Instance Methods

-(void)layoutGallery
{
	if ( nil == self._thumbnails && self._lineCount == 0 )
		return;

	// ignore margin offset for the moment
	// also ignoring horizontal/vertical, assuming vertical.  
	// should probably remove those properties, if we aren't going to use them
	CGFloat thumbSpan = 0.0f;
	CGFloat viewSpan = 0.0f;
	if ( self._vertical )
	{
		thumbSpan = self._thumbSize.width;
		viewSpan = self._scroller.frame.size.width;
	}
	else
	{
		thumbSpan = self._thumbSize.height;
		viewSpan = self._scroller.frame.size.height;
	}
	
	CGFloat contentSpan = self._lineCount * thumbSpan;
	CGFloat whitespace = viewSpan - contentSpan;
	CGFloat spacing = whitespace / (self._lineCount + 1);

	// setup gallery frame, and set scroller info
	NSUInteger thumbCount = [self._thumbnails count];	
	// # rows for vertical, # columns for horizontal
	NSUInteger extra =  ( thumbCount % self._lineCount ) ? 1 : 0;
	NSUInteger offAxisCount = ( thumbCount / self._lineCount ) + extra;
	CGFloat galleryheight = (offAxisCount * (self._thumbSize.height + spacing)) + spacing;
	
	CGRect galleryFrame = CGRectMake(0.0f, 0.0f, self._scroller.frame.size.width, galleryheight);
	self._gallery.frame = galleryFrame;
	self._scroller.contentSize = self._gallery.frame.size;
	if ( self._scroller.contentSize.height > self._scroller.frame.size.height )
		self._scroller.showsVerticalScrollIndicator = YES;
	else
		self._scroller.showsVerticalScrollIndicator = NO;
	
	int i = 0;
	CGFloat x = spacing;
	CGFloat y = spacing;
	CGFloat width = self._thumbSize.width;
	CGFloat height = self._thumbSize.height;
	CGRect l_frame = CGRectMake(x, y, width, height);
	
	for ( UIView* i_view in self._gallery.subviews )
		[i_view removeFromSuperview];
 
	for ( UIView* i_thumb in self._thumbnails )
	{
		i_thumb.frame = l_frame;
		[self._gallery addSubview:i_thumb];
		
		if ( 0 == (i+1) % self._lineCount )
		{
			l_frame.origin.y += height + spacing;
			l_frame.origin.x = spacing;
		}
		else
		{
			l_frame.origin.x += width + spacing;
		}
		i++;
	}	
}

#pragma mark Event Handlers
#pragma mark Button Handlers

@end

