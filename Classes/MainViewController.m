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

@implementation MainViewController

@synthesize page,pageTableView,navigationBar,popoverController,pagesPopoverController,popoverController2,savedSearchesViewController;

/*
 When setting the detail item, update the view and dismiss the popover controller if it's showing.
 */
/*- (void)setDetailItem:(id)newDetailItem {
    if (detailItem != newDetailItem) {
        [detailItem release];
        detailItem = [newDetailItem retain];
        
        navigationBar.topItem.title = [detailItem description];
    }

    if (popoverController != nil) {
        [popoverController dismissPopoverAnimated:YES];
    }        
}*/

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
    
    barButtonItem.title = @"Searches";
    [navigationBar.topItem setLeftBarButtonItem:barButtonItem animated:YES];
	
	self.popoverController = pc;
}

- (void)setCurrentPage:(Page*)thePage
{
	self.page=thePage;
	
	navigationBar.topItem.title=thePage.name;
	//self.title=thePage.name;
	
	[pagesPopoverController dismissPopoverAnimated:YES];
	
	[self renderPage];
}

- (void)renderPage
{
	//[pageTableView release];
	[pageTableView reloadData];
	
	/*if(self.page!=nil)
	{
		//[self.view subview
		//pageTableView=[[UITableView alloc] init];
		//pageTableView.delegate=self;
		//pageTableView.dataSource=self;
		
		//[self.view addSubview:pageTableView];
		//[pageTableView release];
	}*/
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(self.page==nil)
	{
		return 0;
	}
	else
	{
		return [self.page.items count];
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"CellIdentifier";
	
	// Dequeue or create a cell of the appropriate type.
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
	cell.textLabel.text =[[self.page.items objectAtIndex:indexPath.row] description];
	
    // Get the object to display and set the value in the cell.
    //Page * page=[pages objectAtIndex:indexPath.row];
	
	//cell.textLabel.text = page.name;
	
    return cell;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	
	NSUInteger row=[indexPath row];
	
	UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"Selected page item" message:@"Page item selected" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	 [alert show];
	 [alert release];
	 
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
	[pageTableView release];
    
    //[detailItem release];
    [super dealloc];
}

@end
