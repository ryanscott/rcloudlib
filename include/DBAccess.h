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
