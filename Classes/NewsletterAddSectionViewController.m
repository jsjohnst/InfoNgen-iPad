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

/*- (CGFloat)tableView:(UITableView*)tableView
 heightForRowAtIndexPath:(NSIndexPath*)indexPath
 {
 switch(indexPath.section)
 {
 case kSummarySection:
 return 220.0;
 break;
 }
 return 40.0;
 }*/


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell;
    
	SavedSearch * savedSearch=[savedSearches objectAtIndex:indexPath.row];
	
	cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:nil] autorelease];
			
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

/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	 return @"Saved Searches";
			
	 
}*/

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	
	SavedSearch * savedSearch=[savedSearches objectAtIndex:indexPath.row];
	
	NewsletterSection * section=[[NewsletterSection alloc] init];
	
	section.savedSearchName=savedSearch.name;
	section.name=savedSearch.name;
	
	[self.newsletter.sections addObject:section];
	
	[section release];
	
	// TODO: programatically go "back" via navigation controller...
	UINavigationController * navController=(UINavigationController*)[self parentViewController];

	[navController popViewControllerAnimated:YES];
	
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
