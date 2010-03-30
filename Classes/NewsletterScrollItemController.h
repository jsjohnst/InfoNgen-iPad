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
	IBOutlet UIButton * newsletterButton;
	IBOutlet UIButton * deleteButton;
	IBOutlet UIButton * sendButton;
	IBOutlet UIWebView * webView;
	IBOutlet UILabel * titleLabel;
	IBOutlet UILabel * dateLabel;
	Newsletter * newsletter;
}

@property(nonatomic,retain) IBOutlet UIButton * newsletterButton;
@property(nonatomic,retain) IBOutlet UIButton * deleteButton;
@property(nonatomic,retain) IBOutlet UIButton * sendButton;
@property(nonatomic,retain) IBOutlet UIWebView * webView;
@property(nonatomic,retain) Newsletter * newsletter;
@property(nonatomic,retain) IBOutlet UILabel * dateLabel;
@property(nonatomic,retain) IBOutlet UILabel * titleLabel;
-(IBAction) newletterTouch:(id)sender;
-(IBAction) deleteTouch:(id)sender;
-(IBAction) sendTouch:(id)sender;


@end
