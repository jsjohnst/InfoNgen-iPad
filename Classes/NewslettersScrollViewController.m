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
#import "NewsletterScrollItemController.h"

@implementation NewslettersScrollViewController
@synthesize scrollView,newsletters,scrollItems ;

#pragma mark -
#pragma mark UIView boilerplate
- (void)viewDidLoad 
{
	
	
	scrollView.delegate = self;
	
	
	//toolBar.title=@"My Newsletters";
	
	[self.view setBackgroundColor:[UIColor viewFlipsideBackgroundColor]];
	
	[self.scrollView setBackgroundColor:[UIColor clearColor]];
	
	[scrollView setCanCancelContentTouches:NO];
	
	scrollView.showsVerticalScrollIndicator=NO;
	scrollView.showsHorizontalScrollIndicator=NO;
	scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	scrollView.clipsToBounds = YES;
	scrollView.scrollEnabled = YES;
	
	scrollView.pagingEnabled = YES;
	//scrollView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	
	NSMutableArray * array=[[NSMutableArray alloc] init];
	
	for(Newsletter * newsletter in newsletters)
	{
		for(int i=0;i<4;i++)
		{
			NewsletterScrollItemController * item=[[NewsletterScrollItemController alloc] initWithNibName:@"NewsletterScrollItemView" bundle:nil];
			
			item.newsletter=newsletter;
			
			[array addObject:item];
			[self.scrollView addSubview:item.view];
		}
	}
	
	self.scrollItems=array;
	
	[array release];
	
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated
{
	[self layoutSubviews];
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
	[scrollItems release];
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
/*- (void)setupPage
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
		for(int i=0;i<4;i++)
		{
		//NSString *imageName = [NSString stringWithFormat:@"image%d.jpg", (nimages + 1)];
		//UIImage *image = [UIImage imageNamed:imageName];
		//if (image == nil) {
		//	break;
		//}
		
		NewsletterScrollItemController * item=[[NewsletterScrollItemController alloc] initWithNibName:@"NewsletterScrollItemView" bundle:nil];
		
		item.newsletter=newsletter;
		
		int width=600;
		int height=800;
		
		item.view.frame=CGRectMake(((scrollView.frame.size.width - width) / 2) + cx,100,600, 800);
		
		 		
		// need to disable vertical scrolling
		// need to adjust width on rotation
		// need to add paging control
		// need to add toolbar with "new newsletter" button
		
		// on open/create - newsletter view: with popover for settings/saved searches, and a close/home button to go back to this view...
		
		// todo: open first page in scrollview to last modified newsletter 
		
		// todo: controls under title/date for publish and delete
		
		[scrollView addSubview:item.view];
		//[imageView release];
		
		//[item release];
		
		cx += scrollView.frame.size.width;
		
		num_pages++;
		}
	}
	
	//self.pageControl.numberOfPages = num_pages;
	
}*/

- (void)layoutSubviews
{
    NSLog(@"layoutSubviews called");
	
	NSLog(NSStringFromCGRect(self.view.bounds));
	
	CGFloat cx=0;
	
	CGFloat height=self.view.bounds.size.height - 100;
	CGFloat width=self.view.bounds.size.width - 100; //height * 0.75;
	CGFloat top=50;
	
	for(UIViewController * controller in self.scrollItems)
	{
		controller.view.frame=CGRectMake(((self.view.bounds.size.width - width) / 2)+ cx,top,width,height);
		
		[controller layoutSubviews];
		
		cx+=self.view.bounds.size.width;
	}
	
	[scrollView setContentSize:CGSizeMake(cx, self.view.bounds.size.height)];
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	NSLog(@"didRotateFromInterfaceOrientation");
    [self layoutSubviews];
	scrollView.hidden=NO;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	// hide the scroll view during rotation
	scrollView.hidden=YES;
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
