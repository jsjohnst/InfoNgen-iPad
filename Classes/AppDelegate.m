//
//  UntitledAppDelegate.m
//  Untitled
//
//  Created by Robert Stewart on 2/2/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import "AppDelegate.h"
#import "SavedSearchesViewController.h"
#import "NewslettersViewController.h"
#import "NewsletterViewController.h"
#import "Newsletter.h"
#import "LoginTicket.h"
#import "SearchClient.h"
#import "SavedSearch.h"
#import "SearchResult.h"
#import "UserSettings.h"
#import "Newsletter.h"
#import "UIImage-NSCoding.h"

@implementation AppDelegate

@synthesize newsletters,savedSearches,window,splitViewController,savedSearchesViewController,newsletterViewController,newslettersViewController,navigationController,newslettersPopoverController,searchesPopoverController; 

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	// get archived state...
	[self loadArchivedData];
	
	NSString * server=[UserSettings getSetting:@"server"];
	NSString * username=[UserSettings getSetting:@"username"];
	NSString * password=[UserSettings getSetting:@"password"];
	
	SearchClient * client=[[SearchClient alloc] initWithServer:server withUsername:username withPassword:password];
	
	savedSearches=[client getSavedSearchesForUser];
	
	savedSearchesViewController = [[SavedSearchesViewController alloc] initWithNibName:@"SavedSearchesView" bundle:nil];
    
	newsletterViewController =[[NewsletterViewController alloc] initWithNibName:@"NewsletterView" bundle:nil];
	
	newslettersViewController=[[NewslettersViewController alloc] initWithNibName:@"NewslettersView" bundle:nil];
	
	newslettersViewController.newsletters=self.newsletters;
	 
	newslettersPopoverController=[[UIPopoverController alloc] initWithContentViewController:newslettersViewController];
	newslettersPopoverController.delegate=self;
	
	searchesPopoverController=[[UIPopoverController alloc] initWithContentViewController:savedSearchesViewController];
	searchesPopoverController.delegate=self;
	
	navigationController = [[UINavigationController alloc] initWithRootViewController:newsletterViewController];
    
	navigationController.navigationBar.topItem.title=@"InfoNgen Newsletter Editor";
	
	UIBarButtonItem * button=[[UIBarButtonItem alloc] init];
	
	button.title=@"Newsletters";
	button.target=self;
	button.action=@selector(showNewslettersPopOver:);

	navigationController.navigationBar.topItem.rightBarButtonItem=button;
	
	[button release];
	
	navigationController.delegate=self;
	
	// setup a split view with saved searches on the left side and the main view on the right side
    splitViewController = [[UISplitViewController alloc] init];
    splitViewController.viewControllers = [NSArray arrayWithObjects:savedSearchesViewController, navigationController, nil];
	splitViewController.delegate = self;
    
    // Add the split view controller's view to the window and display.
    [window addSubview:splitViewController.view];
    
	[window makeKeyAndVisible];
    
	return YES;
}

- (void)showNewslettersPopOver:(id)sender{
	[newslettersPopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)showSavedSearchesPopOver:(id)sender
{
	[searchesPopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void) setCurrentNewsletter:(Newsletter*)newsletter
{
	[newsletterViewController setCurrentNewsletter:newsletter];
	
	navigationController.navigationBar.topItem.title=newsletter.name;
	
	[newslettersPopoverController dismissPopoverAnimated:YES];
}

- (void) addSearchResultToCurrentNewsletter:(SearchResult*)searchResult fromSavedSearch:(SavedSearch*)savedSearch
{
	[newsletterViewController addSearchResultToCurrentNewsletter:searchResult fromSavedSearch:savedSearch];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	NSLog(@"didShowViewController");
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	NSLog(@"willShowViewController");
	
	[viewController viewWillAppear:animated];
}

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
    
    barButtonItem.title = @"Saved Searches";
	
	UINavigationItem * firstItem=[[navigationController.navigationBar items] objectAtIndex:0];
	
	[firstItem setLeftBarButtonItem:barButtonItem animated:YES];
	
	self.searchesPopoverController = pc;
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
	
		self.newsletters=[unarchiver decodeObjectForKey:@"newsletters"];
	
		[unarchiver finishDecoding];
		
		[unarchiver	release];
	
		[data release];
	}
	if(newsletters==nil)
	{
		newsletters=[[NSMutableArray alloc] init];
	}
}

- (void) saveData
{
	if(newsletters!=nil)
	{
		NSMutableData * data=[[NSMutableData alloc] init];
		
		if(data)
		{
			NSKeyedArchiver * archiver=[[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
		
			[archiver encodeObject:newsletters forKey:@"newsletters"];
		
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
	[navigationController release];
	[savedSearchesViewController release];
	[newslettersViewController release];
	[newsletterViewController release];
	[newslettersPopoverController release];
	[searchesPopoverController release];
    [window release];
	[newsletters release];
	[savedSearches release];
    [super dealloc];
}

@end

