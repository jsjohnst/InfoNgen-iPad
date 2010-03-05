    //
//  PageHTMLPreviewViewController.m
//  Untitled
//
//  Created by Robert Stewart on 2/25/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import "NewsletterHTMLPreviewViewController.h"
#import "SavedSearch.h"
#import "Newsletter.h"
#import "NewsletterSection.h"
#import "SearchResult.h"
#import "Base64.h"

@implementation NewsletterHTMLPreviewViewController
@synthesize newsletter,savedSearches,webView,publishButton,toolBar;
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

- (IBAction) publish
{
	UIActionSheet * actionSheet=[[UIActionSheet alloc] initWithTitle:@"Publish Newsletter to:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Distribution List",@"Specific Contact",nil];
	
	//actionSheet.tag=kDeleteActionSheet;
	
	[actionSheet showFromToolbar:self.toolBar];
	
	[actionSheet release];
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
	NSLog(@"actionSheetCancel");
	
}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
	NSLog(@"actionSheet:willDismissWithButtonIndex %d",buttonIndex);
	
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSLog(@"actionSheet:clickedButtonAtIndex %d",buttonIndex);
	
	// get contact(s) to publish to...
	
	if(buttonIndex==0)
	{
		if(self.newsletter.distributionList==nil || [self.newsletter.distributionList count]==0)
		{
			UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"Publish Newsletter" message:@"Please specify a distribution list in newsletter settings." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			
			[alertView show];
			
			[alertView release];
		}
		else
		{
			// send to distribution list...
		}
	}
	else 
	{
		if(buttonIndex==1)
		{
			// get contact(s) to send to...
			//NSURL *url = [[NSURL alloc] initWithString:@"mailto:bstewart.ny@gmail.com?subject=This is my subject&body=this is the body"];
			//[[UIApplication sharedApplication] openURL:url];
			
			/*NSString *htmlBody = @"you probably want something HTML-y here";
			
			// First escape the body using a CF call
			NSString *escapedBody = [(NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,  (CFStringRef)htmlBody, NULL,  CFSTR("?=&+"), kCFStringEncodingUTF8) autorelease];
			
			// Then escape the prefix using the NSString method
			NSString *mailtoPrefix = [@"mailto:?subject=Some Subject&body=" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			
			// Finally, combine to create the fully escaped URL string
			NSString *mailtoStr = [mailtoPrefix stringByAppendingString:escapedBody];
			
			// And let the application open the merged URL
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailtoStr]];
			
			*/
			
			
		}
	}

}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	[self renderHtml];
}

- (void) renderHtml
{
	NSString   *html = [NSString stringWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"newsletter" ofType:@"html"] 
												 encoding: NSUTF8StringEncoding 
													error: nil];
	
	html=[html stringByReplacingOccurrencesOfString:@"{{newsletter.name}}" withString:self.newsletter.name];
	
	
	if (self.newsletter.logoImage) 
	{
		NSData *imageData = UIImagePNGRepresentation(self.newsletter.logoImage);
		
		NSString * encoded=[Base64 encode:imageData];
		
		html=[html stringByReplacingOccurrencesOfString:@"{{newsletter.logoImage}}" withString:[NSString stringWithFormat:@"<img src=\"data:image/png;base64,%@\">",encoded]];
	}
	else
	{
		html=[html stringByReplacingOccurrencesOfString:@"{{newsletter.logoImage}}" withString:@""];
	}

	html=[html stringByReplacingOccurrencesOfString:@"{{newsletter.lastUpdated}}" withString:[self.newsletter.lastUpdated description]];
	
	NSRange start=[html rangeOfString:@"{{newsletter.sections.left}}"];
	NSRange end=[html rangeOfString:@"{{/newsletter.sections.left}}"];
	NSRange range=NSMakeRange(start.location+start.length   , (end.location-(start.location+start.length)));
	NSString * sectionTemplate=[html substringWithRange:range];
	
	NSMutableString * sections=[[NSMutableString alloc] init];
	
	for (NewsletterSection * section in self.newsletter.sections)
	{	
		NSString * tmp=[sectionTemplate stringByReplacingOccurrencesOfString:@"{{section.name}}" withString:section.name];
		[sections appendString:tmp];
	}
	
	html=[html stringByReplacingCharactersInRange:NSMakeRange(start.location   , (end.location+end.length -(start.location))) withString:sections];
							  
	[sections release];
	
	start=[html rangeOfString:@"{{newsletter.sections.right}}"];
	end=[html rangeOfString:@"{{/newsletter.sections.right}}"];
	range=NSMakeRange(start.location+start.length   , (end.location-(start.location+start.length)));
	sectionTemplate=[html substringWithRange:range];
	
	sections=[[NSMutableString alloc] init];
	
	if(self.newsletter.sections)
	{
		for (NewsletterSection * section in self.newsletter.sections)
		{	
			NSString * tmp=[sectionTemplate stringByReplacingOccurrencesOfString:@"{{section.name}}" withString:section.name];
			
			NSRange tmpstart=[tmp rangeOfString:@"{{section.items}}"];
			NSRange tmpend=[tmp rangeOfString:@"{{/section.items}}"];
			NSRange tmprange=NSMakeRange(tmpstart.location+tmpstart.length   , (tmpend.location-(tmpstart.location+tmpstart.length)));
			NSString * tmpTemplate=[tmp substringWithRange:tmprange];
			
			NSMutableString * items=[[NSMutableString alloc] init];
			
			if(section.items)
			{
				for(SearchResult * item in section.items)
				{
					if(item.headline)
					{
						NSString * itemTmp=[tmpTemplate stringByReplacingOccurrencesOfString:@"{{item.headline}}" withString:item.headline];
						
						if(item.url)
						{
							itemTmp=[itemTmp stringByReplacingOccurrencesOfString:@"{{item.url}}" withString:item.url];
						}
						else 
						{
							itemTmp=[itemTmp stringByReplacingOccurrencesOfString:@"{{item.url}}" withString:@""];
						}
						
						itemTmp=[itemTmp stringByReplacingOccurrencesOfString:@"{{item.date}}" withString:[item.date description]];
						
						if(item.synopsis)
						{
							itemTmp=[itemTmp stringByReplacingOccurrencesOfString:@"{{item.synopsis}}" withString:item.synopsis];
						}
						else
						{
							itemTmp=[itemTmp stringByReplacingOccurrencesOfString:@"{{item.synopsis}}" withString:@""];
						}
						
						if(item.notes && [item.notes length]>0)
						{
							itemTmp=[itemTmp stringByReplacingOccurrencesOfString:@"{{item.comments}}" withString:[NSString stringWithFormat:@"<BR />&gt; %@",item.notes]];
						}
						else
						{
							itemTmp=[itemTmp stringByReplacingOccurrencesOfString:@"{{item.comments}}" withString:@""];
						}
						if (item.image) 
						{
							NSData *imageData = UIImagePNGRepresentation(item.image);
							
							NSString * encoded=[Base64 encode:imageData];
							
							itemTmp=[itemTmp stringByReplacingOccurrencesOfString:@"{{item.image}}" withString:[NSString stringWithFormat:@"<img src=\"data:image/png;base64,%@\">",encoded]];
						}
						else
						{
							itemTmp=[itemTmp stringByReplacingOccurrencesOfString:@"{{item.image}}" withString:@""];
							
						}
						[items appendString:itemTmp];
					}
				}
			}
			
			tmp=[tmp stringByReplacingCharactersInRange:NSMakeRange(tmpstart.location   , (tmpend.location+tmpend.length -(tmpstart.location))) withString:items];
			
			[sections appendString:tmp];
			
			[items release];
		}
	}
	
	html=[html stringByReplacingCharactersInRange:NSMakeRange(start.location   , (end.location+end.length -(start.location))) withString:sections];
	
	[sections release];
	
	[self.webView loadHTMLString:html baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
	
	[self.webView setNeedsDisplay];
	
	[super viewDidLoad];
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}


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
	[newsletter release];
	[savedSearches release];
	[webView release];
	[publishButton release];
	[toolBar release];
    [super dealloc];
}


@end
