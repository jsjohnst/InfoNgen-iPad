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
#import "DocumentViewController.h"

@implementation DocumentEditViewController
@synthesize searchResult,headlineTextField,synopsisTextView;

/*
- (IBAction) cancel
{
	
}
- (IBAction) save
{
	self.searchResult.headline=headlineTextField.text;
	self.searchResult.synopsis=synopsisTextView.text;
}*/

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
	self.searchResult.synopsis=textView.text;
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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	self.headlineTextField.text=searchResult.headline;
	self.synopsisTextView.text=searchResult.synopsis;
	
	

	[super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
	[headlineTextField release];
	[synopsisTextView release];
	
    [super dealloc];
}


@end
