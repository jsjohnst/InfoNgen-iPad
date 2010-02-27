    //
//  PageViewController.m
//  Untitled
//
//  Created by Robert Stewart on 2/18/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import "NewsletterViewController.h"
#import "SearchResult.h"
#import "SearchResultCell.h"
#import "Newsletter.h"
#import "DocumentWebViewController.h"
#import "NewsletterSettingsViewController.h"
#import "DocumentEditViewController.h"
#import "NewsletterHTMLPreviewViewController.h"
#import "AppDelegate.h"
#import "NewsletterSection.h"
#import "SavedSearch.h"

@implementation NewsletterViewController
@synthesize newsletterTableView,newsletter,editMoveButton,editSettingsButton,updateButton,previewButton;


- (void)viewWillAppear:(BOOL)animated
{
	NSLog(@"viewWillAppear");

	if(self.newsletter)
	{
		UINavigationController * navController=(UINavigationController*)[self parentViewController];
	
		navController.navigationBar.backItem.title=self.newsletter.name;
	}
	
	[newsletterTableView reloadData];

	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
	NSLog(@"viewDidAppear");
	
	[self renderNewsletter];
	
	[super viewDidAppear:animated];
}

- (void)renderNewsletter
{
	[newsletterTableView reloadData];
}

- (void) addSearchResultToCurrentNewsletter:(SearchResult*)searchResult fromSavedSearch:(SavedSearch*)savedSearch;
{
	// TODO: what section to add to?
}

- (void) setCurrentNewsletter:(Newsletter*)newsletter
{
	self.newsletter=newsletter;
	
	if(self.newsletter)
	{
		self.editSettingsButton.enabled=YES;
		self.editMoveButton.enabled=YES;
		self.updateButton.enabled=YES;
		self.previewButton.enabled=YES;
	}
	
	[self renderNewsletter];
}

- (IBAction) update
{
	// update all the saved searches associated with this page...
	[self performSelectorInBackground:@selector(updateStart) withObject:nil];
	self.updateButton.enabled=NO;
	self.editMoveButton.enabled=NO;
	self.previewButton.enabled=NO;
	self.editSettingsButton.enabled=NO;
}

- (void)updateStart
{
	UIApplication* app = [UIApplication sharedApplication];
	app.networkActivityIndicatorVisible = YES;
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
	NSArray * savedSearches=((AppDelegate*)[app delegate]).savedSearches;
	
	for(int i=0;i<[self.newsletter.sections count];i++)
	{
		NewsletterSection * section=[self.newsletter.sections objectAtIndex:i];
		for(int j=0;j<[savedSearches count];j++)
		{
			SavedSearch * savedSearch=[savedSearches objectAtIndex:j];
			
			if([section.savedSearchName isEqualToString:savedSearch.name])
			{
				[savedSearch update];
				
				NSLog(@"Got %d items from saved search %@",[savedSearch.items count],savedSearch.name);
				
				if(section.items==nil)
				{
					NSMutableArray * tmp=[[NSMutableArray alloc] initWithArray:savedSearch.items];
					
					section.items=tmp;
					
					[tmp release];
				}
				else
				{
					// TODO: only add new items...
					[section.items addObjectsFromArray:savedSearch.items];
				}
				
				NSLog(@"Added %d items to section %@",[section.items count],section.name);
				
				break;
			}
		}
	}
	
	[pool drain];
	app.networkActivityIndicatorVisible = NO;
	[self performSelectorOnMainThread:@selector(updateEnd) withObject:nil waitUntilDone:NO];
}

- (void)updateEnd
{
	self.updateButton.enabled=YES;
	self.editMoveButton.enabled=YES;
	self.previewButton.enabled=YES;
	self.editSettingsButton.enabled=YES;
	UIApplication* app = [UIApplication sharedApplication];
	app.networkActivityIndicatorVisible = NO;
	// reload table...
	[self.newsletterTableView reloadData];
}
 
- (IBAction) settings
{
	NewsletterSettingsViewController * settingsController=[[NewsletterSettingsViewController alloc] initWithNibName:@"NewsletterSettingsView" bundle:nil];
	
	settingsController.newsletter=self.newsletter;
	
	UINavigationController * navController=(UINavigationController*)[self parentViewController];
	
	[navController pushViewController:settingsController animated:YES];
	
	navController.navigationBar.topItem.title=@"Newsletter Settings";
	
	[settingsController release];
}

- (IBAction) toggleEditPage
{
	if(self.newsletterTableView.editing)
	{
		[self.newsletterTableView setEditing:NO animated:YES];
		self.editMoveButton.style=UIBarButtonItemStyleBordered;
		self.editMoveButton.title=@"Edit";
	}
	else
	{
		[self.newsletterTableView setEditing:YES animated:YES];
		self.editMoveButton.style=UIBarButtonItemStyleDone;
		self.editMoveButton.title=@"Done";
	}
}

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
	return YES;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    // Return the number of sections.
    NSLog(@"numberOfSectionsInTableView");
	if(self.newsletter && self.newsletter.sections)
	{
		return [self.newsletter.sections count];
	}
	else
	{
		return 1;
	}
}	

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NewsletterSection * newsletterSection=[self.newsletter.sections objectAtIndex:section];
	return newsletterSection.name;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
	NSMutableArray * tmp=[[NSMutableArray alloc] init];
	
	for (int i=0; i<[self.newsletter.sections count]; i++) {
		
		[tmp addObject:[[self.newsletter.sections objectAtIndex:i] name]];
		
	}
	// TODO: do we need to retain/release/autorelease here???
	return tmp;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSLog(@"numberOfRowsInSection");
	if(self.newsletter==nil)
	{
		return 0;
	}
	else
	{
		NewsletterSection * newsletterSection=[self.newsletter.sections objectAtIndex:section];
		
		return [newsletterSection.items count];
	}
}

- (void) setWidth:(id)obj width:(CGFloat)width
{
	CGRect rect=[obj frame];
	CGSize size=rect.size;
	size.width=width;
	rect.size=size;
	[obj setFrame:rect];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	NSLog(@"cellForRowAtIndexPath");
	
	static NSString *CellIdentifier = @"SearchResultCellIdentifier";
	
	SearchResultCell *cell = (SearchResultCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
    	NSArray * nib=[[NSBundle mainBundle] loadNibNamed:@"SearchResultCell" owner:self options:nil];
		
		cell=[nib objectAtIndex:0];
		
		// setup autoresizing mask so we can set width...
		//cell.autoresizingMask=( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		//cell.headlineLabel.autoresizingMask=( UIViewAutoresizingFlexibleRightMargin);
		//cell.synopsisLabel.autoresizingMask=( UIViewAutoresizingFlexibleRightMargin);
		//cell.dateLabel.autoresizingMask=( UIViewAutoresizingFlexibleRightMargin);
	}
	
	
	int cellWidth=768;
	int textWidth=700;
	
	// 1024x768
	// in portrait view we have full width for table (768 wide)
	// in landscape we have 1024 - 320 = 704 wide
	
	UINavigationController * navController=(UINavigationController*)[self parentViewController];
	
	int parentWidth=navController.view.frame.size.width;
	
	
	
	//int parentWidth=self.parentViewController.view.frame.size.width;
	
	cellWidth=parentWidth;
	textWidth=parentWidth-60;
	/*
	switch([self interfaceOrientation])
	{
		case UIInterfaceOrientationPortrait:
		case UIInterfaceOrientationPortraitUpsideDown:
			cellWidth=768;
			textWidth=700;
			break;
		case UIInterfaceOrientationLandscapeLeft:
		case UIInterfaceOrientationLandscapeRight:
			cellWidth=604;
			textWidth=440;
			break;
		default:
			break;
	}
	*/
	
	
	[self setWidth:cell width:cellWidth];
	[self setWidth:cell.headlineLabel width:textWidth];
	[self setWidth:cell.synopsisLabel width:textWidth];
	[self setWidth:cell.dateLabel width:textWidth];
	
	NewsletterSection * newsletterSection=[self.newsletter.sections objectAtIndex:indexPath.section];
	
	
	SearchResult * result=(SearchResult *)[newsletterSection.items objectAtIndex:indexPath.row];
	//cell.imageView.image=result.image;
	
	cell.headlineLabel.text=[result headline];
	cell.dateLabel.text=[[result date] description];
	cell.synopsisLabel.text=[result synopsis];

	if(result.notes && [result.notes length]>0)
	{
		UIImageView* commentsImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"comment_edit.png"]];
		commentsImageView.frame = CGRectMake(0, 0, 16, 16);
		//cell.accessoryType=UITableViewCellAccessory
		//[cell.contentView addSubview:commentsImageView];
		cell.accessoryView = commentsImageView;
		[commentsImageView release];
	}
	else
	{
		cell.accessoryView=nil;
	}
	//[cell addSubview:mySwitch];
	//cell.accessoryView = mySwitch;

	
	
	
	/*NSString * text=result.synopsis;
	 
	 if(text!=nil && [text length]>0)
	 {
	 CGSize constraint = CGSizeMake(700.0f, 20000.0f);
	 
	 CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
	 
	 CGFloat height = MIN(MAX(size.height, 60.0f),250.0f);
	 
	 [cell.synopsisLabel setFrame:CGRectMake(10.0f, 10.0f, textWidth, MIN(MAX(size.height, 40.0f),200.0f))];
	 
	 }	*/
	
	
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView
heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
	return 80;
	
	// get size of synopsis...
	/*SearchResult * result=(SearchResult *)[self.page.items objectAtIndex:indexPath.row];
	 
	 NSString * text=result.synopsis;
	 
	 if(text==nil || [text length]==0)
	 {
	 return 80;
	 }
	 else {
	 
	 CGSize constraint = CGSizeMake(700.0f, 20000.0f);
	 
	 CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
	 
	 CGFloat height = MIN(MAX(size.height, 60.0f),250.0f);
	 
	 return height + 20.0f;
	 }*/
}

- (BOOL) tableView:(UITableView*)tableView
canMoveRowAtIndexPath:(NSIndexPath*)indexPath
{
	return YES;
}

- (void)tableView:(UITableView*)tableView 
moveRowAtIndexPath:(NSIndexPath*)fromIndexPath
	  toIndexPath:(NSIndexPath*)toIndexPath
{
	NSUInteger fromRow=[fromIndexPath row];
	NSUInteger toRow=[toIndexPath row];
	
	NewsletterSection * newsletterSection1=[self.newsletter.sections objectAtIndex:fromIndexPath.section];
	NewsletterSection * newsletterSection2=[self.newsletter.sections objectAtIndex:toIndexPath.section];
	
	id object=[[newsletterSection1.items objectAtIndex:fromRow] retain];
	[newsletterSection1.items removeObjectAtIndex:fromRow];
	[newsletterSection2.items insertObject:object atIndex:toRow];
	[object release];
}

- (void) tableView:(UITableView*)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath*)indexPath
{
	NSUInteger row=[indexPath	row];
	
	NewsletterSection * newsletterSection=[self.newsletter.sections objectAtIndex:indexPath.section];
	
	[newsletterSection.items removeObjectAtIndex:row];
	[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}


- (IBAction) preview
{
	
	NewsletterHTMLPreviewViewController * previewController=[[NewsletterHTMLPreviewViewController alloc] initWithNibName:@"NewsletterHTMLPreviewView" bundle:nil];
	
	previewController.savedSearches=((AppDelegate*)[[UIApplication sharedApplication] delegate]).savedSearches;
	
	previewController.newsletter=self.newsletter;
									 
	UINavigationController * navController=(UINavigationController*)[self parentViewController];
	
	[navController pushViewController:previewController animated:YES];
	
	navController.navigationBar.topItem.title=@"Newsletter Preview";
	
	[previewController release];
	
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	
	NewsletterSection * newsletterSection=[self.newsletter.sections objectAtIndex:indexPath.section];
	
	SearchResult * result=(SearchResult *)[newsletterSection.items objectAtIndex:indexPath.row];
	
	DocumentEditViewController * editController=[[DocumentEditViewController alloc] initWithNibName:@"DocumentEditView" bundle:nil];
	
	editController.searchResult=result;
	
	UINavigationController * navController=(UINavigationController*)[self parentViewController];
	
	[navController pushViewController:editController animated:YES];
	
	navController.navigationBar.topItem.title=@"Edit Headline";
	
	[editController release];
	
}

- (void)dealloc {
    [newsletterTableView release];
	[editMoveButton release];
	[editSettingsButton release];
	[updateButton release];
	[previewButton release];
	[newsletter release];
    [super dealloc];
}
@end
