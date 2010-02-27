    //
//  NewsletterSectionsViewController.m
//  Untitled
//
//  Created by Robert Stewart on 2/25/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import "NewsletterSectionsViewController.h"
#import "NewsletterAddSectionViewController.h"
#import "NewsletterSection.h"
#import "AppDelegate.h"
#import "Newsletter.h";

@implementation NewsletterSectionsViewController
@synthesize sectionsTable,newsletter;


// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
	return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if(tableView.editing)
	{
		return 1;
	}
	else
	{
		return 2;
	}
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

- (void) edit:(id)sender
{
	UINavigationController * navController=(UINavigationController*)[self parentViewController];
	navController.navigationBar.topItem.rightBarButtonItem.title=@"Done";
	navController.navigationBar.topItem.rightBarButtonItem.style=UIBarButtonItemStyleDone;
	navController.navigationBar.topItem.rightBarButtonItem.action=@selector(editDone:);
	[self.sectionsTable setEditing:YES animated:YES];
	[self.sectionsTable reloadData];
	
}

- (void)editDone:(id)sender
{
	UINavigationController * navController=(UINavigationController*)[self parentViewController];
	navController.navigationBar.topItem.rightBarButtonItem.title=@"Edit";
	navController.navigationBar.topItem.rightBarButtonItem.style=UIBarButtonItemStylePlain;
	navController.navigationBar.topItem.rightBarButtonItem.action=@selector(edit:);
	[self.sectionsTable setEditing:NO animated:YES];
	[self.sectionsTable reloadData];


}

- (BOOL) tableView:(UITableView*)tableView
canMoveRowAtIndexPath:(NSIndexPath*)indexPath
{
	NSLog(@"canMoveRowAtIndexPath");
	return tableView.editing;
	//return YES;
}

- (void)tableView:(UITableView*)tableView 
moveRowAtIndexPath:(NSIndexPath*)fromIndexPath
	  toIndexPath:(NSIndexPath*)toIndexPath
{
	NSLog(@"moveRowAtIndexPath");
	NSUInteger fromRow=[fromIndexPath row];
	NSUInteger toRow=[toIndexPath row];
	
	id object=[[self.newsletter.sections objectAtIndex:fromRow] retain];
	[self.newsletter.sections removeObjectAtIndex:fromRow];
	[self.newsletter.sections insertObject:object atIndex:toRow];
	[object release];
}

- (void) tableView:(UITableView*)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath*)indexPath
{
	NSLog(@"commitEditingStyle");
	
	if(tableView.editing)
	{
		NSUInteger row=[indexPath	row];
		[self.newsletter.sections removeObjectAtIndex:row];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
}

-(BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath {
	
	NSLog(@"canEditRowAtIndexPath");
	
	if(tableView.editing) 
	{
		return YES;
	}
	else
	{
		return NO;
	}
} 

- (void)viewWillAppear:(BOOL)animated
{
	[self.sectionsTable reloadData];
	
	[super viewWillAppear:animated];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell;
    
	switch (indexPath.section) {
			
		case kSectionsSection:
		{
			NewsletterSection * section=[self.newsletter.sections objectAtIndex:indexPath.row];
			
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:nil] autorelease];
			//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			cell.textLabel.text = section.name;
		}
			break;
		case kAddSectionSection:
		{
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:nil] autorelease];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			cell.textLabel.text = @"Add Saved Search...";
		}
			break;
	}
	
	return cell;
	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	switch (section) {
		case kSectionsSection:
			return [self.newsletter.sections count];
		case kAddSectionSection:
			return 1;
		 
			
	}
	return 0;
}
/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	switch (section) 
	{
		case kSectionsSection:
			return @"Saved Searches";
		
	}
	return nil;
}*/

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if(indexPath.section==kAddSectionSection)
	{
		NewsletterAddSectionViewController * sectionsController=[[NewsletterAddSectionViewController alloc] initWithNibName:@"NewsletterAddSectionView" bundle:nil];
		
		sectionsController.newsletter=self.newsletter;
		
		AppDelegate * delegate=[[UIApplication sharedApplication] delegate];
		
		sectionsController.savedSearches=delegate.savedSearches;
		
		UINavigationController * navController=(UINavigationController*)[self parentViewController];
		
		[navController pushViewController:sectionsController animated:YES];
		
		navController.navigationBar.topItem.title=@"Add Saved Search...";
		
		[sectionsController release];
	}
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
    [super dealloc];
}


@end
