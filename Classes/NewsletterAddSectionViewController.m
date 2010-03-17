    //
//  NewsletterAddSectionViewController.m
//  Untitled
//
//  Created by Robert Stewart on 2/25/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import "NewsletterAddSectionViewController.h"
#import "SavedSearch.h"
#import "NewsletterSection.h"
#import "Newsletter.h"
#import "AppDelegate.h"

@implementation NewsletterAddSectionViewController
@synthesize sectionsTable,newsletter ,savedSearches;

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

// The size the view should be when presented in a popover.
- (CGSize)contentSizeForViewInPopoverView {
    return CGSizeMake(320.0, 600.0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell;
    
	SavedSearch * savedSearch=[savedSearches objectAtIndex:indexPath.row];
	
	cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:nil] autorelease];
	
	cell.selectionStyle=UITableViewCellSelectionStyleNone;
	
	for (int i=0; i<[self.newsletter.sections count]; i++) {
		NewsletterSection * section=[self.newsletter.sections objectAtIndex:i];
		if([section.savedSearchName isEqualToString:savedSearch.name])
		{
			cell.accessoryType=UITableViewCellAccessoryCheckmark;
			break;
		}
	}
	
	cell.textLabel.text = savedSearch.name;
	
	return cell;
	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [savedSearches count];
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	SavedSearch * savedSearch=[savedSearches objectAtIndex:indexPath.row];
	
	for (int i=0; i<[self.newsletter.sections count]; i++) {
		NewsletterSection * section=[self.newsletter.sections objectAtIndex:i];
		if([section.savedSearchName isEqualToString:savedSearch.name])
		{
			return; // already added... so remove it...?
		}
	}
	
	NewsletterSection * section=[[NewsletterSection alloc] init];
	
	section.savedSearchName=savedSearch.name;
	section.name=savedSearch.name;
	
	[self.newsletter.sections addObject:section];
	
	[section release];
	
	[aTableView reloadData];
	
	AppDelegate * delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
	
	[delegate renderNewsletter];	
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
	[sectionsTable release];
	[newsletter release];
	[savedSearches release];
    [super dealloc];
}



@end
