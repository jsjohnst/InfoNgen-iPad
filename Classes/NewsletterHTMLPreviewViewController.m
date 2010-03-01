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
@synthesize newsletter,savedSearches,webView;
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
    [super dealloc];
}


@end
