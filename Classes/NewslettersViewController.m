//
//  PagesViewController.m
//  Untitled
//
//  Created by Robert Stewart on 2/2/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "NewslettersViewController.h"
#import "Newsletter.h"
#import "MainViewController.h"
#import "AppDelegate.h"

@implementation NewslettersViewController
@synthesize newsletters,newslettersTable;

- (void)viewDidLoad {
	[super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
	[self.newslettersTable reloadData];
	
	[super viewDidAppear:animated];
}

- (IBAction) newNewsletter
{
	Newsletter  * newNewsletter=[[Newsletter alloc] initWithName:@"Untitled"];
	
	[self.newsletters addObject:newNewsletter];
	
	AppDelegate * delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
	
	[delegate setCurrentNewsletter:newNewsletter];
	
	[newNewsletter release];
}

// The size the view should be when presented in a popover.
- (CGSize)contentSizeForViewInPopoverView {
    return CGSizeMake(320.0, 600.0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [newsletters count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"CellIdentifier";
	
	// Dequeue or create a cell of the appropriate type.
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    // Get the object to display and set the value in the cell.
    Newsletter  * newsletter=[newsletters objectAtIndex:indexPath.row];
	
	cell.textLabel.text = newsletter.name;
	
    return cell;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	Newsletter * newsletter=[self.newsletters objectAtIndex:indexPath.row];
	
	AppDelegate * delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
	
	[delegate setCurrentNewsletter:newsletter];
}

- (void)dealloc {
	[newsletters release];
	[newslettersTable release];
    [super dealloc];
}

@end
