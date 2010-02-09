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
#import "SearchResultCell.h"


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
	
	static NSString * savedSearchControllerCell=@"SearchResultCellIdentifier";

	SearchResultCell *cell=(SearchResultCell*)[tableView dequeueReusableCellWithIdentifier:savedSearchControllerCell];
	
	if(cell==nil){
		
		NSArray * nib=[[NSBundle mainBundle] loadNibNamed:@"SearchResultCell" owner:self options:nil];
		
		cell=[nib objectAtIndex:0];
	}
	
	SearchResult * searchResult=[self.savedSearch.items objectAtIndex:indexPath.row];
	
	cell.headlineLabel.text=[searchResult headline];
	cell.dateLabel.text=[[searchResult date] description];
	cell.synopsisLabel.text=[searchResult synopsis];
	
	return cell;
}

-(void)tableView:(UITableView*)tableView
didSelectRowAtIndexPath:(NSIndexPath*)indexPath
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
	else 
	{
		UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"No current page" message:@"Please select a page to add headlines to" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		
		[alert show];
		[alert release];
	}
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView*)tableView
heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
	return 80;
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
	else 
	{
		UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"No current page" message:@"Please select a page to add headlines to" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];

		[alert show];
		[alert release];
	}
}

- (void)updateStart
{
	UIApplication* app = [UIApplication sharedApplication];
	app.networkActivityIndicatorVisible = YES;
	[self.savedSearch update];
	app.networkActivityIndicatorVisible = NO;
	[self performSelectorOnMainThread:@selector(updateEnd) withObject:nil waitUntilDone:NO];
}

- (void)updateEnd
{
	UIApplication* app = [UIApplication sharedApplication];
	app.networkActivityIndicatorVisible = NO;
	// reload table...
	[self.tableView reloadData];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {

	// update in the background...
	[self performSelectorInBackground:@selector(updateStart) withObject:nil];
	
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
