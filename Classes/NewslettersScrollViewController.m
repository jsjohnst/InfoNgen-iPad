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
@synthesize scrollView,newsletters,scrollItems,deleteButton,sendButton,dateLabel,titleLabel,pageControl,toolBar ;

-(IBAction) deleteTouch:(id)sender
{
	UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete Newsletter" otherButtonTitles:nil	];
	
	actionSheet.tag=kDeleteNewsletterActionSheet;
	
	[actionSheet showFromBarButtonItem:sender animated:YES];
}

-(IBAction) sendTouch:(id)sender
{
	UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Publish Newsletter",@"Show Preview",nil	];
	actionSheet.tag=kPublishNewsletterActionSheet;
	[actionSheet showFromBarButtonItem:sender animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
}

- (void) removeCurrentPage
{
	NewsletterScrollItemController * controller = [self.scrollItems objectAtIndex:self.pageControl.currentPage];
	
	// remove newsletter from newsletters
	[self.newsletters removeObjectAtIndex:self.pageControl.currentPage];
	
	// remove view from scroll view
	[controller.view removeFromSuperview];
	
	// remove scroll item from array
	[self.scrollItems removeObjectAtIndex:self.pageControl.currentPage];
	
	// if we are on the last page, then scroll left to previous page
	//if (self.pageControl.currentPage>0 && self.pageControl.currentPage==self.pageControl.numberOfPages-1)
	//{
	//	sel f.pageControl.currentPage=self.pageControl.currentPage-1;
	//	[self scrollToPage:self.pageControl.currentPage];
	//}
	
	self.pageControl.numberOfPages=self.pageControl.numberOfPages-1;
	
	[self displayCurrentPageInfo];
	 
	// re-adjust view
	[self layoutSubviews];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(actionSheet.tag==kDeleteNewsletterActionSheet)
	{
		[self removeCurrentPage];
		
		//[self.newsletters removeObject:self.currentNewsletter];
		
		//self.currentNewsletter=nil;
		
		// remove item with animation?
		// redraw...
		
		//[UIView beginAnimations:nil context:nil];
		//[UIView setAnimationDuration:0.75];
		//[UIView setAnimationDelegate:self];
		
		//actionSheet.
		
		//[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:myview cache:YES];
		//[myview removeFromSuperview];
		//[UIView commitAnimations];
	}
	if(actionSheet.tag==kPublishNewsletterActionSheet)
	{
		if(buttonIndex==0)
		{
			// email
			// popup email form and populate with HTML
		}
		if(buttonIndex==1)
		{
			// preview HTML
		}
	}
}


- (void)viewDidLoad 
{
	scrollView.delegate = self;
	
	UIBarButtonItem * leftButton=[[UIBarButtonItem alloc] init];
	
	leftButton.style=UIBarButtonItemStyleBordered;
	
	leftButton.title=@"My Newsletters";
	
	self.navigationItem.backBarButtonItem=leftButton;
	
	self.toolBar.backgroundColor=[UIColor clearColor];
	self.toolBar.opaque=NO;
	
	[self.view setBackgroundColor:[UIColor viewFlipsideBackgroundColor]];
	
	[self.scrollView setBackgroundColor:[UIColor clearColor]];
	
	self.title=@"My Newsletters";
	//self.navigationController.navigationBar.topItem.title=@"My Newsletters";

	[scrollView setCanCancelContentTouches:NO];
	
	scrollView.showsVerticalScrollIndicator=NO;
	scrollView.showsHorizontalScrollIndicator=NO;
	scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	scrollView.clipsToBounds = YES;
	scrollView.scrollEnabled = YES;	
	scrollView.pagingEnabled = YES;
	
	self.scrollItems=[[NSMutableArray alloc] init];
	
	for(Newsletter * n in newsletters)
	{
		[self addNewsletterPage:n];
	}
 	
    [super viewDidLoad];
}

- (void) addNewsletterPage:(Newsletter*)_newsletter
{
	NewsletterScrollItemController * item=[[NewsletterScrollItemController alloc] initWithNibName:@"NewsletterScrollItemView" bundle:nil];
	
	item.newsletter=_newsletter;
	
	[self.scrollItems addObject:item];
	
	[self.scrollView addSubview:item.view];
	
	self.pageControl.numberOfPages=[self.scrollItems count];
}

- (void) viewWillAppear:(BOOL)animated
{
	NSLog(@"viewWillAppear");
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
	[scrollView release];
	[newsletters release];
	[scrollItems release];
	[deleteButton release];
	[sendButton release];
	[dateLabel release];
	[titleLabel release];
	[pageControl release];
	[toolBar release];
	[super dealloc];
}
/*
- (UIImage*)captureView:(UIView *)view {
	//CGRect rect = [[UIScreen mainScreen] bounds];	 
	UIGraphicsBeginImageContext(view.bounds.size);	 
	CGContextRef context = UIGraphicsGetCurrentContext();	 
	[view.layer renderInContext:context];	 
	UIImage *img = UIGraphicsGetImageFromCurrentImageContext();	 
	UIGraphicsEndImageContext();	 
	return img;
}
*/
- (void)layoutSubviews
{
    CGRect bounds=self.scrollView.bounds;
	
	CGFloat cx=0;
	
	CGFloat footer=100;
	CGFloat height=bounds.size.height - footer;
	CGFloat width=bounds.size.width - 100;
	CGFloat top=50;
	
	for(int page=0;page<[self.scrollItems count];page++)
	{	
		NewsletterScrollItemController * controller = [self.scrollItems objectAtIndex:page];
		
		controller.view.frame=CGRectMake(((bounds.size.width - width) / 2)+ cx,top,width,height);
		
		[controller layoutSubviews];
		
		if(page==self.pageControl.currentPage)
		{
			[controller renderNewsletter];
		}
		
		cx+=bounds.size.width;
	}

	[scrollView setContentSize:CGSizeMake(cx, bounds.size.height)];
	
	[self displayCurrentPageInfo];
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	[self layoutSubviews];
	if(self.pageControl.numberOfPages>1)
	{
		[self scrollToPage:self.pageControl.currentPage];
	}
	scrollView.hidden=NO;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	// hide the scroll view during rotation
	scrollView.hidden=YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
{
    if (pageControlIsChangingPage) 
	{
        return;
    }
	
	// switch page at 50% across
	
    CGFloat pageWidth = self.view.bounds.size.width;//-100;
    
	int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	
	pageControl.currentPage = page;
	
	[self displayCurrentPageInfo];
}

- (void) displayCurrentPageInfo
{
	if([self.scrollItems count]==0)
	{
		self.titleLabel.text=nil;
		self.dateLabel.text=nil;
		self.title=@"My Newsletters";
		//self.navigationController.navigationBar.topItem.title=@"My Newsletters";
		self.toolBar.hidden=YES;
	}
	else 
	{
		Newsletter * newsletter=[self.newsletters objectAtIndex:self.pageControl.currentPage];
		
		self.toolBar.hidden=NO;
		
		self.titleLabel.text=newsletter.name;
		
		NSDateFormatter *format = [[NSDateFormatter alloc] init];
		
		[format setDateFormat:@"MMM d, yyyy"];
		
		self.dateLabel.text=[format stringFromDate:newsletter.lastUpdated]; 
		
		[format release];
		 
		self.title=[NSString stringWithFormat:@"My Newsletters (%d of %d)",(self.pageControl.currentPage+1),self.pageControl.numberOfPages];
		//self.navigationController.navigationBar.topItem.title=[NSString stringWithFormat:@"My Newsletters (%d of %d)",(self.pageControl.currentPage+1),self.pageControl.numberOfPages];
	}
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView 
{
    pageControlIsChangingPage = NO;
}

- (void) scrollToPage:(int) pageNumber
{
	CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * pageNumber;
    frame.origin.y = 0;
	
    [scrollView scrollRectToVisible:frame animated:YES];
}

- (IBAction)changePage:(id)sender 
{
	// 	Change the scroll view
	[self scrollToPage:pageControl.currentPage];
	
	//When the animated scrolling finishings, scrollViewDidEndDecelerating will turn this off
	 
	[self displayCurrentPageInfo];
	//self.newsletter=[self.newsletters objectAtIndex:pageControl.currentPage];
	
    pageControlIsChangingPage = YES;
}

@end
