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

@implementation AppDelegate

@synthesize pages,loginTicket,progressView,savedSearches,window,splitViewController, savedSearchesViewController, mainViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	// get archived state...
	[self loadArchivedData];
	
	// get login ticket
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	
	NSString * server=[defaults objectForKey:@"server"];
	NSString * username=[defaults objectForKey:@"username"];
	NSString * password=[defaults objectForKey:@"password"];
	
	// TODO: when first run, make user register username/password?
	if(server==nil) server="http://sa.infongen.com";
	
	if(username==nil) username=@"bob.stewart@ii";
	if(password==nil) password=@"Welcome01";
	
	SearchClient * client=[[SearchClient alloc] initWithServer:server withUsername:username withPassword:password];
	
	self.savedSearches=[client getSavedSearchesForUser:username password:password];
	
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
    
	///progressView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    //[progressView setCenter:CGPointMake(368.0f, 498.0f)];
    //[progressView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    //[progressView startAnimating];
	

	// add progress indicator so we can login and get login ticket and load users saved searches, etc.
	//[splitViewController.view addSubview:progressView];
	
	[window makeKeyAndVisible];
    
	// TODO: make spinner in middle of screen regardless of orientation...
	
	self.loginTicket=[[LoginTicket alloc] initWithUsername:username password:password];
	
	//[progressView stopAnimating];
	//[progressView removeFromSuperview];
	
    return YES;
}

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}
/*
- (void)loginTicketDidFinish:(LoginTicket*)ticket
{
	[progressView stopAnimating];
	[progressView removeFromSuperview];
}*/

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
	
	self.pages=[unarchiver decodeObjectForKey:@"pages"];
	
	//self.savedSearches=[unarchiver decodeObjectForKey:@"savedSearches"];
	
	if(pages==nil)
	{
		pages=[[NSMutableArray alloc] init];
	}
	//if(savedSearches==nil)
	/////{
	//	savedSearches=[[NSMutableArray alloc] init];
	//}
	
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
		//if(savedSearches!=nil)
		///{
		////	[archiver encodeObject:savedSearches forKey:@"savedSearches"];
		//}
		
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
	//[progressView release];
	[loginTicket release];
    [super dealloc];
}

@end

