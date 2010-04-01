//
//  NewsletterScrollItemController.h
//  Untitled
//
//  Created by Robert Stewart on 3/30/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsletterBaseViewController.h"

@class Newsletter;

@interface NewsletterScrollItemController : NewsletterBaseViewController {
	IBOutlet UIWebView * webView;
	IBOutlet UIButton * newsletterButton;
}
@property(nonatomic,retain) IBOutlet UIWebView * webView;
@property(nonatomic,retain) IBOutlet UIButton * newsletterButton;

-(IBAction) newletterTouch:(id)sender;

@end
