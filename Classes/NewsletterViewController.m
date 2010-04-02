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
#import "NewsletterAddSectionViewController.h"
#import "BlankToolbar.h"

@implementation NewsletterViewController
@synthesize newsletterTableView,editMoveButton,dateLabel,addImageButton,titleTextField,descriptionTextField,addSectionPopover,imagePickerPopover;

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	// finished changing newsletter title
	self.newsletter.name=self.titleTextField.text;
	self.title=self.newsletter.name;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
	// finished changing newsletter title
	self.newsletter.summary=self.descriptionTextField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	
	[textField resignFirstResponder];
	
	return YES;
}

- (void) actionTouch:(id)sender
{
	UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Email as HTML",@"Email as PDF",@"Preview HTML",@"Preview PDF",nil	];
	
	[actionSheet showFromBarButtonItem:sender animated:YES];
}

- (void) addTouch:(id)sender
{
	// show popup with saved searches to select from
	if(addSectionPopover==nil)
	{
		NewsletterAddSectionViewController * addSectionController=[[NewsletterAddSectionViewController alloc] initWithNibName:@"NewsletterAddSectionView" bundle:nil];
	
		addSectionController.newsletter=self.newsletter;
		addSectionController.savedSearches=[[[UIApplication sharedApplication] delegate] savedSearches];
		addSectionController.newsletterDelegate=self;
		self.addSectionPopover=[[UIPopoverController alloc] initWithContentViewController:addSectionController];
		//self.addSectionPopover.title=@"Add Sections";
		
		[addSectionController release];
	}
	
	[self.addSectionPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
	
	//UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:@"Add Section" delegate:nil cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Email as HTML",@"Email as PDF",@"Preview HTML",@"Preview PDF",nil	];
	
	//[actionSheet showFromBarButtonItem:sender animated:YES];
}

- (void)viewDidLoad
{
	
	viewMode=kViewModeSynopsis;
	
	//segmentedControl.selectedSegmentIndex=viewMode;
	
	UISegmentedControl * segmentedControl=[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Sections",@"Headlines",@"Synopsis",nil]];
	
	segmentedControl.segmentedControlStyle=UISegmentedControlStyleBar;
	segmentedControl.selectedSegmentIndex=viewMode;
	[segmentedControl addTarget:self
						 action:@selector(toggleViewMode:)
			   forControlEvents:UIControlEventValueChanged];
	self.navigationItem.titleView=segmentedControl;
	
	[segmentedControl release];
	
	// create a toolbar to have two buttons in the right
	BlankToolbar* tools = [[BlankToolbar alloc] initWithFrame:CGRectMake(0, 0, 250, 44.01)];
	
	tools.backgroundColor=[UIColor clearColor];
	tools.opaque=NO;
	
	// create the array to hold the buttons, which then gets added to the toolbar
	NSMutableArray* buttons = [[NSMutableArray alloc] init];
	
	// create a standard "action" button
	UIBarButtonItem* bi;
	
	// create a spacer to push items to the right
	bi= [[UIBarButtonItem alloc]
						   initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	[buttons addObject:bi];
	[bi release];
	
	bi = [[UIBarButtonItem alloc]
		  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTouch:)];
	bi.style = UIBarButtonItemStylePlain;
	[buttons addObject:bi];
	[bi release];
	
	// create a spacer
	bi = [[UIBarButtonItem alloc]
		  initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	bi.width=30;
	
	[buttons addObject:bi];
	[bi release];
	
	
	bi = [[UIBarButtonItem alloc]
		  initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionTouch:)];
	bi.style = UIBarButtonItemStylePlain;
	[buttons addObject:bi];
	[bi release];
	
	// create a spacer
	bi = [[UIBarButtonItem alloc]
		  initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	bi.width=30;
	
	[buttons addObject:bi];
	[bi release];
	 
	
	// create a standard "refresh" button
	bi = [[UIBarButtonItem alloc]
		  initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(update)];
	bi.style = UIBarButtonItemStylePlain;
	[buttons addObject:bi];
	[bi release];
	
	// create a spacer
	bi = [[UIBarButtonItem alloc]
		  initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	bi.width=30;
	[buttons addObject:bi];
	[bi release];
	
	// create a standard "edit" button
	bi = [[UIBarButtonItem alloc] init];
	bi.title=@"Edit";
	bi.target=self;
	bi.action=@selector(toggleEditPage:) ;
	
		  //initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(toggleEditPage:)];
	bi.style = UIBarButtonItemStyleBordered;
	[buttons addObject:bi];
	[bi release];

	// stick the buttons in the toolbar
	[tools setItems:buttons animated:NO];
	
	[buttons release];
	
	// and put the toolbar in the nav bar
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:tools];
	
	[tools release];
}

-(void) toggleViewMode:(id)sender
{
	//
	
	viewMode=[sender selectedSegmentIndex];
	
	[newsletterTableView reloadData];
	
}

- (void)viewWillAppear:(BOOL)animated
{
	if(self.newsletter)
	{
		if(self.newsletter.logoImage)
		{
			CGRect newFrame=CGRectMake(self.addImageButton.frame.origin.x,self.addImageButton.frame.origin.y,self.newsletter.logoImage.size.width,self.newsletter.logoImage.size.height);
		
			[self.addImageButton removeFromSuperview];
		
			//[self.addImageButton release];
		
			self.addImageButton=[UIButton buttonWithType:UIButtonTypeCustom];
		
			self.addImageButton.frame=newFrame;
		
			[self.addImageButton setBackgroundImage:self.newsletter.logoImage forState:UIControlStateNormal];
		
			[self.addImageButton addTarget:self action:@selector(imageTouched:) forControlEvents:UIControlEventTouchUpInside];
		
			[self.view addSubview:self.addImageButton];		
		}
		
		//self.title=self.newsletter.name;
		self.titleTextField.text=self.newsletter.name;
		self.descriptionTextField.text=self.newsletter.summary;
	
		NSDateFormatter *format = [[NSDateFormatter alloc] init];
		
		[format setDateFormat:@"MMM d, yyyy"];
		
		self.dateLabel.text=[format stringFromDate:newsletter.lastUpdated]; 
		
		[format release];
	}
	
	[newsletterTableView reloadData];

	[super viewWillAppear:animated];
}

-(void) setButtonsEnabled:(BOOL)enabled
{
		
}

- (void)viewDidAppear:(BOOL)animated
{
	
	[super viewDidAppear:animated];
	
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{

}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	
	if(actionSheet.tag==kEditLogoImageActionSheet)
	{
		if(buttonIndex==0)
		{
			// choose existing image
			[self addImageTouch:self.addImageButton];
		}
		
		if(buttonIndex==1)
		{
			// delete image
			self.newsletter.logoImage=nil;
	
			CGRect newFrame=CGRectMake(self.addImageButton.frame.origin.x, self.addImageButton.frame.origin.y, 88, 88);
			// replace old button...
			[self.addImageButton removeFromSuperview];
			
			self.addImageButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
			
			//self.addImageButton.title=@"Add Image";
			[self.addImageButton setTitle:@"Add Image" forState:UIControlStateNormal];
			
			self.addImageButton.frame=newFrame;
			[self.addImageButton addTarget:self action:@selector(addImageTouch:) forControlEvents:UIControlEventTouchUpInside];
			
			[self.view addSubview:self.addImageButton];
		}
	}
	
	/*if(buttonIndex==0)
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
	}*/
}

- (void) deleteSelectedRows
{
	NSArray* selectedRows = [newsletterTableView indexPathsForSelectedRows];
		
	if (selectedRows && [selectedRows count]>0) 
	{
		if(viewMode==kViewModeSections)
		{
			// delete sections
			NSMutableIndexSet * sectionsSet=[[NSMutableIndexSet alloc] init];
			
			for (NSIndexPath * indexPath in selectedRows)
			{
				[sectionsSet addIndex:indexPath.row];
			}
			
			[self.newsletter.sections removeObjectsAtIndexes:sectionsSet];
			
			[sectionsSet release];
		}
		else
		{
			// delete items
			NSMutableDictionary * dict=[[NSMutableDictionary alloc] init];
			
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
		
			for(NSArray * array in [dict allValues])
			{
				NewsletterSection * section=[array objectAtIndex:0];
				NSMutableIndexSet * rows=[array objectAtIndex:1];
				
				[section.items removeObjectsAtIndexes:rows];
			}
			
			[dict release];
		}
			
		[self.newsletterTableView deleteRowsAtIndexPaths:selectedRows withRowAnimation:UITableViewRowAnimationFade];
	}
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	
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

- (IBAction) update
{
	if(!updating)
	{
		[self setButtonsEnabled:NO];
	
		updating=YES;
	
		[newsletterTableView reloadData];
	
		// update all the saved searches associated with this page...
		[self performSelectorInBackground:@selector(updateStart) withObject:nil];
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
}

-(void) setViewMode:(int)mode
{
	viewMode=mode;
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
	
	if(viewMode==kViewModeSections)
	{
		return 1;
	}
	else
	{
		if(self.newsletter && self.newsletter.sections)
		{
			return [self.newsletter.sections count];
		}
		else
		{
			return 0;
		}
	}
}	

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	if(viewMode==kViewModeSections)
	{
		return nil;
	}
	
	NewsletterSection * newsletterSection=[self.newsletter.sections objectAtIndex:section];

	UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, newsletterTableView.frame.size.width, 40)];
	
	topView.backgroundColor=[UIColor whiteColor];
		
	UIColor * borderColor=[NewsletterItemContentView colorWithHexString:@"#336699"];
	
	topView.layer.borderColor=[borderColor CGColor];
	topView.layer.borderWidth=1;
	
	//CAGradientLayer *gradient = [CAGradientLayer layer];
	//gradient.frame = topView.bounds;
	//gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor lightGrayColor] CGColor],(id)[[UIColor grayColor] CGColor], (id)[[UIColor lightGrayColor] CGColor], nil];
	//[topView.layer insertSublayer:gradient atIndex:0];
	
	UIColor * nameColor=[NewsletterItemContentView colorWithHexString:@"#339933"];
	
	
	UILabel *nameLabel = [self newLabelWithPrimaryColor:nameColor selectedColor:nameColor fontSize:20 bold:YES];
	[nameLabel setFrame:CGRectMake(10, 10, 450, 22)];
	//nameLabel.backgroundColor=[UIColor clearColor];
	nameLabel.text = newsletterSection.name;
	
	[topView addSubview:nameLabel];
	
	/*if(updating)
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
	}*/

	return topView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	if(viewMode==kViewModeSections)
	{
		return 0;
	}
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
    if(self.newsletter==nil || self.newsletter.sections==nil)
	{
		return 0;
	}
	else
	{
		if(viewMode==kViewModeSections)
		{
			return [self.newsletter.sections count];
		}
		
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
	
	if(viewMode==kViewModeSections)
	{
		static NSString *SectionCellIdentifier = @"SectionCellIdentifier";
		
		UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:SectionCellIdentifier];
		
		if(cell==nil)
		{
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:SectionCellIdentifier] autorelease];
			
			//cell.selectionStyle=UITableViewCellSelectionStyleNone;
		
		}
		
		//if(!tableView.editing)
		//{
		//	cell.selectionStyle=UITableViewCellSelectionStyleNone;
		//}
		
		NewsletterSection * newsletterSection=[self.newsletter.sections objectAtIndex:indexPath.row];
		
		cell.textLabel.text=newsletterSection.name;
		
		return cell;
	}
	else 
	{
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
		
		
		[contentView setViewMode:(viewMode==kViewModeSynopsis)];
		//[contentView setViewMode:([self.viewModeSegmentedControl selectedSegmentIndex]==1)];
		contentView.searchResult=result;
		[contentView setNeedsDisplay];
			
		return cell;
	}
}

- (BOOL) tableView:(UITableView*)tableView
canMoveRowAtIndexPath:(NSIndexPath*)indexPath
{
	
	return YES;
}

- (CGFloat)tableView:(UITableView*)tableView
heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
	if(viewMode==kViewModeSections)
	{
		return 44;
	}
	else 
	{
		
		NewsletterSection * newsletterSection=[self.newsletter.sections objectAtIndex:indexPath.section];

		SearchResult * result=(SearchResult *)[newsletterSection.items objectAtIndex:indexPath.row];
		
		//ItemSize itemSize=[NewsletterItemContentView sizeForCell:result viewMode:([self.viewModeSegmentedControl selectedSegmentIndex]==1) rect:CGRectZero];
		ItemSize itemSize=[NewsletterItemContentView sizeForCell:result viewMode:(viewMode==kViewModeSynopsis) rect:CGRectZero];
		
		return itemSize.size.height;
	}
}

- (void)tableView:(UITableView*)tableView 
moveRowAtIndexPath:(NSIndexPath*)fromIndexPath
	  toIndexPath:(NSIndexPath*)toIndexPath
{
		
	NSUInteger fromRow=[fromIndexPath row];
	NSUInteger toRow=[toIndexPath row];
	
	if(viewMode==kViewModeSections)
	{
		NewsletterSection * newsletterSection1=[[self.newsletter.sections objectAtIndex:fromRow] retain];
		//NewsletterSection * newsletterSection2=[self.newsletter.sections objectAtIndex:toRow];
		
		[self.newsletter.sections removeObjectAtIndex:fromRow];
		[self.newsletter.sections insertObject:newsletterSection1 atIndex:toRow];
		[newsletterSection1 release];
		
	}
	else
	{
		NewsletterSection * newsletterSection1=[self.newsletter.sections objectAtIndex:fromIndexPath.section];
		NewsletterSection * newsletterSection2=[self.newsletter.sections objectAtIndex:toIndexPath.section];
		
		id object=[[newsletterSection1.items objectAtIndex:fromRow] retain];
		[newsletterSection1.items removeObjectAtIndex:fromRow];
		[newsletterSection2.items insertObject:object atIndex:toRow];
		[object release];
	}
}

- (void) tableView:(UITableView*)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath*)indexPath
{
	if(viewMode==kViewModeSections)
	{
		[self.newsletter.sections removeObjectAtIndex:indexPath.row];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		
	}
	else 
	{
		NSUInteger row=[indexPath	row];
		NewsletterSection * newsletterSection=[self.newsletter.sections objectAtIndex:indexPath.section];

		[newsletterSection.items removeObjectAtIndex:row];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
}

-(UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath {

	return 3;
	//return UITableViewCellEditingStyleDelete;
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if( sourceIndexPath.section != proposedDestinationIndexPath.section )
    {
        return sourceIndexPath;
    }
    else
    {
        return proposedDestinationIndexPath;
    }
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
	
	NSIndexPath * indexPath=[NSIndexPath indexPathForRow:NSNotFound inSection:section_number];
	
	[self.newsletterTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
	
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

- (void)imageTouched:(id)sender
{
	UIView * button=(UIView*)sender;
	
	UIActionSheet * actionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
	actionSheet.tag=kEditLogoImageActionSheet;
	[actionSheet addButtonWithTitle:@"Choose Existing Image"];
	[actionSheet addButtonWithTitle:@"Delete Image"];
	[actionSheet showFromRect:button.frame inView:self.view animated:YES];
	
	//[actionSheet showInView:self.view];
	
	[actionSheet release];
}

- (void) addImageTouch:(id)sender
{
	UIImagePickerController * picker=[[UIImagePickerController alloc] init];
	
	picker.allowsEditing = YES;
	
	picker.delegate=self;
	
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
	{
		picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	}
	else
	{
		if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
		{
			picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
			
		}
		else
		{
			if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
			{
				picker.sourceType = UIImagePickerControllerSourceTypeCamera;
			}
			else 
			{
				return;
			}
		}
	}
	
	UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:picker];
	
	self.imagePickerPopover=popover;
	
	UIView * button=(UIView*)sender;
	
	[popover presentPopoverFromRect:[button convertRect:button.frame toView:self.view] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	
	[picker release];
	
	[popover release];
}
 

- (void)imagePickerController:(UIImagePickerController *)picker 
		didFinishPickingImage:(UIImage *)image
				  editingInfo:(NSDictionary *)editingInfo
{
	
    // Dismiss the image selection, hide the picker and
    //show the image view with the picked image
    [imagePickerPopover dismissPopoverAnimated:YES];
	
	
	//222 px x 118px
	
	if(image.size.width>222  || image.size.height>118)
	{
		CGSize newSize;
		// resize
		if(image.size.width>image.size.height)
		{
			CGFloat ratio=222.0/image.size.width;
			CGFloat newWidth=ratio * image.size.width;
			CGFloat newHeight=ratio * image.size.height;
			newSize.width=newWidth;
			newSize.height=newHeight;
		}
		else
		{
			CGFloat ratio=118.0/image.size.height;
			CGFloat newWidth=ratio * image.size.width;
			CGFloat newHeight=ratio * image.size.height;
			newSize.width=newWidth;
			newSize.height=newHeight;
		}
		
		UIGraphicsBeginImageContext( newSize );// a CGSize that has the size you want
		[image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
		//image is the original UIImage
		image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
	}

	self.newsletter.logoImage=image;
	
	CGRect newFrame=CGRectMake(self.addImageButton.frame.origin.x,self.addImageButton.frame.origin.y,image.size.width,image.size.height);
	
	[self.addImageButton removeFromSuperview];
	
	//[self.addImageButton release];
	
	self.addImageButton=[UIButton buttonWithType:UIButtonTypeCustom];
	
	self.addImageButton.frame=newFrame;
	
	[self.addImageButton setBackgroundImage:image forState:UIControlStateNormal];

	[self.addImageButton addTarget:self action:@selector(imageTouched:) forControlEvents:UIControlEventTouchUpInside];
						 
	[self.view addSubview:self.addImageButton];					 
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    // Dismiss the image selection and close the program
    [imagePickerPopover dismissPopoverAnimated:YES];
}

- (void)dealloc 
{
    [newsletterTableView release];
	[editMoveButton release];
	[addImageButton release];
	//[segmentedControl release];
	[titleTextField  release];
	[descriptionTextField release];
	[addSectionPopover release];
	[imagePickerPopover release];
	[dateLabel release];
	[super dealloc];
}
@end
