    //
//  DocumentViewController.m
//  Untitled
//
//  Created by Robert Stewart on 2/18/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import "DocumentViewController.h"
#import "SearchResult.h"

@implementation DocumentViewController
@synthesize webView,searchResult,backButton,forwardButton,stopButton,reloadButton;

-(NSString*) getString:(NSString*)javascript
{
	return [self.webView stringByEvaluatingJavaScriptFromString:javascript];
}

-(NSInteger) getInt:(NSString*)javascript
{
	NSString * s=[self getString:javascript];
	if(s && [s length]>0)
	{
		return [s intValue];
	}
	else {
		return 0;
	}

}

-(IBAction) getImages
{
	//NSString * javascript=@"function(){var imgSources='test';for(var i=0;i<document.images.length;i++){imgSources+=document.images[i].src+';';}return imgSources;}();";
	
	
	// get # of images on page
	
	NSInteger num_images=[self getInt:@"document.images.length"];
	
	NSMutableArray *images=[[NSMutableArray alloc] init];
	
	for(int i=0;i<num_images;i++)
	{
		NSString * src=[self getString:[NSString stringWithFormat:@"document.images[%d].src",i]];
		NSInteger width=[self getInt:[NSString stringWithFormat:@"document.images[%d].width",i]];
		NSInteger height=[self getInt:[NSString stringWithFormat:@"document.images[%d].height",i]];
		
		if(width>1 && height>1)
		{
			[images addObject:src];
		}
	}
	
	// TODO: sort by size and present user with largest images to choose from (calculate area)
	// TODO: filter out images that are not "squarish" in size
	// TODO: filter out images that look like ads...
	
	[images release];
	
	
}

- (void)viewDidLoad {
	
	if(self.searchResult)
	{
		if(self.searchResult.url && [self.searchResult.url length]>0)
		{
			NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL
																	URLWithString:self.searchResult.url] 
																	  cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:90.0];
	
			NSLog(@"loadRequest");
			[self.webView loadRequest: theRequest];
			NSLog(@"after loadRequest");
			NSLog(@"setNeedsDisplay");
			[self.webView setNeedsDisplay];
			NSLog(@"after setNeedsDisplay");
		}
	}
	
	[super viewDidLoad];
}

//Sent if a web view failed to load content.
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	NSLog(@"didFailLoadWithError");
	self.stopButton.enabled=NO;
	self.reloadButton.enabled=YES;
	UINavigationController * navController=(UINavigationController*)[self parentViewController];
	if(navController)
	{
		navController.navigationBar.topItem.title=nil;
		navController.navigationBar.topItem.rightBarButtonItem=nil;
	}
}

//Sent before a web view begins loading content.
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	NSLog(@"shouldStartLoadWithRequest");
	return YES;
}

//Sent after a web view finishes loading content.
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	NSLog(@"webViewDidFinishLoad");
	self.stopButton.enabled=NO;
	self.reloadButton.enabled=YES;
	self.backButton.enabled=self.webView.canGoBack;
	self.forwardButton.enabled=self.webView.canGoForward;
	UINavigationController * navController=(UINavigationController*)[self parentViewController];
	if(navController)
	{
		navController.navigationBar.topItem.title=nil;
		navController.navigationBar.topItem.rightBarButtonItem=nil;
	}
}





//Sent after a web view starts loading content.
- (void)webViewDidStartLoad:(UIWebView *)webView
{
	NSLog(@"webViewDidStartLoad");
	self.stopButton.enabled=YES;
	self.reloadButton.enabled=YES;
	
	UINavigationController * navController=(UINavigationController*)[self parentViewController];
	if(navController)
	{
		navController.navigationBar.topItem.title=@"Loading...";
		
		UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
		activityIndicator.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
		[activityIndicator startAnimating];
		UIBarButtonItem *activityItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
		[activityIndicator release];
		navController.navigationBar.topItem.rightBarButtonItem = activityItem;
		[activityItem release];
	
	}
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
	webView.delegate=nil;
	[webView release];
	[searchResult release];
	[backButton release];
	[forwardButton release];
	[stopButton release];
	[reloadButton release];
    [super dealloc];
}


@end
