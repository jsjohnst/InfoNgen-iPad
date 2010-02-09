//
//  UntitledAppDelegate.m
//  Untitled
//
//  Created by Robert Stewart on 2/2/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import "AppDelegate.h"
#import "SavedSearchesViewController.h"
#import "MainViewController.h"

@implementation AppDelegate

@synthesize pages,savedSearches,window,splitViewController, savedSearchesViewController, mainViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	// get archived state...
	[self loadArchivedData];
	
	savedSearchesViewController = [[SavedSearchesViewController alloc] initWithNibName:@"SavedSearchesView" bundle:nil];
    
    mainViewController = [[MainViewController alloc] initWithNibName:@"MainView" bundle:nil];
	
	mainViewController.savedSearchesViewController=savedSearchesViewController;
	
    savedSearchesViewController.mainViewController = mainViewController;
    
	// setup a split view with saved searches on the left side and the main view on the right side
    splitViewController = [[UISplitViewController alloc] init];
    splitViewController.viewControllers = [NSArray arrayWithObjects:savedSearchesViewController, mainViewController, nil];
	splitViewController.delegate = mainViewController;
    
    // Add the split view controller's view to the window and display.
    [window addSubview:splitViewController.view];
    [window makeKeyAndVisible];
    
    return YES;
}

- (NSString *)dataFilePath
{
	NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString * documentsDirectory = [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:@"archive"];
}

- (void) loadArchivedData
{
	NSData * data =[[NSMutableData alloc]
					initWithContentsOfFile:[self dataFilePath]];
	
	NSKeyedUnarchiver * unarchiver = [[NSKeyedUnarchiver alloc]
									  initForReadingWithData:data];
	
	pages=[unarchiver decodeObjectForKey:@"pages"];
	
	savedSearches=[unarchiver decodeObjectForKey:@"savedSearches"];
	
	if(pages==nil)
	{
		pages=[[NSMutableArray alloc] init];
	}
	if(savedSearches==nil)
	{
		savedSearches=[[NSMutableArray alloc] init];
	}
	
	[unarchiver finishDecoding];
	
	[unarchiver	release];
	
	[data release];
}

- (void) saveData
{
	if(pages!=nil || savedSearches!=nil)
	{
		NSMutableData * data=[[NSMutableData alloc] init];
		
		NSKeyedArchiver * archiver=[[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
		
		if(pages!=nil)
		{
			[archiver encodeObject:pages forKey:@"pages"];
		}
		if(savedSearches!=nil)
		{
			[archiver encodeObject:savedSearches forKey:@"savedSearches"];
		}
		
		[archiver finishEncoding];
		
		[data writeToFile:[self dataFilePath] atomically:YES];
		
		[archiver release];
		
		[data release];
	}
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Save data if appropriate
	[self saveData];
}

- (void)dealloc {
    [splitViewController release];
    [window release];
	[pages release];
	[savedSearches release];
    [super dealloc];
}

@end

