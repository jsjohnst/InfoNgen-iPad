    //
//  PageHTMLPreviewViewController.m
//  Untitled
//
//  Created by Robert Stewart on 2/25/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import "PageHTMLPreviewViewController.h"
#import "SavedSearch.h"
#import "Page.h"

@implementation PageHTMLPreviewViewController
@synthesize page,savedSearches,webView;
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

    // enumerate section and generate HTML...
	/*NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL
																		   URLWithString:@"http://v4.infongen.com/newsletter_view.aspx?ID=1337"] 
															  cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:90.0];
	
	NSLog(@"loadRequest");
	[self.webView loadRequest: theRequest];
	NSLog(@"after loadRequest");
	NSLog(@"setNeedsDisplay");
	[self.webView setNeedsDisplay];
	NSLog(@"after setNeedsDisplay");
*/
	
	[super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
}

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
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
	[page release];
	[savedSearches release];
	[webView release];
    [super dealloc];
}


@end
