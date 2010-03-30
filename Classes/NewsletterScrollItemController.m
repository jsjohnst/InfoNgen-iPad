    //
//  NewsletterScrollItemController.m
//  Untitled
//
//  Created by Robert Stewart on 3/30/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import "NewsletterScrollItemController.h"
#import "Newsletter.h"
#import "NewsletterHTMLPreviewViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation NewsletterScrollItemController
@synthesize newsletterButton,deleteButton,sendButton,newsletter,webView,dateLabel,titleLabel;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
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
	
	NSLog(@"item viewDidLoad");
	
	self.view.opaque=NO;
	
	self.view.backgroundColor=[UIColor clearColor];
	
	
	//groupTableViewBackgroundColor
	//viewFlipsideBackgroundColor
	
	
	self.titleLabel.text=newsletter.name;
	
	NSDateFormatter *format = [[NSDateFormatter alloc] init];
	
	[format setDateFormat:@"MMM d, yyyy"];
	
	self.dateLabel.text=[format stringFromDate:newsletter.lastUpdated]; //  [newsletter.lastUpdated description];
    
	[format release];
	
	NSString * html=[NewsletterHTMLPreviewViewController getHtml:newsletter];
	
	webView.scalesPageToFit=YES;
	
	[webView loadHTMLString:html baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
	
	//[webView setNeedsDisplay];
	
	[super viewDidLoad];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	return YES;
}

-(IBAction) newletterTouch:(id)sender
{
	UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"Select newsletter" message:@"Selected newsletter" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

-(IBAction) deleteTouch:(id)sender
{
	UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"Delete newsletter" message:@"Deleted newsletter" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

-(IBAction) sendTouch:(id)sender
{
	UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"Send newsletter" message:@"Sent newsletter" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)layoutSubviews
{
    NSLog(@"layoutSubviews in item controller called");
	
	NSLog(NSStringFromCGRect(self.view.bounds));
	
	CGFloat width=self.view.bounds.size.width;
	CGFloat height=self.view.bounds.size.height;
	
	CGFloat footer=100;
	CGFloat header=10;
	
	// layout webview - give it 4x3 aspect ratio
	CGFloat webHeight=height-footer-header;
	CGFloat webWidth=webHeight * 0.75;
	CGFloat webX=(width-webWidth)/2;
	CGFloat webY=header;
	
	self.webView.frame=CGRectMake(webX, webY, webWidth, webHeight);
	
	self.webView.layer.shadowColor=[UIColor blackColor].CGColor;
	self.webView.layer.shadowOpacity=0.8;
	self.webView.layer.shadowRadius=4;
	self.webView.layer.shadowOffset = CGSizeMake(4.0f, 4.0f);
	
	
	
	
	
	
	self.newsletterButton.frame=CGRectMake(webX, webY, webWidth, webHeight);
	
	// layout footer
	self.titleLabel.frame=CGRectMake((width-self.titleLabel.frame.size.width)/2,height-footer+10,self.titleLabel.frame.size.width,self.titleLabel.frame.size.height);
	self.dateLabel.frame=CGRectMake((width-self.dateLabel.frame.size.width)/2,self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height+10   ,self.dateLabel.frame.size.width,self.dateLabel.frame.size.height);
	self.deleteButton.frame=CGRectMake(width/2 + 60, self.dateLabel.frame.origin.y+self.dateLabel.frame.size.height+20, self.deleteButton.frame.size.width, self.deleteButton.frame.size.height);
	self.sendButton.frame=CGRectMake(width/2 - 60 - self.sendButton.frame.size.width, self.dateLabel.frame.origin.y+self.dateLabel.frame.size.height+20, self.sendButton.frame.size.width, self.sendButton.frame.size.height);
	
	
	/*UIGraphicsBeginImageContext(CGSizeMake(webWidth, webHeight));
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetShadow(context, CGSizeMake(.5,.5),.2);
	UIGraphicsEndImageContext();
	
	[self setNeedsDisplay];*/
	
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	
	[newsletterButton release];
	[deleteButton release];
	[sendButton release];
	[newsletter release];
	[webView release];
	[dateLabel release];
	[titleLabel release];
	
    [super dealloc];
}


@end
