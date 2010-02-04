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

@implementation MainViewController

@synthesize navigationBar,popoverController,pagesPopoverController,popoverController2, detailItem,savedSearchesViewController;

/*
 When setting the detail item, update the view and dismiss the popover controller if it's showing.
 */
- (void)setDetailItem:(id)newDetailItem {
    if (detailItem != newDetailItem) {
        [detailItem release];
        detailItem = [newDetailItem retain];
        
        navigationBar.topItem.title = [detailItem description];
    }

    if (popoverController != nil) {
        [popoverController dismissPopoverAnimated:YES];
    }        
}

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
    
    barButtonItem.title = @"Searches";
    [navigationBar.topItem setLeftBarButtonItem:barButtonItem animated:YES];
	
	self.popoverController = pc;
}


// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    
	[navigationBar.topItem setLeftBarButtonItem:nil animated:YES];
    self.popoverController = nil;
}

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (IBAction)showPagesTable:(id)sender{
		
	PagesViewController *pages=[[PagesViewController alloc] init];
	// TODO: cache this and reuse it?
	if (self.pagesPopoverController==nil) {
		pagesPopoverController=[[UIPopoverController alloc] initWithContentViewController:pages];
	}
	
	pagesPopoverController.delegate=self;
	[pagesPopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	[pages release];
}

- (IBAction)showSavedSearches:(id)sender
{
	if (self.popoverController2==nil) {
		self.popoverController2=[[UIPopoverController alloc] initWithContentViewController:savedSearchesViewController];
	
	}
	self.popoverController2.delegate=self;
	[self.popoverController2 presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.popoverController = nil;
}

- (void)dealloc {
    [popoverController release];
	[popoverController2 release];
    [pagesPopoverController release];
    [navigationBar release];
    
    [detailItem release];
    [super dealloc];
}

@end
