//
//  PhotoGallery.h
//  rcloudlib
//
//  Created by ryan on 5/12/10.
//  Copyright 2010 R.Cloud LLC. All rights reserved.
//

// this class is meant to be usable without having to be subclassed
// the key to custom usage is in the UIViews set in _thumbnails
@interface PhotoGallery : UIViewController 
{
	NSArray* _thumbnails;

	NSUInteger _lineCount;  
	CGSize _thumbSize;	
	CGSize _marginOffset; // margin is automatically calculated.  these values are added, to make room if needed
	bool _vertical; // defaults to yes, not supporting horizontal yet
	
	UIScrollView* _scroller;
	UIView* _gallery;
}

@property (nonatomic, retain) NSArray* _thumbnails;

@property (nonatomic, assign) NSUInteger _lineCount;  
@property (nonatomic, assign) CGSize _thumbSize;	
@property (nonatomic, assign) CGSize _marginOffset;
@property (nonatomic, assign) bool _vertical;	

@property (nonatomic, retain) UIScrollView* _scroller;
@property (nonatomic, retain) UIView* _gallery;

@end

/*

@interface SpellSetViewController : UIViewController {
	SpellSet* spellSet;
	int spellsPerRow;
	CGRect scrollerFrame;	
	CGRect mainFrame;
	UIColor* bgColor;
	
	UIScrollView* setScroller;
	UIView* setView;
}

@property (nonatomic, retain) SpellSet* spellSet;
@property (nonatomic, assign) int spellsPerRow;
@property (nonatomic, assign) CGRect scrollerFrame;
@property (nonatomic, assign) CGRect mainFrame;
@property (nonatomic, retain) UIColor* bgColor;
@property (nonatomic, retain) UIScrollView* setScroller;
@property (nonatomic, retain) UIView* setView;


-(id)initWithSpellSet:(SpellSet*)newSet;
-(void)initViews;
-(void)initSpells;

// Template Methods
-(SpellView*)createSpellViewWithFrame:(CGRect)forFrame forSpell:(Spell*)forSpell;
//-(void)addSpellView:(SpellView*)viewToAdd;

// Instance Methods
-(void)calculateSpellsPerRow;
-(CGRect)calculateSetFrame;
-(void)clearSpellViews;
-(void)updateViewWidth;

@end

*/
