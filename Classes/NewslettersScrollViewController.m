    //
//  NewslettersScrollViewController.m
//  Untitled
//
//  Created by Robert Stewart on 3/29/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import "NewslettersScrollViewController.h"
#import "Newsletter.h"
#import "NewsletterHTMLPreviewViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation NewslettersScrollViewController
@synthesize scrollView,newsletters;

#pragma mark -
#pragma mark UIView boilerplate
- (void)viewDidLoad 
{
	[self setupPage];
    [super viewDidLoad];
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

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{    
	return YES;
}


- (void)dealloc {
	//[pageControl release];
	[scrollView release];
	[newsletters release];
    [super dealloc];
}



- (UIImage*)captureView:(UIView *)view {
	//CGRect rect = [[UIScreen mainScreen] bounds];	 
	UIGraphicsBeginImageContext(view.bounds.size);	 
	CGContextRef context = UIGraphicsGetCurrentContext();	 
	[view.layer renderInContext:context];	 
	UIImage *img = UIGraphicsGetImageFromCurrentImageContext();	 
	UIGraphicsEndImageContext();	 
	return img;
}

#pragma mark -
#pragma mark The Guts
- (void)setupPage
{
	scrollView.delegate = self;
	
	[self.scrollView setBackgroundColor:[UIColor blackColor]];
	
	[scrollView setCanCancelContentTouches:NO];
	
	scrollView.showsVerticalScrollIndicator=NO;
	scrollView.showsHorizontalScrollIndicator=NO;
	scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	scrollView.clipsToBounds = YES;
	scrollView.scrollEnabled = YES;
	
	scrollView.pagingEnabled = YES;
	scrollView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	
	CGFloat cx = 0;
	int num_pages=0;
	for(Newsletter * newsletter in newsletters)
	{
		
		//NSString *imageName = [NSString stringWithFormat:@"image%d.jpg", (nimages + 1)];
		//UIImage *image = [UIImage imageNamed:imageName];
		//if (image == nil) {
		//	break;
		//}
		
		NSString   *html = [NewsletterHTMLPreviewViewController getHtml:newsletter]; 
		
		UIWebView * webView=[[UIWebView alloc] init];
		
		webView.frame=CGRectMake(0, 0, 480, 600);
		
		webView.scalesPageToFit=YES;
		
		[webView loadHTMLString:html baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
		
		[webView setNeedsDisplay];
		
		//UIImage * image=[self captureView:webView];
		
		//UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
		
		/*CGRect rect=imageView.frame;
		rect.size.height = image.size.height;
		rect.size.width = image.size.width;
		rect.origin.x = ((scrollView.frame.size.width - image.size.width) / 2) + cx;
		rect.origin.y = ((scrollView.frame.size.height - image.size.height) / 2);
		*/
		 		
		CGRect rect=webView.frame;
		rect.size.height = webView.frame.size.height;
		rect.size.width = webView.frame.size.width;
		rect.origin.x = ((scrollView.frame.size.width - webView.frame.size.width) / 2) + cx;
		rect.origin.y = 100;//((scrollView.frame.size.height - webView.frame.size.height) / 2);
		
		/*
		 
		 Create sub-view:
			have webview
			have invisible button on top of web view (open newsletter on touch)
			have drop shadow behind the web view
			have text view below web view with newsletter title
			have text view below title with last modified/updated date
		 */
		
		// need to disable vertical scrolling
		// need to adjust width on rotation
		// need to add paging control
		// need to add toolbar with "new newsletter" button
		
		// on open/create - newsletter view: with popover for settings/saved searches, and a close/home button to go back to this view...
		
		// todo: open first page in scrollview to last modified newsletter 
		
		// todo: controls under title/date for publish and delete
		
		webView.frame = rect;
		
		[scrollView addSubview:webView];
		//[imageView release];
		
		[webView release];
		
		
		cx += scrollView.frame.size.width;
		
		num_pages++;
	}
	
	//self.pageControl.numberOfPages = num_pages;
	[scrollView setContentSize:CGSizeMake(cx, [scrollView bounds].size.height)];
}

#pragma mark -
#pragma mark UIScrollViewDelegate stuff
- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
{
    if (pageControlIsChangingPage) {
        return;
    }
	
	/*
	 *	We switch page at 50% across
	 */
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    //pageControl.currentPage = page;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView 
{
    pageControlIsChangingPage = NO;
}

#pragma mark -
#pragma mark PageControl stuff
/*- (IBAction)changePage:(id)sender 
{
	
	// 	Change the scroll view
	 
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * pageControl.currentPage;
    frame.origin.y = 0;
	
    [scrollView scrollRectToVisible:frame animated:YES];
	
	//When the animated scrolling finishings, scrollViewDidEndDecelerating will turn this off
	 
    pageControlIsChangingPage = YES;
}*/


@end
