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
#import "LoginTicket.h"
#import "SearchClient.h"
#import "SavedSearch.h"
#import "UserSettings.h"
#import "UIImage-NSCoding.h"

@implementation AppDelegate

@synthesize pages,savedSearches,window,splitViewController, savedSearchesViewController, mainViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	// get archived state...
	[self loadArchivedData];
	
	NSString * server=[UserSettings getSetting:@"server"];
	NSString * username=[UserSettings getSetting:@"username"];
	NSString * password=[UserSettings getSetting:@"password"];
	
	SearchClient * client=[[SearchClient alloc] initWithServer:server withUsername:username withPassword:password];
	
	self.savedSearches=[client getSavedSearchesForUser];
	
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
    //[window addSubview:mainViewController.view];
	
	[window makeKeyAndVisible];
    
	return YES;
}

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
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
	
	if (data) {
		
		NSKeyedUnarchiver * unarchiver = [[NSKeyedUnarchiver alloc]
									  initForReadingWithData:data];
	
		self.pages=[unarchiver decodeObjectForKey:@"pages"];
	
		[unarchiver finishDecoding];
		
		[unarchiver	release];
	
		[data release];
	}
	if(pages==nil)
	{
		pages=[[NSMutableArray alloc] init];
	}
}

- (void) saveData
{
	if(pages!=nil)
	{
		NSMutableData * data=[[NSMutableData alloc] init];
		
		if(data)
		{
			NSKeyedArchiver * archiver=[[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
		
			[archiver encodeObject:pages forKey:@"pages"];
		
			[archiver finishEncoding];
		
			[data writeToFile:[self dataFilePath] atomically:YES];
		
			[archiver release];
		
			[data release];
		}
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

