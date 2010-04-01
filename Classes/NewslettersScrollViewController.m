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
	
	//UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"Delete newsletter" message:@"Deleted newsletter" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	//[alertView show];
	//[alertView release];
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

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	
	if(actionSheet.tag==kDeleteNewsletterActionSheet)
	{
		
		if(self.newsletter)
		{
			for(NewsletterScrollItemController * controller in self.scrollItems)
			{
				if([controller.newsletter isEqual:self.newsletter])
				{
					
					// remove newsletter from newsletters
					[self.newsletters removeObject:self.newsletter];
					
					// remove view from scroll view
					[controller.view removeFromSuperview];
					
					// remove scroll item from array
					[self.scrollItems removeObject:controller];
					
					// re-adjust view
					[self layoutSubviews];
					
					if([self.newsletters count]>0)
					{
						self.newsletter=[self.newsletters objectAtIndex:self.pageControl.currentPage];
					}
					else
					{
						self.newsletter=nil;
					}
					self.pageControl.numberOfPages=self.pageControl.numberOfPages-1;
					
					// set current newsletter to next one
					break;
				}
			}
		}
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
	
	self.navigationController.navigationBar.topItem.title=@"My Newsletters";

	[scrollView setCanCancelContentTouches:NO];
	
	scrollView.showsVerticalScrollIndicator=NO;
	scrollView.showsHorizontalScrollIndicator=NO;
	scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	scrollView.clipsToBounds = YES;
	scrollView.scrollEnabled = YES;	
	scrollView.pagingEnabled = YES;
	
	NSMutableArray * array=[[NSMutableArray alloc] init];
	
	for(Newsletter * newsletter in newsletters)
	{
		NewsletterScrollItemController * item=[[NewsletterScrollItemController alloc] initWithNibName:@"NewsletterScrollItemView" bundle:nil];
		
		item.newsletter=newsletter;
		
		[array addObject:item];
	
		[self.scrollView addSubview:item.view];
	}
	
	self.scrollItems=array;
	
	self.pageControl.numberOfPages = [self.scrollItems count];

	if([newsletters count]>0)
	{
		self.newsletter=[newsletters objectAtIndex:0];
	}
	
	[array release];
	
    [super viewDidLoad];
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
	
	for(NewsletterScrollItemController * controller in self.scrollItems)
	{
		controller.view.frame=CGRectMake(((bounds.size.width - width) / 2)+ cx,top,width,height);
		
		[controller layoutSubviews];
		
		if(self.newsletter!=nil)
		{
			if([self.newsletter isEqual:controller.newsletter])
			{
				[controller renderNewsletter];
			}
		}
		cx+=bounds.size.width;
	}
	
	[scrollView setContentSize:CGSizeMake(cx, bounds.size.height)];
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	[self layoutSubviews];
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
	
	self.newsletter=[self.newsletters objectAtIndex:page];
	
	pageControl.currentPage = page;
}

- (void)setNewsletter:(Newsletter *)_newsletter
{
	if(newsletter!=nil)
	{
		[newsletter release];
	}
	
	newsletter=_newsletter;
	
	if(newsletter==nil)
	{
		self.titleLabel.text=nil;
		self.dateLabel.text=nil;
		self.navigationController.navigationBar.topItem.title=@"My Newsletters";

		return;
	}
	
	[newsletter retain];
	
	self.titleLabel.text=newsletter.name;
	
	NSDateFormatter *format = [[NSDateFormatter alloc] init];
	
	[format setDateFormat:@"MMM d, yyyy"];
	
	self.dateLabel.text=[format stringFromDate:newsletter.lastUpdated]; //  [newsletter.lastUpdated description];
	
	[format release];
	
	int ordinal=0;
	
	for(ordinal=0;ordinal<[self.newsletters count];ordinal++)
	{
		if([newsletter isEqual:[self.newsletters objectAtIndex:ordinal]])
		{
			break;
		}
	}
	
	self.navigationController.navigationBar.topItem.title=[NSString stringWithFormat:@"My Newsletters (%d of %d)",(ordinal+1),[self.newsletters count]];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView 
{
    pageControlIsChangingPage = NO;
}

- (IBAction)changePage:(id)sender 
{
	// 	Change the scroll view
	 
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * pageControl.currentPage;
    frame.origin.y = 0;
	
    [scrollView scrollRectToVisible:frame animated:YES];
	
	//When the animated scrolling finishings, scrollViewDidEndDecelerating will turn this off
	 
	self.newsletter=[self.newsletters objectAtIndex:pageControl.currentPage];
	
    pageControlIsChangingPage = YES;
}

@end
