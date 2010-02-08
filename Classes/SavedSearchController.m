    //
//  SavedSearchController.m
//  Untitled
//
//  Created by Robert Stewart on 2/3/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "SavedSearchController.h"
#import "AppDelegate.h"
#import "SavedSearch.h"
#import	"SearchResult.h"
#import "MainViewController.h"
#import "Page.h"

@implementation SavedSearchController
@synthesize savedSearch;

- (NSInteger)tableView:(UITableView*)tableView
 numberOfRowsInSection:(NSInteger)section{
	if(self.savedSearch.items!=nil)
	{
		return [self.savedSearch.items count];
	}
	else 
	{
		return 0;
	}
}

- (UITableViewCell * )tableView:(UITableView*)tableView
		  cellForRowAtIndexPath:(NSIndexPath*)indexPath{
	
	static NSString * savedSearchControllerCell=@"savedSearchControllerCell";
	UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:savedSearchControllerCell];
	if(cell==nil){
		cell=[[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:savedSearchControllerCell] autorelease];
	}
	
	SearchResult * searchResult=[self.savedSearch.items objectAtIndex:indexPath.row];
	
	cell.textLabel.text=[searchResult headline];
	
	return cell;
}

- (UITableViewCellAccessoryType)tableView:(UITableView*)tableView
		 accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellAccessoryDetailDisclosureButton;
}
-(void)tableView:(UITableView*)tableView
didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
	SearchResult * result=[self.savedSearch.items objectAtIndex:indexPath.row];
	
	AppDelegate * delegate=[[UIApplication sharedApplication] delegate];
	
}

-(void)tableView:(UITableView*)tableView
accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	SearchResult * result=[self.savedSearch.items objectAtIndex:indexPath.row];
	
	// add to current page...
	AppDelegate * delegate=[[UIApplication sharedApplication] delegate];
	MainViewController * mainViewController=delegate.mainViewController;
	Page * page=mainViewController.page;
	if(page!=nil)
	{
		[page.items addObject:result];
		[mainViewController renderPage];
	}
	else {
		UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"No current page" message:@"Please select a page to add headlines to" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];

		[alert show];
		[alert release];
	}

	 
	
}

- (void)updateStart
{
	[self.savedSearch update];
	[self performSelectorOnMainThread:@selector(updateEnd) withObject:nil waitUntilDone:NO];
}

- (void)updateEnd
{
	// reload table...
	[self.tableView reloadData];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	// update in the background...
	[self performSelectorInBackground:@selector(updateStart) withObject:nil];
	
	//[self.savedSearch update];
	
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[savedSearch release];
    [super dealloc];
}


@end
