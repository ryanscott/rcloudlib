#import "DBAccess.h"
#import <sqlite3.h> 

@implementation DBAccess

@synthesize _databaseName;
@synthesize _databasePath;

#pragma mark Singleton Methods

static DBAccess* gDBAccess = NULL;

+(DBAccess*)instance
{
	@synchronized(self)
	{
    if (gDBAccess == NULL)
		{
			gDBAccess = [[DBAccess alloc] init];
		}
	}
	return gDBAccess;
}

-(void)checkAndCreateDatabase
{
	// Check if the SQL database has already been saved to the users phone, if not then copy it over
	BOOL success;
	
	// Create a FileManager object, we will use this to check the status
	// of the database and to copy it over if required
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	// Check if the database has already been created in the users filesystem
	success = [fileManager fileExistsAtPath:self._databasePath];
	
	// If the database already exists then return without doing anything
	if(success) return;
	
	// If not then proceed to copy the database from the application to the users filesystem
	
	// Get the path to the database in the application package
	NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:_databaseName];
	
	// Copy the database from the package to the users filesystem
	[fileManager copyItemAtPath:databasePathFromApp toPath:self._databasePath error:nil];
}

+(void)initialize 
{
	if (self == [DBAccess class]) 
	{
		[[DBAccess instance] checkAndCreateDatabase];
	}
}

#pragma mark Initialization

-(void)setDatabaseName
{
	// override this method, with your sqlite database name.
	self._databaseName = @"behr.sqlite";
}

-(void)initDatabase
{	
	[self setDatabaseName];
	// Get the path to the documents directory and append the databaseName
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	self._databasePath = [documentsDir stringByAppendingPathComponent:self._databaseName];

	// now called only once, from +initialize.  
	// DBAccess.init may be called twice in case we ever release the singleton for memory sake
	//	[self checkAndCreateDatabase];
}

-(id)init
{
	if ( self = [super init] )
	{
		[self initDatabase];
	}
	return self;
}

- (void)dealloc 
{
	[self._databaseName release];
	[self._databasePath release];

	[super dealloc];
}

#pragma mark Implementation Methods

#pragma mark Template Methods

@end
