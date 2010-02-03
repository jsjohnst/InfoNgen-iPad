    //
//  SavedSearchController.m
//  Untitled
//
//  Created by Robert Stewart on 2/3/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "SavedSearchController.h"
#import "UntitledAppDelegate.h"


@implementation SavedSearchController
@synthesize list;
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
	UntitledAppDelegate * delegate=
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
	[list release];
    [super dealloc];
}


@end
