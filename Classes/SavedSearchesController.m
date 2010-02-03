    //
//   SavedSearchesController.m
//  Untitled
//
//  Created by Robert Stewart on 2/3/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "SavedSearchesController.h"
#import "SavedSearchController.h"
#import "UntitledAppDelegate.h"
#import "MasterViewController.h"

@implementation SavedSearchesController
@synthesize controllers;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	self.title=@"Saved Searches";
	NSMutableArray *array=[[NSMutableArray alloc] init];
	
	for(int i=0;i<10;i++)
	{
		SavedSearchController *ss=[[SavedSearchController alloc] initWithStyle:UITableViewStylePlain];
	
		ss.title=[NSString stringWithFormat:@"Saved Search %d",i];
		[array addObject:ss];
		[ss release];
	}
	
	
	self.controllers=array;
	[array release];
    
	
	[super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
	[controllers release];
    [super dealloc];
}


- (NSInteger)tableView:(UITableView*)tableView
 numberOfRowsInSection:(NSInteger)section{
	
	return [self.controllers count];
}

- (UITableViewCell * )tableView:(UITableView*)tableView
		  cellForRowAtIndexPath:(NSIndexPath*)indexPath{
	static NSString * rootViewControllerCell=@"RootViewControllerCell";
	UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:rootViewControllerCell];
	if(cell==nil){
		cell=[[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:rootViewControllerCell] autorelease];
	}
	NSUInteger row=[indexPath row];
	SavedSearchController * controller =	[controllers objectAtIndex:row];
	cell.text=controller.title;
	return cell;
}

- (UITableViewCellAccessoryType)tableView:(UITableView*)tableView
accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellAccessoryDisclosureIndicator;
}
-(void)tableView:(UITableView*)tableView
didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
	NSUInteger row=[indexPath row];
	SavedSearchController *nextController=[self.controllers objectAtIndex:row];
	UntitledAppDelegate * delegate=
	[[UIApplication sharedApplication] delegate];
	MasterViewController * masterController=delegate.masterViewController;
	UINavigationController * nav = masterController.savedSearchNavController;
	[nav pushViewController:nextController animated:YES];
	//[delegate.masterViewController.savedSearchNavController pushViewController:nextController animated:YES];
	//[delegate.savedSearchNavController pushViewController:nextController animated:YES];
}

@end
