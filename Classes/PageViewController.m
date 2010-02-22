    //
//  PageViewController.m
//  Untitled
//
//  Created by Robert Stewart on 2/18/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import "PageViewController.h"
#import "SearchResult.h"
#import "SearchResultCell.h"
#import "Page.h"
#import "DocumentViewController.h"

@implementation PageViewController
@synthesize pageTableView,page;

- (void)renderPage
{
	[pageTableView reloadData];
}

- (IBAction) toggleEditPage
{
	[self.pageTableView setEditing:!self.pageTableView.editing animated:YES];
}

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(self.page==nil)
	{
		return 0;
	}
	else
	{
		return [self.page.items count];
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

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[self.pageTableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"SearchResultCellIdentifier";
	
	SearchResultCell *cell = (SearchResultCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
    	NSArray * nib=[[NSBundle mainBundle] loadNibNamed:@"SearchResultCell" owner:self options:nil];
		
		cell=[nib objectAtIndex:0];
	}
	int cellWidth=768;
	int textWidth=700;
	
	// 1024x768
	// in portrait view we have full width for table (768 wide)
	// in landscape we have 1024 - 320 = 704 wide
	switch([self interfaceOrientation])
	{
		case UIInterfaceOrientationPortrait:
		case UIInterfaceOrientationPortraitUpsideDown:
			cellWidth=768;
			textWidth=700;
			break;
		case UIInterfaceOrientationLandscapeLeft:
		case UIInterfaceOrientationLandscapeRight:
			cellWidth=704;
			textWidth=640;
			break;
		default:
			break;
	}
	
	[self setWidth:cell width:cellWidth];
	[self setWidth:cell.headlineLabel width:textWidth];
	[self setWidth:cell.synopsisLabel width:textWidth];
	[self setWidth:cell.dateLabel width:textWidth];
	
	
	SearchResult * result=(SearchResult *)[self.page.items objectAtIndex:indexPath.row];
	
	cell.headlineLabel.text=[result headline];
	cell.dateLabel.text=[[result date] description];
	cell.synopsisLabel.text=[result synopsis];
	
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
	
	id object=[[self.page.items objectAtIndex:fromRow] retain];
	[self.page.items removeObjectAtIndex:fromRow];
	[self.page.items insertObject:object atIndex:toRow];
	[object release];
}

- (void) tableView:(UITableView*)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath*)indexPath
{
	NSUInteger row=[indexPath	row];
	[self.page.items removeObjectAtIndex:row];
	[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	SearchResult * result=(SearchResult *)[self.page.items objectAtIndex:indexPath.row];
	
	if(result.url && [result.url length]>0)
	{
		DocumentViewController * docViewController=[[DocumentViewController alloc] initWithNibName:@"DocumentView" bundle:nil];
	
		docViewController.searchResult=result;
	
		UINavigationController * navController=(UINavigationController*)[self parentViewController];
	
		[navController pushViewController:docViewController animated:YES];
		[docViewController release];
	}
}

- (void)dealloc {
    [pageTableView release];
	[page release];
    [super dealloc];
}
@end