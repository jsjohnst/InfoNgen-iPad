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

- (void)viewDidAppear:(BOOL)animated
{
	NSLog(@"NewsletterViewController.viewDidAppear");
	
	//[self renderNewsletter];
	
	[super viewDidAppear:animated];
}

- (IBAction) clearNewsletterItems
{
	UIActionSheet * actionSheet=[[UIActionSheet alloc] initWithTitle:@"Remove All Newsletter Items" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Remove All Items" otherButtonTitles:nil];
	
	actionSheet.tag=kClearItemsActionSheet;
	
	[actionSheet showFromToolbar:self.toolBar];
	
	[actionSheet release];
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
			
			self.editSettingsButton.enabled=NO;
			self.editMoveButton.enabled=NO;
			self.updateButton.enabled=NO;
			self.previewButton.enabled=NO;
			self.deleteButton.enabled=NO;
			
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
		}
	}
	
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	NSLog(@"actionSheet:didDismissWithButtonIndex %d",buttonIndex);
	
}
- (void)renderNewsletter
{
	
	/*if(self.newsletter)
	{
		NSLog(@"Enabling buttons...");
		self.editSettingsButton.enabled=YES;
		self.editMoveButton.enabled=YES;
		self.updateButton.enabled=YES;
		self.previewButton.enabled=YES;
	}*/
	
	
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
	// update all the saved searches associated with this page...
	[self performSelectorInBackground:@selector(updateStart) withObject:nil];
	self.updateButton.enabled=NO;
	self.editMoveButton.enabled=NO;
	self.previewButton.enabled=NO;
	self.editSettingsButton.enabled=NO;
	self.deleteButton.enabled=NO;
	self.clearButton.enabled=NO;
	
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
	self.deleteButton.enabled=YES;
	self.clearButton.enabled=YES;
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
	
	if(self.newsletter)
	{
		self.editSettingsButton.enabled=YES;
		self.editMoveButton.enabled=YES;
		self.updateButton.enabled=YES;
		self.previewButton.enabled=YES;
		self.deleteButton.enabled=YES;
		self.clearButton.enabled=YES;
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if(self.newsletter && self.newsletter.sections)
	{
		NewsletterSection * newsletterSection=[self.newsletter.sections objectAtIndex:section];
		return newsletterSection.name;
	}
	else {
		return nil;
	}

}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
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
	
	UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if(cell==nil)
	{
		cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
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
	[deleteButton release];
	[previewButton release];
	[clearButton release];
	[newsletter release];
	[toolBar release];
    [super dealloc];
}
@end
