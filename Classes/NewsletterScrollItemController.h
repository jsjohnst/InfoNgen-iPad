//
//  NewsletterScrollItemController.h
//  Untitled
//
//  Created by Robert Stewart on 3/30/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Newsletter;

@interface NewsletterScrollItemController : UIViewController {
	IBOutlet UIWebView * webView;
	Newsletter * newsletter;
	IBOutlet UIButton * newsletterButton;
}
@property(nonatomic,retain) IBOutlet UIWebView * webView;
@property(nonatomic,retain) Newsletter * newsletter;
@property(nonatomic,retain) IBOutlet UIButton * newsletterButton;

-(IBAction) newletterTouch:(id)sender;

@end
