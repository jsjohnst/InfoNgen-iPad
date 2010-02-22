    //
//  DocumentViewController.m
//  Untitled
//
//  Created by Robert Stewart on 2/18/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import "DocumentViewController.h"
#import "SearchResult.h"
#import "DocumentImage.h"
#import "ImagePickerViewController.h"
#import "DocumentTextViewController.h"
#import "DocumentEditViewController.h"

@implementation DocumentViewController
@synthesize webView,searchResult,backButton,forwardButton,stopButton,reloadButton;

-(NSString*) getString:(NSString*)javascript
{
	if(javascript && [javascript length]>0)
	{
		return [self.webView stringByEvaluatingJavaScriptFromString:javascript];
	}
	else
	{
		return nil;
	}
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


- (NSString *)flattenHTML:(NSString *)html {
	
    NSScanner *theScanner;
    NSString *text = nil;
	
	// relplace <p> with line break
	// replace <br> with line break
	// replace &nbsp; with space
	// replace &amp; with &
	// replace other encodings as they come up...
	
	
    theScanner = [NSScanner scannerWithString:html];
	
    while ([theScanner isAtEnd] == NO) {
		
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ; 
		
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
		
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:
				[ NSString stringWithFormat:@"%@>", text]
											   withString:@""];
		
    } // while //
    
    return html;
	
}

- (IBAction) getText
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
			
			// render extracted text in scrollable text view and allow user to select portions of the text for the synopsis

			DocumentTextViewController * textController=[[DocumentTextViewController alloc] initWithNibName:@"DocumentTextView" bundle:nil];
	
			textController.searchResult=self.searchResult;
			textController.text=text;
	
			UINavigationController * navController=(UINavigationController*)[self parentViewController];
			
			[navController pushViewController:textController animated:YES];
			[textController release];
		}
	}
}

-(IBAction) edit
{
	DocumentEditViewController * editController=[[DocumentEditViewController alloc] initWithNibName:@"DocumentEditView" bundle:nil];
	
	editController.searchResult=self.searchResult;
	
	
	UINavigationController * navController=(UINavigationController*)[self parentViewController];
	
	[navController pushViewController:editController animated:YES];
	[editController release];
}

-(IBAction) getImages
{
	// get # of images on page
	
	NSInteger num_images=[self getInt:@"document.images.length"];
	
	NSMutableArray *images=[[NSMutableArray alloc] init];
	
	for(int i=0;i<num_images;i++)
	{
		NSString * src=[self getString:[NSString stringWithFormat:@"document.images[%d].src",i]];
		// TODO:handle relative URLs here...
		
		NSInteger width=[self getInt:[NSString stringWithFormat:@"document.images[%d].width",i]];
		NSInteger height=[self getInt:[NSString stringWithFormat:@"document.images[%d].height",i]];
		
		// ignore small images
		if(width>16 && height>16)
		{
			DocumentImage * image=[[DocumentImage alloc] init];
			
			image.width=width;
			image.height=height;
			image.area=width * height;
			image.src=src;
			
			[images addObject:image];
			
			[image release];
		}
	}
	
	// TODO: sort by size and present user with largest images to choose from (calculate area)
	NSSortDescriptor *areaSorter = [[NSSortDescriptor alloc] initWithKey:@"area" ascending:NO];
	
	[images sortUsingDescriptors:[NSArray arrayWithObject:areaSorter]];
	
	if([images count]>10)
	{
		[images removeObjectsInRange:NSMakeRange(10, [images count]-10)];
	}
	
	DocumentImage * img;
	
	ImagePickerViewController * imgViewController=[[ImagePickerViewController alloc] initWithNibName:@"ImagePickerView" bundle:nil];
	
	NSMutableArray * array=[[NSMutableArray alloc] init];
	
	for(img in images)
	{
		UIImage * m=[img getImage];
		if(m)
		{
			img.image=m;
			
			[array addObject:img];
			
			[m release];
		}
	}
	
	imgViewController.images=array;
	
	[array release];
	
	[self.view addSubview:imgViewController.view];
	
	//[imgViewController release];
	
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
