    //
//  SavedSearchController.m
//  Untitled
//
//  Created by Robert Stewart on 2/3/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "SavedSearchController.h"
#import "AppDelegate.h"

@implementation SavedSearchController
@synthesize list;

- (NSInteger)tableView:(UITableView*)tableView
 numberOfRowsInSection:(NSInteger)section{
	
	return [self.list count];
}

- (UITableViewCell * )tableView:(UITableView*)tableView
		  cellForRowAtIndexPath:(NSIndexPath*)indexPath{
	
	static NSString * savedSearchControllerCell=@"savedSearchControllerCell";
	UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:savedSearchControllerCell];
	if(cell==nil){
		cell=[[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:savedSearchControllerCell] autorelease];
	}
	NSUInteger row=[indexPath row];
	NSString * rowString=[self.list objectAtIndex:row];
	cell.text=rowString;
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
	NSUInteger row=[indexPath row];
	NSString * rowString=[self.list objectAtIndex:row];
	AppDelegate * delegate=
	[[UIApplication sharedApplication] delegate];
	
	//delegate.detailViewController.title=rowString;
}

-(void)tableView:(UITableView*)tableView
accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"Disclosure Button Pressed" message:@"This is the message" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	NSArray * array=[[NSArray alloc] initWithObjects:@"Headline One",@"Headline Two",nil];
	self.list=array;
	[array release];
	
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
	[list release];
    [super dealloc];
}


@end
