    //
//  DocumentEditFormViewController.m
//  Untitled
//
//  Created by Robert Stewart on 3/15/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import "DocumentEditFormViewController.h"
#import "SearchResult.h"
#import <QuartzCore/QuartzCore.h>

@implementation DocumentEditFormViewController
@synthesize searchResult, headlineTextField,synopsisTextView,commentsTextView,delegate;

- (IBAction) cancel
{
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
}

- (IBAction) dismiss
{
	searchResult.headline=headlineTextField.text;
	searchResult.synopsis=synopsisTextView.text;
	searchResult.notes=commentsTextView.text;
	
	if(delegate)
	{
		[delegate redraw];
	}
	
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
 
	headlineTextField.text=searchResult.headline;
	synopsisTextView.text=searchResult.synopsis;
	commentsTextView.text=searchResult.notes;
	
	synopsisTextView.layer.borderWidth=1;
	synopsisTextView.layer.borderColor = [[UIColor grayColor] CGColor];
	synopsisTextView.layer.cornerRadius = 8;
	
	//commentsTextView.layer.borderWidth=1;
	//commentsTextView.layer.borderColor = [[UIColor grayColor] CGColor];
	//commentsTextView.layer.cornerRadius = 8;
	
	
	commentsTextView.backgroundColor=[UIColor clearColor];
	
	UIImage* balloon = [[UIImage imageNamed:@"balloon.png"] stretchableImageWithLeftCapWidth:15  topCapHeight:15];
	
	UIImageView * imageView=[[UIImageView alloc] initWithImage:balloon];
	//
	imageView.autoresizingMask=commentsTextView.autoresizingMask;
	
	imageView.frame=CGRectMake(commentsTextView.frame.origin.x-4, commentsTextView.frame.origin.y-8, commentsTextView.frame.size.width+16, commentsTextView.frame.size.height+16);//   commentsTextView.frame;
	
	[self.view addSubview:imageView];
	[self.view sendSubviewToBack:imageView];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
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
	[headlineTextField release];
	[synopsisTextView release];
	[commentsTextView release];
	[delegate release];
    [super dealloc];
}


@end
