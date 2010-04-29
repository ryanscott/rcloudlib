//
//  rciphonetemplateAppDelegate.m
//  rciphonetemplate
//
//  Created by Ryan Stubblefield on 4/29/10.
//  Copyright Context Optional Inc. 2010. All rights reserved.
//

#import "rciphonetemplateAppDelegate.h"

@implementation rciphonetemplateAppDelegate

@synthesize window;

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{
	window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	[window makeKeyAndVisible];
	
	return YES;
}


-(void)dealloc 
{
	[window release];
	[super dealloc];
}


@end
