    //
//  NewsletterDetailViewController.m
//  Untitled
//
//  Created by Robert Stewart on 2/22/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import "NewsletterDetailViewController.h"
#import "EditableTableCell.h"

@implementation NewsletterDetailViewController
@synthesize settingsTable;
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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


 /*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}*/

/*
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
}*/


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 3;
}

/*
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
	
}*/

- (void) switched
{
	UIAlertView * a=[[UIAlertView alloc] initWithTitle:@"Switched" message:@"Yep" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	
	[a show];
	
	[a release];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell;
    
	
	switch (indexPath.section) {
		case kTitleSection:
			{
				switch (indexPath.row) {
					case kTitleRow:
					{
						EditableTableCell * textFormCell=[[[EditableTableCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:nil] autorelease];
						
						textFormCell.textField.text=@"Newsletter Title";
						//textFormCell.textField.delegate=self;
						cell=textFormCell;
						//cell.textLabel.text="@Title:";
					}
						break;
					 
					
				}
			}
			break;
		case kLogoImageSection:
		{
			switch (indexPath.row) {
				 
				case kLogoImageRow:
				{
					cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:nil] autorelease];
					cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
					cell.textLabel.text = @"Logo Image";
				}
					
			}
		}
			break;
			
		case kPublishingSection:
			{
	
	 
				
				switch (indexPath.row) {
					 
						 
					case kRssEnabledRow:
						{
							cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
							UISwitch *mySwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
							[cell addSubview:mySwitch];
							cell.accessoryView = mySwitch;
							
							[(UISwitch *)cell.accessoryView addTarget:self action:@selector(switched)
													 forControlEvents:UIControlEventValueChanged];
							
							
							[mySwitch release];
							cell.textLabel.text = @"RSS Enabled";
						}
						break;
					case kPdfEnabledRow:
						{
							cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:nil] autorelease];
							UISwitch *mySwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
							[cell addSubview:mySwitch];
							cell.accessoryView = mySwitch;
							
							[(UISwitch *)cell.accessoryView addTarget:self action:@selector(switched)
													 forControlEvents:UIControlEventValueChanged];
							
							cell.textLabel.text = @"PDF Enabled";
							[mySwitch release];
						}
						break;
					
					case kScheduleRow:
						{
							cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:nil] autorelease];
							cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;	
							cell.textLabel.text = @"Schedule";
							
						}
						break;
					case kSubscribersRow:
						{
							cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:nil] autorelease];
							cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;	
							cell.textLabel.text = @"Subscribers";
						}
						break;
				
				}
			}
	}
	
	    
	//cell.textLabel.text = [NSString stringWithFormat:@"Cell for %d:%d",indexPath.section,indexPath.row];
	
    return cell;
	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	switch (section) {
		case kTitleSection:
			return 1;
		case kLogoImageSection:
			return 1;
		case kPublishingSection:
			return 4;
	}
	return 0;
}


/*- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
	
}*/
/*- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	return [NSString stringWithFormat:@"footer title %d",section];
}*/
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	switch (section) {
		case kTitleSection:
			return @"Title";
		case kLogoImageSection:
			return @"Logo Image";
		case kPublishingSection:
			return @"Publishing Settings";
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
	[settingsTable release];
	
    [super dealloc];
}


@end
