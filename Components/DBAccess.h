
// actually, I've changed my mind about this now.
// just use this class as a base for your own database class, copy/paste style.
// I'll make it a baseclass sometime when I have time to figure out a good architecture setup for up

@interface DBAccess : NSObject 
{
	NSString *_databaseName;
	NSString *_databasePath;
}

@property (nonatomic, retain) NSString *_databaseName;
@property (nonatomic, retain) NSString *_databasePath;

+(DBAccess*)instance;

// Template Methods
-(void)setDatabaseName;

@end
