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

@implementation NewsletterViewController
@synthesize newsletterTableView,newsletter,editMoveButton,editSettingsButton,updateButton,previewButton,toolBar,deleteButton,clearButton;

- (void)viewWillAppear:(BOOL)animated
{
	NSLog(@"NewsletterViewController.viewWillAppear");

	if(self.newsletter)
	{
		UINavigationController * navController=(UINavigationController*)[self parentViewController];
	
		navController.navigationBar.backItem.title=self.newsletter.name;
	}
	
	[newsletterTableView reloadData];

	[super viewWillAppear:animated];
}

-(void) setButtonsEnabled:(BOOL)enabled
{
	if(!newsletterTableView.editing)
	{
		self.editMoveButton.enabled=enabled;
	}
	self.clearButton.enabled=enabled;
	self.deleteButton.enabled=enabled;
	self.updateButton.enabled=enabled;
	self.editSettingsButton.enabled=enabled;
	self.previewButton.enabled=enabled;
}

- (void)viewDidAppear:(BOOL)animated
{
	NSLog(@"NewsletterViewController.viewDidAppear");
	
	[super viewDidAppear:animated];
}

- (IBAction) clearNewsletterItems
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

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
	NSLog(@"actionSheetCancel");

}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
	NSLog(@"actionSheet:willDismissWithButtonIndex %d",buttonIndex);

}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSLog(@"actionSheet:clickedButtonAtIndex %d",buttonIndex);
	
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
					
					//[self.myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
					
					
					
					[self toggleEditPage];
					
					//[self renderNewsletter];
				}
			}
		}
	}
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	NSLog(@"actionSheet:didDismissWithButtonIndex %d",buttonIndex);
	
}
- (void)renderNewsletter
{
	[newsletterTableView reloadData];
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

- (void) setCurrentNewsletter:(Newsletter*)newsletter
{
	self.newsletter=newsletter;

	// set current newsletter in app delegate so it can always remember last newsletter to show again on restart...
	AppDelegate * delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
	
	delegate.newsletter = self.newsletter;
	
	[self renderNewsletter];
}

- (IBAction) update
{
	if(!updating)
	{
		[self setButtonsEnabled:NO];
	
		updating=YES;
	
		[newsletterTableView reloadData];
	
		// update all the saved searches associated with this page...
		[self performSelectorInBackground:@selector(updateStart) withObject:nil];
	
		UINavigationController * navController=(UINavigationController*)[self parentViewController];
	
		navController.navigationBar.topItem.title=@"Updating Newsletter...";//     self.newsletter.name;
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
	
	UINavigationController * navController=(UINavigationController*)[self parentViewController];
	
	navController.navigationBar.topItem.title=self.newsletter.name;
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
		[self setButtonsEnabled:YES];
	}
	else
	{
		[self.newsletterTableView setEditing:YES animated:YES];
		self.editMoveButton.style=UIBarButtonItemStyleDone;
		self.editMoveButton.title=@"Done";
		[self setButtonsEnabled:NO];
		self.clearButton.enabled=YES;
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
		//if(indexPath.row>0)
		//{
			return YES;
		//}
		//else {
		//	return NO;
		//}

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

/*- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if(self.newsletter && self.newsletter.sections)
	{
		NewsletterSection * newsletterSection=[self.newsletter.sections objectAtIndex:section];
		return newsletterSection.name;
	}
	else {
		return nil;
	}

}*/

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	NewsletterSection * newsletterSection=[self.newsletter.sections objectAtIndex:section];

	UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, newsletterTableView.frame.size.width, 40)];
	topView.backgroundColor=[UIColor lightGrayColor];
	
	CAGradientLayer *gradient = [CAGradientLayer layer];
	gradient.frame = topView.bounds;
	gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor lightGrayColor] CGColor],(id)[[UIColor grayColor] CGColor], (id)[[UIColor lightGrayColor] CGColor], nil];
	[topView.layer insertSublayer:gradient atIndex:0];
	
	/*UIButton *collapseButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
	//[butt setImage:[UIImage imageNamed:@"icon_refresh.png"] forState:UIControlStateNormal];
	[collapseButton setFrame:CGRectMake(10, 10, 25, 25)];
	//[butt setFrame:CGRectMake(240, 0, 70, 20)];
	//[butt setTitle:@"Refresh" forState:UIControlStateNormal];
	//[butt addTarget:self action:@selector(update) forControlEvents:UIControlEventTouchUpInside];
	[topView addSubview:collapseButton];
	*/
	UILabel *nameLabel = [self newLabelWithPrimaryColor:[UIColor whiteColor] selectedColor:[UIColor whiteColor] fontSize:20 bold:YES];
	[nameLabel setFrame:CGRectMake(10, 10, 450, 22)];
	nameLabel.backgroundColor=[UIColor clearColor];
	nameLabel.text = newsletterSection.name;
	
	//tline.shadowColor = [UIColor colorWithWhite:1.0 alpha:1.0];
	[topView addSubview:nameLabel];
	
	if(updating)
	{
		UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
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
		//[butt setFrame:CGRectMake(240, 0, 70, 20)];
		//[butt setTitle:@"Refresh" forState:UIControlStateNormal];
		[refreshButton addTarget:self action:@selector(update) forControlEvents:UIControlEventTouchUpInside];
		[topView addSubview:refreshButton];
	}

	
	/*if (buttonText != nil){*/
		
	/*}*/
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

/*- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
	if(self.newsletter && self.newsletter.sections)
	{
		NSMutableArray * tmp=[[NSMutableArray alloc] init];
	
		for (int i=0; i<[self.newsletter.sections count]; i++) {
		
			[tmp addObject:[[self.newsletter.sections objectAtIndex:i] name]];
		
		}
		// TODO: do we need to retain/release/autorelease here???
		return tmp;
	}
	else {
		return nil;
	}

}*/

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
		
		if (newsletterSection==nil) {
			return 0;
		}
		else
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
	static NSString *StatusIdentifier = @"SearchResultStatusIdentifier";
	NSString * identifier;
	////if (indexPath.row==0) {
	///	identifier=StatusIdentifier;
	//}
	//else {
		identifier=CellIdentifier;
	//}

	
	
	
	UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:identifier];
	
	if(cell==nil)
	{
		//if(indexPath.row==0)
		//{
		//	cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier] autorelease];
			
			
			//cell.editingStyle=UITableViewCellEditingStyleNone;
			
		//}
		//else {
			cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier] autorelease];
		//}

		//cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
	}
	
	//int cellWidth=768;
	//int textWidth=700;
	
	// 1024x768
	// in portrait view we have full width for table (768 wide)
	// in landscape we have 1024 - 320 = 704 wide
	
	//UINavigationController * navController=(UINavigationController*)[self parentViewController];
	
	//int parentWidth=navController.view.frame.size.width;
	
	NewsletterSection * newsletterSection=[self.newsletter.sections objectAtIndex:indexPath.section];
	
	/*if(indexPath.row==0)
	{
		if(updating)
		{
			cell.textLabel.text=@"Updating...";
			cell.detailTextLabel.text=nil;
			UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
			[activityView startAnimating];
			cell.accessoryView = activityView;
			[activityView release];
			
			
			
			 
			

		}
		else
		{
			cell.textLabel.text=[NSString stringWithFormat:@"Last updated %@",[newsletterSection.lastUpdated description]];
			cell.detailTextLabel.text=[NSString stringWithFormat:@"N new items since %@",[newsletterSection.lastUpdated description]];
			cell.accessoryView=nil;
		}
	}
	else
	{*/
		SearchResult * result=(SearchResult *)[newsletterSection.items objectAtIndex:indexPath.row];

		cell.textLabel.text=[result headline];
			
		NSDateFormatter *format = [[NSDateFormatter alloc] init];
		[format setDateFormat:@"MMM d, yyyy h:mm"];

		NSString *dateString = [format stringFromDate:result.date];
		
		[format release];
		
		cell.detailTextLabel.text=[NSString stringWithFormat:@"%@ %@",dateString,[result relativeDateOffset]];
		
		
		
		//cell.detailTextLabel.text=[result synopsis];
		
		if(result.notes && [result.notes length]>0)
		{
			UIImageView* commentsImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"comment_edit.png"]];
			commentsImageView.frame = CGRectMake(0, 0, 16, 16);
			cell.accessoryView = commentsImageView;
			[commentsImageView release];
		}
		else
		{
			cell.accessoryView=nil;
		}
		
		
		if(result.image)
		{
			cell.imageView.image=result.image;
		}
		else 
		{
			cell.imageView.image=nil;
		}
	//}
	

	return cell;
}

/*- (CGFloat)tableView:(UITableView*)tableView
heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
	return 80;
	
	// get size of synopsis...
	SearchResult * result=(SearchResult *)[self.page.items objectAtIndex:indexPath.row];
	 
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
	 }
}*/

- (BOOL) tableView:(UITableView*)tableView
canMoveRowAtIndexPath:(NSIndexPath*)indexPath
{
	//if(indexPath.row>0)
	//{
		return YES;
	//}
	//else {
	//	return NO;
	//}

}

- (void)tableView:(UITableView*)tableView 
moveRowAtIndexPath:(NSIndexPath*)fromIndexPath
	  toIndexPath:(NSIndexPath*)toIndexPath
{
	NSUInteger fromRow=[fromIndexPath row];
	NSUInteger toRow=[toIndexPath row];
	
	//if(fromRow>0 && toRow>0)
	//{
	
		NewsletterSection * newsletterSection1=[self.newsletter.sections objectAtIndex:fromIndexPath.section];
		NewsletterSection * newsletterSection2=[self.newsletter.sections objectAtIndex:toIndexPath.section];
	
		id object=[[newsletterSection1.items objectAtIndex:fromRow] retain];
		[newsletterSection1.items removeObjectAtIndex:fromRow];
		[newsletterSection2.items insertObject:object atIndex:toRow];
		[object release];
	//}
}

- (void) tableView:(UITableView*)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath*)indexPath
{
	NSUInteger row=[indexPath	row];
	//if(row>0)
	//{
		NewsletterSection * newsletterSection=[self.newsletter.sections objectAtIndex:indexPath.section];
	
		[newsletterSection.items removeObjectAtIndex:row-1];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	//}
}

-(UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath {

	//if(indexPath.row==0)
	//{
	//	return UITableViewCellEditingStyleNone;
	//}
	//else {
		return 3;
	//}

	//return UITableViewCellEditingStyleDelete;
	//return 3;

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
	//if (indexPath.row==0) {
	//	return;
	//}
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

- (void)dealloc {
    [newsletterTableView release];
	[editMoveButton release];
	[editSettingsButton release];
	[updateButton release];
	[deleteButton release];
	[previewButton release];
	[clearButton release];
	[newsletter release];
	[toolBar release];
    [super dealloc];
}
@end
