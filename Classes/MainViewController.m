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

@implementation MainViewController

@synthesize page,pageTableView,navigationBar,popoverController,pagesPopoverController,popoverController2,savedSearchesViewController;

- (IBAction)newPage:(id)sender
{
	
}

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
    
    barButtonItem.title = @"Searches";
    [navigationBar.topItem setLeftBarButtonItem:barButtonItem animated:YES];
	
	self.popoverController = pc;
}

- (void)setCurrentPage:(Page*)thePage
{
	self.page=thePage;
	
	navigationBar.topItem.title=thePage.name;
	
	[pagesPopoverController dismissPopoverAnimated:YES];
	
	[self renderPage];
}

- (void)renderPage
{
	[pageTableView reloadData];
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

- (IBAction) toggleEditPage
{
	[self.pageTableView setEditing:!self.pageTableView.editing animated:YES];
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
- (void) setWidth:(id)obj width:(CGFloat)width
{
	CGRect rect=[obj frame];
	CGSize size=rect.size;
	size.width=width;
	rect.size=size;
	[obj setFrame:rect];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"SearchResultCellIdentifier";
	
	SearchResultCell *cell = (SearchResultCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
    	NSArray * nib=[[NSBundle mainBundle] loadNibNamed:@"SearchResultCell" owner:self options:nil];
		
		cell=[nib objectAtIndex:0];
	
		[self setWidth:cell width:796];
		[self setWidth:cell.headlineLabel width:700];
		[self setWidth:cell.synopsisLabel width:700];
		[self setWidth:cell.dateLabel width:700];
	}
	
	SearchResult * result=(SearchResult *)[self.page.items objectAtIndex:indexPath.row];
	
	cell.headlineLabel.text=[result headline];
	cell.dateLabel.text=[[result date] description];
	cell.synopsisLabel.text=[result synopsis];
		
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView
heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
	return 80;
}

- (BOOL) tableView:(UITableView*)tableView
canMoveRowAtIndexPath:(NSIndexPath*)indexPath
{
	return YES;
}

- (void)tableView:(UITableView*)tableView 
moveRowAtIndexPath:(NSIndexPath*)fromIndexPath
toIndexPath:(NSIndexPath*)toIndexPath
{
	NSUInteger fromRow=[fromIndexPath row];
	NSUInteger toRow=[toIndexPath row];
	
	 id object=[[self.page.items objectAtIndex:fromRow] retain];
	 [self.page.items removeObjectAtIndex:fromRow];
	 [self.page.items insertObject:object atIndex:toRow];
	 [object release];
}
	 
- (void) tableView:(UITableView*)tableView
	 commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
	 forRowAtIndexPath:(NSIndexPath*)indexPath
{
	NSUInteger row=[indexPath	row];
	[self.page.items removeObjectAtIndex:row];
	[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}
		
- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSUInteger row=[indexPath row];
	
	UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"Selected page item" message:@"Page item selected" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	 [alert show];
	 [alert release];
}

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    self.popoverController = nil;
}

- (void)dealloc {
    [popoverController release];
	[popoverController2 release];
    [pagesPopoverController release];
    [navigationBar release];
	[pageTableView release];
    [page release];
    [super dealloc];
}

@end
