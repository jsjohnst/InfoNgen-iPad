    //
//  DocumentEditViewController.m
//  Untitled
//
//  Created by Robert Stewart on 2/22/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import "DocumentEditViewController.h"
#import "SearchResult.h"
#import "DocumentTextViewController.h"
#import "DocumentWebViewController.h"
#import "TextFieldTableCell.h"
#import "TextViewTableCell.h"

@implementation DocumentEditViewController
@synthesize searchResult,editTable;

- (IBAction) getUrl
{
	if(self.searchResult.url && [self.searchResult.url length]>0)
	{
		DocumentViewController * docViewController=[[DocumentViewController alloc] initWithNibName:@"DocumentView" bundle:nil];
		
		docViewController.searchResult=self.searchResult;
		
		UINavigationController * navController=(UINavigationController*)[self parentViewController];
		
		[navController pushViewController:docViewController animated:YES];
		[docViewController release];
	}
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	self.searchResult.headline=textField.text;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
	if(textView.tag==kCommentsSection)
	{
		self.searchResult.notes=textView.text;
	}
	if(textView.tag==kSynopsisSection)
	{
		self.searchResult.synopsis=textView.text;
	}
}

/*- (IBAction) getText
{
	// get javascript file from bundle...
	
	NSString * path=[[NSBundle mainBundle] pathForResource:@"readability" ofType:@"js"];
	
	if (path) {
		NSString *javascript = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
		
		if(javascript)
		{
			// insert javascript functions into the document
			[self getString:javascript];
			
			NSString * text=[self getString:@"readability.extractArticleText()"];
			
			text=[self flattenHTML:text];
			
			NSLog(text);
			
			// render extracted text in scrollable text view and allow user to select portions of the text for the synopsis
			
			DocumentTextViewController * textController=[[DocumentTextViewController alloc] initWithNibName:@"DocumentTextView" bundle:nil];
			
			textController.searchResult=self.searchResult;
			textController.text=text;
			
			UINavigationController * navController=(UINavigationController*)[self parentViewController];
			
			[navController pushViewController:textController animated:YES];
			[textController release];
		}
	}
}*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
	NSLog(@"documentEditViewController.viewWillAppear");

	//self.imageView.image=searchResult.image;
	//self.synopsisTextView.text=searchResult.synopsis;
	NSLog(@"calling reloaddata");
	[self.editTable reloadData];
	
	[super viewWillAppear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	NSLog(@"numberOfSectionsInTableView");
	return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell;
    
	NSLog(@"cellForRowAtIndexPath");
	
	switch(indexPath.section)
	{
		case kHeadlineSection:
		{
			TextFieldTableCell * textFormCell=[[[TextFieldTableCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:nil] autorelease];
			textFormCell.textField.text=self.searchResult.headline;
			textFormCell.textField.delegate=self;
			cell=textFormCell;
		}
		break;
		case kUrlSection:
		{
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:nil] autorelease];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			cell.textLabel.text = self.searchResult.url;
		}
		break;
		case kSynopsisSection:	
		{
			TextViewTableCell * textViewCell=[[[TextViewTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
			
			textViewCell.textView.text=self.searchResult.synopsis;
			textViewCell.textView.tag=kSynopsisSection;
			textViewCell.textView.delegate=self;
			
			cell=textViewCell;
		}
			break;
		case kCommentsSection:
		{
			TextViewTableCell * textViewCell=[[[TextViewTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
			
			textViewCell.textView.text=self.searchResult.notes;
			textViewCell.textView.tag=kCommentsSection;
			textViewCell.textView.delegate=self;
			
			cell=textViewCell;
		}
			break;
		case kImageSection:
		{
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:nil] autorelease];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			cell.imageView.image=self.searchResult.image;
		}
			break;
	}
		 
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSLog(@"numberOfRowsInSection");
	
	return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	switch (section) 
	{
		case kHeadlineSection:
			return @"Headline";
		case kUrlSection:
			return @"Link";
		case kSynopsisSection:
			return @"Synopsis";
		case kCommentsSection:
			return @"Comments";
		case kImageSection:
			return @"Image";
	}
	return nil;
}

- (CGFloat)tableView:(UITableView*)tableView
heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
	switch(indexPath.section)
	{
		case kSynopsisSection:
			return 220.0;
		case kCommentsSection:
			return 220.0;
		case kImageSection:
			if(self.searchResult.image)
			{
				return self.searchResult.image.size.height + 20.0;
			}
	}
	return 40.0;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if(indexPath.section==kUrlSection && indexPath.row==kUrlRow)
	{
		// open page
		[self getUrl];
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
	[searchResult release];
		[editTable release];
    [super dealloc];
}


@end
