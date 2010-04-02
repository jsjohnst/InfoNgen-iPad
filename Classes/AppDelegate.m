//
//  UntitledAppDelegate.m
//  Untitled
//
//  Created by Robert Stewart on 2/2/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import "AppDelegate.h"
//#import "SavedSearchesViewController.h"
#import "NewslettersViewController.h"
#import "NewsletterViewController.h"
#import "NewsletterSettingsViewController.h"
#import "NewsletterHTMLPreviewViewController.h"
#import "Newsletter.h"
#import "LoginTicket.h"
#import "SearchClient.h"
#import "SavedSearch.h"
#import "SearchResult.h"
#import "UserSettings.h"
#import "Newsletter.h"
#import "UIImage-NSCoding.h"
#import "NewslettersScrollViewController.h"
#import "RootNavigationController.h"

@implementation AppDelegate

@synthesize newsletters,savedSearches,window,newsletter,scroller,tabBarController,newsletterSettingsViewController,newsletterHTMLPreviewViewController,splitViewController,synopsisViewController,headlineViewController,newslettersViewController,navigationController,newslettersPopoverController; 

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	// get archived state...
	[self loadArchivedData];
	
	NSString * server=[UserSettings getSetting:@"server"];
	NSString * username=[UserSettings getSetting:@"username"];
	NSString * password=[UserSettings getSetting:@"password"];
	
	SearchClient * client=[[SearchClient alloc] initWithServer:server withUsername:username withPassword:password];
	
	savedSearches=[client getSavedSearchesForUser];
	
	/*headlineViewController =[[NewsletterViewController alloc] initWithNibName:@"NewsletterView" bundle:nil];
	[headlineViewController setViewMode:NO];
	headlineViewController.tabBarItem.title=@"Headlines";
	headlineViewController.tabBarItem.image=[UIImage imageNamed:@"icon_document.png"];

	synopsisViewController =[[NewsletterViewController alloc] initWithNibName:@"NewsletterView" bundle:nil];
	[synopsisViewController setViewMode:YES];
	synopsisViewController.tabBarItem.title=@"Synopsis";
	synopsisViewController.tabBarItem.image=[UIImage imageNamed:@"icon_document.png"];
	
	newsletterHTMLPreviewViewController = [[NewsletterHTMLPreviewViewController alloc] initWithNibName:@"NewsletterHTMLPreviewView" bundle:nil];
	newsletterHTMLPreviewViewController.tabBarItem.title=@"Preview";
	newsletterHTMLPreviewViewController.tabBarItem.image=[UIImage imageNamed:@"icon_filming.png"];
	
	newsletterSettingsViewController = [[NewsletterSettingsViewController alloc] initWithNibName:@"NewsletterSettingsView" bundle:nil];
	newsletterSettingsViewController.tabBarItem.title=@"Settings";
	newsletterSettingsViewController.tabBarItem.image=[UIImage imageNamed:@"icon_settings.png"];

	tabBarController=[[UITabBarController alloc] init];
	
	NSMutableArray * viewControllers=[[NSMutableArray alloc] init];
	
	[viewControllers addObject:headlineViewController];
	[viewControllers addObject:synopsisViewController];
	[viewControllers addObject:newsletterHTMLPreviewViewController];
	[viewControllers addObject:newsletterSettingsViewController];
	
	tabBarController.viewControllers=viewControllers;
	
	[viewControllers release];
	
	newslettersViewController=[[NewslettersViewController alloc] initWithNibName:@"NewslettersView" bundle:nil];
	
	newslettersViewController.newsletters=self.newsletters;
	*/
	
	self.scroller=[[NewslettersScrollViewController alloc] initWithNibName:@"NewslettersScrollView" bundle:nil];
	
	self.scroller.newsletters=self.newsletters;
	
	//navigationController = [[UINavigationController alloc] initWithRootViewController:tabBarController];
	navigationController = [[UINavigationController alloc] initWithRootViewController:self.scroller];
    
	navigationController.navigationBar.barStyle=UIBarStyleBlack;
	
	/*if(self.newsletter!=nil)
	{
		newsletterSettingsViewController.newsletter=newsletter;
		newsletterHTMLPreviewViewController.newsletter=newsletter;
		headlineViewController.newsletter=newsletter;
		synopsisViewController.newsletter=newsletter;
		navigationController.navigationBar.topItem.title=newsletter.name;
	}
	else 
	{
		navigationController.navigationBar.topItem.title=@"InfoNgen Newsletter Editor";
	}*/
	
	//UIBarButtonItem *button=[[UIBarButtonItem alloc] init];
	
	//button.title=@"Newsletters";
	//button.target=self;
	//button.action=@selector(showNewslettersPopOver:);
	
	UIBarButtonItem *button=[[UIBarButtonItem alloc] init];
	
	button.title=@"New Newsletter";
	button.target=self;
	button.action=@selector(newNewsletter);
	
	navigationController.navigationBar.topItem.leftBarButtonItem=button;

	[button release];
	
	navigationController.delegate=self;
	
	/*UINavigationController * masterNavController = [[UINavigationController alloc] initWithRootViewController:newslettersViewController];
    
	masterNavController.navigationBar.barStyle=UIBarStyleBlack;
	
	// setup a split view with saved searches on the left side and the main view on the right side
    splitViewController = [[UISplitViewController alloc] init];
    
	splitViewController.viewControllers = [NSArray arrayWithObjects:masterNavController, navigationController, nil];
	
	splitViewController.delegate = self;
    */
	
	
    // Add the split view controller's view to the window and display.
    [window addSubview:navigationController.view];
	
	//[window addSubview:splitViewController.view];
    
	[window makeKeyAndVisible];
	
	return YES;
}

- (void) newNewsletter
{
	Newsletter * newNewsletter=[[Newsletter alloc] init];
	
	newNewsletter.name=@"Untitled";
	
	[self.newsletters addObject:newNewsletter];
	
	[self.scroller addNewsletterPage:newNewsletter];
	
	//self.scroller.pageControl.currentPage=[self.scroller.pageControl.numberOfPages-1];
	
	[self.scroller layoutSubviews];
	
	[self.scroller scrollToPage:self.scroller.pageControl.numberOfPages-1];
	
	[self.scroller displayCurrentPageInfo];
	
	//self.scroller.newsletter=newNewsletter;
	
	[self editNewsletter:newNewsletter];
	
	[newNewsletter release];
	
}

- (void)showNewslettersPopOver:(id)sender{
	if(newslettersPopoverController==nil)
	{
		newslettersPopoverController=[[UIPopoverController alloc] initWithContentViewController:newslettersViewController];
	}
	[newslettersPopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void) deleteNewsletter:(Newsletter*)newsletter
{
	[self.newsletters removeObject:newsletter];
	
	if([newsletter isEqual:self.newsletter])
	{
		[self setCurrentNewsletter:nil];
	}	
}

- (void) editNewsletter:(Newsletter*)_newsletter
{
	self.newsletter=_newsletter;
	
	NewsletterViewController * newsletterView=[[NewsletterViewController alloc] initWithNibName:@"NewsletterView" bundle:nil];
	
	[newsletterView setViewMode:YES];
	//newsletterView.viewModeExpanded=YES;
	newsletterView.newsletter=_newsletter;
	
	newsletterView.title=_newsletter.name;
	
	[navigationController pushViewController:newsletterView animated:NO];
	
	[newsletterView release];
}

- (void) setCurrentNewsletter:(Newsletter*)newsletter
{
	self.newsletter=newsletter;
	
	newsletterSettingsViewController.newsletter=newsletter;
	newsletterHTMLPreviewViewController.newsletter=newsletter;
	headlineViewController.newsletter=newsletter;
	synopsisViewController.newsletter=newsletter;
	
	if(newsletter)
	{
		navigationController.navigationBar.topItem.title=newsletter.name;
	}
	else 
	{
		navigationController.navigationBar.topItem.title=@"InfoNgen Newsletter Editor";
	}
	
	[self renderNewsletter];
}

- (void) renderNewsletter
{
	// make sure view controllers redraw their newsletter info
	if(tabBarController.selectedViewController!=nil)
	{
		[tabBarController.selectedViewController renderNewsletter];
	}
}

- (void) addSearchResultToCurrentNewsletter:(SearchResult*)searchResult fromSavedSearch:(SavedSearch*)savedSearch
{
	//[newsletterViewController addSearchResultToCurrentNewsletter:searchResult fromSavedSearch:savedSearch];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	[viewController viewWillAppear:animated];
}

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
    
    barButtonItem.title = @"Newsletters";
	
	UINavigationItem * firstItem=[[navigationController.navigationBar items] objectAtIndex:0];
	
	[firstItem setLeftBarButtonItem:barButtonItem animated:YES];
	
	self.newslettersPopoverController = pc;
}

// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
	
	UINavigationItem * firstItem=[[navigationController.navigationBar items] objectAtIndex:0];
	
	[firstItem setLeftBarButtonItem:nil animated:YES];
	
    //self.searchesPopoverController = nil;
}

- (void)splitViewController:(UISplitViewController*)svc popoverController:(UIPopoverController*)pc willPresentViewController:(UIViewController *)aViewController
{
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
		
		// get name of previously edited newsletter and open up that newsletter again if found
		NSString * newsletter_name=[unarchiver decodeObjectForKey:@"newsletter.name"];
		if(newsletter_name!=nil)
		{
			if(self.newsletters)
			{
				for(Newsletter * n in self.newsletters)
				{
					if([n.name isEqualToString:newsletter_name])
					{
						self.newsletter=n;
						break;
					}
				}
			}
		}
		
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
			
			// save current newsletter name so we open up same newsletter on next start
			if (newsletter!=nil) {
				[archiver encodeObject:newsletter.name  forKey:@"newsletter.name"];
			}
			else {
				[archiver encodeObject:nil forKey:@"newsletter.name"];
			}

			[archiver finishEncoding];
		
			[data writeToFile:[self dataFilePath] atomically:YES];
		
			[archiver release];
		
			[data release];
			
			
			NSLog(@"Data saved ...");
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
	[newslettersViewController release];
	[headlineViewController release];
	[synopsisViewController release];
	[newslettersPopoverController release];
	[newsletterSettingsViewController release];
	[newsletterHTMLPreviewViewController release];
    [window release];
	[newsletters release];
	[savedSearches release];
	[newsletter release];
	[tabBarController release];
	[scroller release];
    [super dealloc];
}

@end

