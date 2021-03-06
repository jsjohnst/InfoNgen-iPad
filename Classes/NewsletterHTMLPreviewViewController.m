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
#import "AppDelegate.h"

@implementation NewsletterHTMLPreviewViewController
@synthesize webView;


- (void) renderNewsletter
{
	NSString   *html = [NewsletterHTMLPreviewViewController getHtml:self.newsletter]; 
	
	[self.webView loadHTMLString:html baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
	
	[self.webView setNeedsDisplay];	
}

/*- (IBAction) publish
{
	UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"Publish Newsletter" message:@"Not implemented yet." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	
	[alertView show];
	
	[alertView release];
	
}*/
/*
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
			
			NSString *htmlBody = @"you probably want something HTML-y here";
			
			// First escape the body using a CF call
			NSString *escapedBody = [(NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,  (CFStringRef)htmlBody, NULL,  CFSTR("?=&+"), kCFStringEncodingUTF8) autorelease];
			
			// Then escape the prefix using the NSString method
			NSString *mailtoPrefix = [@"mailto:?subject=Some Subject&body=" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			
			// Finally, combine to create the fully escaped URL string
			NSString *mailtoStr = [mailtoPrefix stringByAppendingString:escapedBody];
			
			// And let the application open the merged URL
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailtoStr]];
			
			
			
			
		}
	}

}*/

- (void)viewDidLoad
{
	self.navigationItem.title=@"Newsletter Preview";
}

- (void)viewWillAppear:(BOOL)animated
{
	[self renderNewsletter];
	[super viewWillAppear:animated];
}

+ (NSString*) getHtml:(Newsletter*)newsletter
{
	NSString   *html = [NSString stringWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"newsletter" ofType:@"html"] 
												 encoding: NSUTF8StringEncoding 
													error: nil];
	
	if (newsletter.name!=nil) 
	{
		html=[html stringByReplacingOccurrencesOfString:@"{{newsletter.name}}" withString:newsletter.name];
	}
	
	if(newsletter.summary!=nil)
	{
		html=[html stringByReplacingOccurrencesOfString:@"{{newsletter.summary}}" withString:[newsletter.summary stringByReplacingOccurrencesOfString:@"\n" withString:@"<BR />"]];
	}
	else 
	{
		html=[html stringByReplacingOccurrencesOfString:@"{{newsletter.summary}}" withString:@""];
	}

	if (newsletter.logoImage) 
	{
		NSData *imageData = UIImagePNGRepresentation(newsletter.logoImage);
		
		NSString * encoded=[Base64 encode:imageData];
		
		html=[html stringByReplacingOccurrencesOfString:@"{{newsletter.logoImage}}" withString:[NSString stringWithFormat:@"<img src=\"data:image/png;base64,%@\">",encoded]];
	}
	else
	{
		html=[html stringByReplacingOccurrencesOfString:@"{{newsletter.logoImage}}" withString:@""];
	}
	
	NSDateFormatter *format = [[NSDateFormatter alloc] init];
	
	[format setDateFormat:@"MMM d, yyyy"];
	
	html=[html stringByReplacingOccurrencesOfString:@"{{newsletter.lastUpdated}}" withString:[format stringFromDate:newsletter.lastUpdated]];
	
	[format release];
	
	format = [[NSDateFormatter alloc] init];
	[format setDateFormat:@"MMM d, yyyy h:mm"];
	
	NSRange start=[html rangeOfString:@"{{newsletter.sections.left}}"];
	NSRange end=[html rangeOfString:@"{{/newsletter.sections.left}}"];
	NSRange range=NSMakeRange(start.location+start.length   , (end.location-(start.location+start.length)));
	NSString * sectionTemplate=[html substringWithRange:range];
	
	NSMutableString * sections=[[NSMutableString alloc] init];
	
	
	if(newsletter.sections)
	{
		int i=0;
		for (NewsletterSection * section in newsletter.sections)
		{	
			NSString * tmp=[sectionTemplate stringByReplacingOccurrencesOfString:@"{{section.name}}" withString:section.name];
			tmp=[tmp stringByReplacingOccurrencesOfString:@"{{section.ordinal}}" withString:[NSString stringWithFormat:@"%d",i]];
			
			i++;
			[sections appendString:tmp];
		}
	}
	
	html=[html stringByReplacingCharactersInRange:NSMakeRange(start.location   , (end.location+end.length -(start.location))) withString:sections];
	
	[sections release];
	
	start=[html rangeOfString:@"{{newsletter.sections.right}}"];
	end=[html rangeOfString:@"{{/newsletter.sections.right}}"];
	range=NSMakeRange(start.location+start.length   , (end.location-(start.location+start.length)));
	sectionTemplate=[html substringWithRange:range];
	
	sections=[[NSMutableString alloc] init];
	
	if(newsletter.sections)
	{
		int i=0;
		for (NewsletterSection * section in newsletter.sections)
		{	
			NSString * tmp=[sectionTemplate stringByReplacingOccurrencesOfString:@"{{section.name}}" withString:section.name];
			
			tmp=[tmp stringByReplacingOccurrencesOfString:@"{{section.ordinal}}" withString:[NSString stringWithFormat:@"%d",i]];
			
			i++;
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
						
						itemTmp=[itemTmp stringByReplacingOccurrencesOfString:@"{{item.date}}" withString:[format stringFromDate:item.date]];
						
						if(item.synopsis)
						{
							itemTmp=[itemTmp stringByReplacingOccurrencesOfString:@"{{item.synopsis}}" withString:[item.synopsis stringByReplacingOccurrencesOfString:@"\n" withString:@"<BR />"]];
						}
						else
						{
							itemTmp=[itemTmp stringByReplacingOccurrencesOfString:@"{{item.synopsis}}" withString:@""];
						}
						
						if(item.notes && [item.notes length]>0)
						{
							itemTmp=[itemTmp stringByReplacingOccurrencesOfString:@"{{item.comments}}" withString:[NSString stringWithFormat:@"<BR />&gt; %@",[item.notes stringByReplacingOccurrencesOfString:@"\n" withString:@"<BR />"]]];
						}
						else
						{
							itemTmp=[itemTmp stringByReplacingOccurrencesOfString:@"{{item.comments}}" withString:@""];
						}
						if (item.image) 
						{
							NSData *imageData = UIImagePNGRepresentation(item.image);
							
							NSString * encoded=[Base64 encode:imageData];
							
							itemTmp=[itemTmp stringByReplacingOccurrencesOfString:@"{{item.image}}" withString:[NSString stringWithFormat:@"<img style=\"float:left;margin-right:4px\" src=\"data:image/png;base64,%@\">",encoded]];
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
	
	[format release];
	
	return html;
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
	[webView release];
	[super dealloc];
}

@end
