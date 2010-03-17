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
#import <QuartzCore/QuartzCore.h>
#import "NewsletterItemContentView.h"

@implementation NewsletterViewController
@synthesize newsletterTableView,editMoveButton;

- (void)viewWillAppear:(BOOL)animated
{
	NSLog(@"NewsletterViewController.viewWillAppear");
	if(self.newsletter)
	{
		//UINavigationController * navController=(UINavigationController*)[self parentViewController];
	
		//navController.navigationBar.backItem.title=self.newsletter.name;
		
		UINavigationController * navController=[(AppDelegate*)[[UIApplication sharedApplication] delegate] navigationController];
		
		UIBarButtonItem *button=[[UIBarButtonItem alloc] init];
		
		button.title=@"Edit";
		
		button.target=self;
		
		button.action=@selector(toggleEditPage:);
		
		navController.navigationBar.topItem.rightBarButtonItem=button;
		
		[button release];
	}
	
	[newsletterTableView reloadData];

	[super viewWillAppear:animated];
}

-(void) setButtonsEnabled:(BOOL)enabled
{
	//if(!newsletterTableView.editing)
	//{
	//	self.editMoveButton.enabled=enabled;
	//}

	//self.deleteButton.enabled=enabled;
	//self.updateButton.enabled=enabled;
	//self.editSettingsButton.enabled=enabled;
	
	//[self.viewModeSegmentedControl setEnabled:enabled forSegmentAtIndex:0];
	//[self.viewModeSegmentedControl setEnabled:enabled forSegmentAtIndex:1];
	//[self.viewModeSegmentedControl setEnabled:enabled forSegmentAtIndex:2];	
}

- (void)viewDidAppear:(BOOL)animated
{
	
	[super viewDidAppear:animated];
	
}

/*- (IBAction) clearNewsletterItems
{
	if(newsletterTableView.editing)
	{
		UIActionSheet * actionSheet=[[UIActionSheet alloc] initWithTitle:@"Remove Selected Items" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Remove Selected Items" otherButtonTitles:nil];
		
		actionSheet.tag=kClearSelectedItemsActionSheet;
		
		[actionSheet showFromToolbar:self.toolBar];
		
		[actionSheet release];
	}
	else
	{
		UIActionSheet * actionSheet=[[UIActionSheet alloc] initWithTitle:@"Remove All Newsletter Items" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Remove All Items" otherButtonTitles:nil];
	
		actionSheet.tag=kClearItemsActionSheet;
	
		[actionSheet showFromToolbar:self.toolBar];
	
		[actionSheet release];
	}
}

- (IBAction) deleteNewsletter
{
	UIActionSheet * actionSheet=[[UIActionSheet alloc] initWithTitle:@"Delete Newsletter" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:nil];
	
	actionSheet.tag=kDeleteActionSheet;
	
	[actionSheet showFromToolbar:self.toolBar];
	
	[actionSheet release];
}

-(void) closePreview
{
	if(self.previewController!=nil)
	{
		[self.previewController.view removeFromSuperview];
		[previewController release];
		previewController=nil;
	}	
}

-(void) toggleViewMode:(id)sender
{
	if([self.viewModeSegmentedControl selectedSegmentIndex]!=2)
	{
		if(self.previewController!=nil)
		{
			//[UIView beginAnimations:nil context:NULL];  
			//[UIView setAnimationDuration:0.5];  
			//[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.newsletterTableView cache:YES];  
		
			[self closePreview];
			
			//[UIView commitAnimations]; 
		}
		
		[self.newsletterTableView reloadData];
	}
	else 
	{
		[self preview];
	}
}*/

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex==0)
	{
		if(actionSheet.tag==kDeleteActionSheet)
		{
			//user clicked delete...
			
			AppDelegate * delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
			
			// delete current newsletter from newsletters list...
			delegate.newsletter=nil;
			[delegate.newsletters removeObject:self.newsletter];
			self.newsletter=nil;
			
			[self setButtonsEnabled:NO];
			
			[self renderNewsletter];
			
			UINavigationController * navController=(UINavigationController*)[self parentViewController];
			
			navController.navigationBar.topItem.title=@"InfoNgen Newsletter Editor";
			
			UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"Delete" message:@"Newsletter has been deleted." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			
			[alertView show];
			
			[alertView release];
		}
		else
		{
			if(actionSheet.tag==kClearItemsActionSheet)
			{
				for(NewsletterSection * section in self.newsletter.sections)
				{
					[section.items removeAllObjects];
				}
				
				[self renderNewsletter];
			}
			else 
			{
				if(actionSheet.tag==kClearSelectedItemsActionSheet)
				{
					[self deleteSelectedRows];
					
					
					[self toggleEditPage];
				}
			}
		}
	}
}
- (void) deleteSelectedRows
{
	NSArray* selectedRows = [newsletterTableView indexPathsForSelectedRows];
	
	NSMutableDictionary * dict=[[NSMutableDictionary alloc] init];
	
	if (selectedRows && [selectedRows count]>0) 
	{
		for (NSIndexPath * indexPath in selectedRows)
		{
			
			NSNumber * sectionNumber=[NSNumber numberWithUnsignedInt:indexPath.section];
			
			NSArray * tmp=[dict objectForKey:sectionNumber];
			
			if(tmp==nil)
			{
				
				NewsletterSection * section = [self.newsletter.sections objectAtIndex:indexPath.section];
				NSMutableIndexSet * rows=[[NSMutableIndexSet alloc] init];
				
				tmp=[NSArray arrayWithObjects:section,rows,nil];
				
				[dict setObject:tmp forKey:sectionNumber];
			}
			
			[[tmp objectAtIndex:1] addIndex:indexPath.row];
		}
	}
	
	for(NSArray * array in [dict allValues])
	{
		NewsletterSection * section=[array objectAtIndex:0];
		NSMutableIndexSet * rows=[array objectAtIndex:1];
		
		[section.items removeObjectsAtIndexes:rows];
	}
	
	[dict release];
	
	[self.newsletterTableView deleteRowsAtIndexPaths:selectedRows withRowAnimation:UITableViewRowAnimationFade];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
}



- (void)renderNewsletter
{
	[newsletterTableView reloadData];
	
	/*if(self.newsletter==nil)
	{
		[self setButtonsEnabled:NO];
	}
	else 
	{
		[self setButtonsEnabled:YES];
	}*/
}

- (void) addSearchResultToCurrentNewsletter:(SearchResult*)searchResult fromSavedSearch:(SavedSearch*)savedSearch;
{
	// TODO: what section to add to?
	
	// if newsletter has no sections, add a new section with this saved search and add the item...
	
	// if newsletter has a section with same saved search, append to that section
	// otherwise, create a new section for that saved search...
	NewsletterSection * section=nil;
	
	// when adding item put newest items on top by default (sort by date desc)
	if(self.newsletter.sections && [self.newsletter.sections count]>0)
	{
		for(NewsletterSection * tmp in self.newsletter.sections)
		{
			if([tmp.savedSearchName isEqualToString:savedSearch.name])
			{
				section=tmp;
				break;
			}
		}
	}
	
	if(section==nil)
	{
		// section not found, create new section
		section=[[NewsletterSection alloc] init];
		section.name=savedSearch.name;
		section.savedSearchName=savedSearch.name;
		[self.newsletter.sections addObject:section];
	}
	
	if(section.items==nil)
	{
		section.items=[[NSMutableArray alloc] init];
	}
	
	if ([section.items count]==0) 
	{
		[section.items addObject:[searchResult copy]];
	}
	else 
	{
		
		//find location to insert object
		// we will by default sort by date desc (newest at top)
		// so start from the top and insert item where it fits based on date
		int  i=0;
		
		for(i=0;i<[section.items count];i++)
		{
			SearchResult * tmp=[section.items objectAtIndex:i];
			if(tmp.date < searchResult.date)
			{
				break;
			}
		}
		
		if (i<[section.items count]) {
			[section.items insertObject:searchResult atIndex:i];
		}
		else {
			[section.items addObject:searchResult];
		}
	}
	
	[self renderNewsletter];
}

/*- (void) setCurrentNewsletter:(Newsletter*)newsletter
{
	[self closePreview];
	
	self.viewModeSegmentedControl.selectedSegmentIndex=1;
	
	self.newsletter=newsletter;

	// set current newsletter in app delegate so it can always remember last newsletter to show again on restart...
	AppDelegate * delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
	
	delegate.newsletter = self.newsletter;
	
	[self renderNewsletter];
}*/

- (IBAction) update
{
	if(!updating)
	{
		[self setButtonsEnabled:NO];
	
		updating=YES;
	
		[newsletterTableView reloadData];
	
		// update all the saved searches associated with this page...
		[self performSelectorInBackground:@selector(updateStart) withObject:nil];
	
		//UINavigationController * navController=(UINavigationController*)[self parentViewController];
	
		//navController.navigationBar.topItem.title=@"Updating Newsletter...";//     self.newsletter.name;
	}
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
				
				if (savedSearch.items && [savedSearch.items count]>0) 
				{
					NSLog(@"Got %d items from saved search %@",[savedSearch.items count],savedSearch.name);
					
					if(section.items==nil || [section.items count]==0)
					{
						NSMutableArray * tmp=[[NSMutableArray alloc] initWithArray:savedSearch.items];
						
						section.items=tmp;
						
						[tmp release];
					}
					else
					{
				
						// only add new items, and dont add duplicates...
						NSMutableDictionary * dict=[[NSMutableDictionary alloc] init];
						
						// initialize date 7 days ago
						NSDate * maxDate=[NSDate dateWithTimeIntervalSinceNow:-(60*60*24*7)];
						
						for(SearchResult * result in section.items)
						{
							[dict setObject:result forKey:result.headline];
							if(result.url && [result.url length]>30)
							{
								[dict setObject:result forKey:result.url];
							}
							if(result.date > maxDate)
							{
								maxDate=result.date;
							}
						}
						
						int index=0;
						
						// only add in items that are newer than our max date we already have
						for(SearchResult * result in savedSearch.items)
						{
							// dont add duplicate headlines
							if ([dict objectForKey:result.headline]==nil) 
							{
								if(result.url==nil || [result.url length]<30 || ([dict objectForKey:result.url]==nil))
								{
									// only add if its newer than existing items
									if(result.date >=maxDate)
									{
										// insert at front in sorted order (newest first)
										[section.items insertObject:result atIndex:index];
										index++;
									}
								}
							}
						}
						
						[dict release];
					}
				}
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
	updating=NO;
	[self setButtonsEnabled:YES];
	
	UIApplication* app = [UIApplication sharedApplication];
	app.networkActivityIndicatorVisible = NO;
	// reload table...
	[self.newsletterTableView reloadData];
	
	//UINavigationController * navController=(UINavigationController*)[self parentViewController];
	
	//navController.navigationBar.topItem.title=self.newsletter.name;
}
 
/*- (IBAction) settings
{
	NewsletterSettingsViewController * settingsController=[[NewsletterSettingsViewController alloc] initWithNibName:@"NewsletterSettingsView" bundle:nil];
	
	settingsController.newsletter=self.newsletter;
	
	UINavigationController * navController=(UINavigationController*)[self parentViewController];
	
	[navController pushViewController:settingsController animated:YES];
	
	navController.navigationBar.topItem.title=@"Newsletter Settings";
	
	[settingsController release];
}
*/

-(void) setViewMode:(BOOL)expanded
{
	viewModeExpanded=expanded;
}

- (IBAction) toggleEditPage:(id)sender
{
	UIBarButtonItem * buttonItem=(UIBarButtonItem*)sender;
	
	if(self.newsletterTableView.editing)
	{
		[self deleteSelectedRows];
		
		[self.newsletterTableView setEditing:NO animated:YES];
		
		buttonItem.style=UIBarButtonItemStyleBordered;
		buttonItem.title=@"Edit";
	}
	else
	{
		[self.newsletterTableView setEditing:YES animated:YES];
		buttonItem.style=UIBarButtonItemStyleDone;
		buttonItem.title=@"Done";
		//[self setButtonsEnabled:NO];
		//self.deleteButton.enabled=YES;
	}
}

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{    
	return YES;
}

-(BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath 
{
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
	
	if(self.newsletter)
	{
		[self setButtonsEnabled:YES];
	}
	
	if(self.newsletter && self.newsletter.sections)
	{
		return [self.newsletter.sections count];
	}
	else
	{
		return 0;
	}
}	

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	NewsletterSection * newsletterSection=[self.newsletter.sections objectAtIndex:section];

	UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, newsletterTableView.frame.size.width, 40)];
	topView.backgroundColor=[UIColor lightGrayColor];
	
	CAGradientLayer *gradient = [CAGradientLayer layer];
	gradient.frame = topView.bounds;
	gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor lightGrayColor] CGColor],(id)[[UIColor grayColor] CGColor], (id)[[UIColor lightGrayColor] CGColor], nil];
	[topView.layer insertSublayer:gradient atIndex:0];
	
	UILabel *nameLabel = [self newLabelWithPrimaryColor:[UIColor whiteColor] selectedColor:[UIColor whiteColor] fontSize:20 bold:YES];
	[nameLabel setFrame:CGRectMake(10, 10, 450, 22)];
	nameLabel.backgroundColor=[UIColor clearColor];
	nameLabel.text = newsletterSection.name;
	
	[topView addSubview:nameLabel];
	
	if(updating)
	{
		UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		[activityView setFrame:CGRectMake(newsletterTableView.frame.size.width-35, 10, 25, 25)];
		[activityView startAnimating];
		[topView addSubview:activityView];
		[activityView release];
	}
	else 
	{
		UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[refreshButton setImage:[UIImage imageNamed:@"icon_refresh.png"] forState:UIControlStateNormal];
		[refreshButton setFrame:CGRectMake(newsletterTableView.frame.size.width-35, 10, 25, 25)];
		[refreshButton addTarget:self action:@selector(update) forControlEvents:UIControlEventTouchUpInside];
		[topView addSubview:refreshButton];
	}

	return topView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 40;
}

- (UILabel *)newLabelWithPrimaryColor:(UIColor *)primaryColor selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold
{
    UIFont *font;
    if (bold) 
        font = [UIFont boldSystemFontOfSize:fontSize];
    else 
        font = [UIFont systemFontOfSize:fontSize];
    
	
	UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	newLabel.backgroundColor = [UIColor whiteColor];
	newLabel.opaque = YES;
	newLabel.textColor = primaryColor;
	newLabel.highlightedTextColor = selectedColor;
	newLabel.font = font;
	
	return newLabel;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSLog(@"numberOfRowsInSection");
	if(self.newsletter==nil || self.newsletter.sections==nil)
	{
		return 0;
	}
	else
	{
		NewsletterSection * newsletterSection=[self.newsletter.sections objectAtIndex:section];
		
		if (newsletterSection==nil) 
		{
			return 0;
		}
		else
		{
			return [newsletterSection.items count];
		}
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
	 
	UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if(cell==nil)
	{
		cell=[[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
	
		cell.contentView.autoresizesSubviews=YES;
		//cell.selectionStyle=UITableViewCellSelectionStyleNone;
	
		NewsletterItemContentView * contentView=[[NewsletterItemContentView alloc] initWithFrame:CGRectMake(0.0, 0.0, cell.contentView.bounds.size.width, cell.contentView.bounds.size.height)];
	
		// set view mode...
		//[contentView setViewMode:viewModeSegmentedControl];
		contentView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		contentView.parentController=self;
		contentView.parentTableView=tableView;
	
		[cell.contentView addSubview:contentView];
	
		contentView.contentMode=UIViewContentModeRedraw;
	}
	
	NewsletterSection * newsletterSection=[self.newsletter.sections objectAtIndex:indexPath.section];
	SearchResult * result=(SearchResult *)[newsletterSection.items objectAtIndex:indexPath.row];
	NewsletterItemContentView * contentView=(NewsletterItemContentView *)[cell.contentView.subviews objectAtIndex:[cell.contentView.subviews count]-1];
	[contentView setViewMode:viewModeExpanded];
	//[contentView setViewMode:([self.viewModeSegmentedControl selectedSegmentIndex]==1)];
	contentView.searchResult=result;
	[contentView setNeedsDisplay];
		
	return cell;
}

- (BOOL) tableView:(UITableView*)tableView
canMoveRowAtIndexPath:(NSIndexPath*)indexPath
{
	return YES;
}

- (CGFloat)tableView:(UITableView*)tableView
heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
	NewsletterSection * newsletterSection=[self.newsletter.sections objectAtIndex:indexPath.section];

	SearchResult * result=(SearchResult *)[newsletterSection.items objectAtIndex:indexPath.row];
	
	//ItemSize itemSize=[NewsletterItemContentView sizeForCell:result viewMode:([self.viewModeSegmentedControl selectedSegmentIndex]==1) rect:CGRectZero];
	ItemSize itemSize=[NewsletterItemContentView sizeForCell:result viewMode:viewModeExpanded rect:CGRectZero];
	
	return itemSize.size.height;
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

-(UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath {

	return 3;
	//return UITableViewCellEditingStyleDelete;
}

- (void) scrollToSection:(NSString*)sectionName
{
	// get section by name
	int section_number=0;
	
	for(NewsletterSection * section in self.newsletter.sections)
	{
		if([section.savedSearchName isEqualToString:sectionName])
		{
			break;
		}
		section_number++;
	}
	
	//if(section_number<[self.newsletterTableView.sections count])
	//{
		NSIndexPath * indexPath=[NSIndexPath indexPathForRow:NSNotFound inSection:section_number];
	
		[self.newsletterTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
	//}
}
/*
- (IBAction) preview
{
	if(self.newsletter==nil)
	{
		return;
	}
	
	self.previewController=[[NewsletterHTMLPreviewViewController alloc] initWithNibName:@"NewsletterHTMLPreviewView" bundle:nil];
	
	//previewController.savedSearches=((AppDelegate*)[[UIApplication sharedApplication] delegate]).savedSearches;

	previewController.newsletter=self.newsletter;

	//[UIView beginAnimations:nil context:NULL];  
	//[UIView setAnimationDuration:0.5];  
	//[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.newsletterTableView cache:YES];  

	[self.view addSubview:previewController.view];
	[self.view bringSubviewToFront:previewController.view];

	//[self.newsletterTableView addSubview:previewController.view];  
	//[self.newsletterTableView bringSubviewToFront:previewController.view];
	
	//[UIView commitAnimations];  
}*/
/*
- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if(!aTableView.editing)
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
}
*/
- (void)dealloc {
    [newsletterTableView release];
	[editMoveButton release];
	    [super dealloc];
}
@end
