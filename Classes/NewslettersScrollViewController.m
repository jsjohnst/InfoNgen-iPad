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
	
	scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	scrollView.clipsToBounds = YES;
	scrollView.scrollEnabled = YES;
	scrollView.pagingEnabled = YES;
	
	CGFloat cx = 0;
	int num_pages=0;
	for(Newsletter * newsletter in newsletters)
	{
		
		//NSString *imageName = [NSString stringWithFormat:@"image%d.jpg", (nimages + 1)];
		//UIImage *image = [UIImage imageNamed:imageName];
		//if (image == nil) {
		//	break;
		//}
		
		NewsletterHTMLPreviewViewController * preview=[[NewsletterHTMLPreviewViewController alloc] initWithNibName:@"NewsletterHTMLPreviewView" bundle:nil];
		
		preview.newsletter=newsletter;
		
		//int width=600;
		//int height=800;
		
		//CGRect rect = CGRectMake(((scrollView.frame.size.width - width) / 2) + cx, ((scrollView.frame.size.height - height) / 2), width, height	);
		
		preview.view.frame=CGRectMake(0, 0, 600, 800);
		
		[preview renderHtml];
		
		UIImage * image=[self captureView:preview.webView];
		
		UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
		
		CGRect rect=imageView.frame;
		rect.size.height = image.size.height;
		rect.size.width = image.size.width;
		rect.origin.x = ((scrollView.frame.size.width - image.size.width) / 2) + cx;
		rect.origin.y = ((scrollView.frame.size.height - image.size.height) / 2);
		
		imageView.frame = rect;
		
		[scrollView addSubview:imageView];
		[imageView release];
		
		[preview release];
		
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
