//
//  DetailViewController.m
//  Untitled
//
//  Created by Robert Stewart on 2/2/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import "MainViewController.h"
#import "SavedSearchesViewController.h"
#import "PagesViewController.h"
#import "Page.h"
#import "SearchResultCell.h"
#import "SearchResult.h"
#import "AppDelegate.h"
#import "PageViewController.h"

@implementation MainViewController

@synthesize pageName,pagesViewController,pageViewController,navController,pagesPopoverController,searchesPopoverController,savedSearchesViewController;

- (void)viewDidLoad {
	pagesViewController=[[PagesViewController alloc] initWithNibName:@"PagesView" bundle:nil];
	// get pages from delegate...
	AppDelegate * delegate=[[UIApplication sharedApplication] delegate];

	pagesViewController.pages=delegate.pages;
	
	[self.view addSubview:navController.view];

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
/*
- (IBAction)newPage:(id)sender
{
	[self.view addSubview:newPageView];
}*/

/*- (IBAction) createNewPage:(id)sender
{
	NSString * name=pageName.text;
	
	if ([name length] > 0) {
		
		Page * newPage=[[Page alloc] initWithName:name];
		if (pagesViewController.pages==nil) {
			NSMutableArray * a=[[NSMutableArray alloc]init];
			pagesViewController.pages=a;
			[a release];
		}
		[pagesViewController.pages addObject:newPage];
		[self setCurrentPage:newPage];
		[newPage release];
	}
	
	[newPageView removeFromSuperview];
}*/
/*
- (IBAction) cancelNewPage:(id)sender
{
	[newPageView removeFromSuperview];
}
*/
- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
    
    barButtonItem.title = @"Saved Searches";
	
	UINavigationItem * firstItem=[[navController.navigationBar items] objectAtIndex:0];
	
	[firstItem setLeftBarButtonItem:barButtonItem animated:YES];
	
	self.searchesPopoverController = pc;
}

- (void)setCurrentPage:(Page*)thePage
{
	pageViewController.page=thePage;
	
	if(thePage)
	{
		pageViewController.editSettingsButton.enabled=YES;
		pageViewController.editMoveButton.enabled=YES;
	}
	
	navController.navigationBar.topItem.title=thePage.name;
	
	[pagesPopoverController dismissPopoverAnimated:YES];
	
	[pageViewController renderPage];
}

// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    
	
	UINavigationItem * firstItem=[[navController.navigationBar items] objectAtIndex:0];
	
	[firstItem setLeftBarButtonItem:nil animated:YES];

    self.searchesPopoverController = nil;
}

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (IBAction)showPagesTable:(id)sender{
	if (self.pagesPopoverController==nil) {
		pagesPopoverController=[[UIPopoverController alloc] initWithContentViewController:pagesViewController];
	}
	pagesPopoverController.delegate=self;
	[pagesPopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)showSavedSearches:(id)sender
{
	if (self.searchesPopoverController==nil) {
		self.searchesPopoverController=[[UIPopoverController alloc] initWithContentViewController:savedSearchesViewController];
	}
	self.searchesPopoverController.delegate=self;
	[self.searchesPopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)dealloc {
    [searchesPopoverController release];
	[pagesPopoverController release];
	[pageViewController release];
    [navController release];
	[PagesViewController release];
    [super dealloc];
}

@end
