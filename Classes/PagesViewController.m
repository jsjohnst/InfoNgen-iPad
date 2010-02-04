//
//  PagesViewController.m
//  Untitled
//
//  Created by Robert Stewart on 2/2/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "PagesViewController.h"
#import "Page.h"

@implementation PagesViewController
@synthesize pages;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}

- (void)viewDidLoad {
	
	NSMutableArray * array=[[NSMutableArray alloc] init];
	
	for(int i=0;i<20;i++)
	{
		Page * page=[[Page alloc] initWithName:[NSString stringWithFormat:@"Page %d",i]];
		
		[array addObject:page];
		
		[page release];
	}
	
	self.pages=array;
	
	[array release];
	
	[super viewDidLoad];
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
    return [pages count];
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
    Page * page=[pages objectAtIndex:indexPath.row];
	
	cell.textLabel.text = page.name;
	
    return cell;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    

	NSUInteger row=[indexPath row];
	Page * page=[self.pages objectAtIndex:row];
	
	UIAlertView * alert=[[UIAlertView alloc] initWithTitle:page.name message:@"Page selected" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alert show];
	[alert release];
	
}

- (void)dealloc {
	[pages release];
    [super dealloc];
}


@end
