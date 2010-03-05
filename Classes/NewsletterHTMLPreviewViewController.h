//
//  PageHTMLPreviewViewController.h
//  Untitled
//
//  Created by Robert Stewart on 2/25/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Newsletter ;

@interface NewsletterHTMLPreviewViewController : UIViewController <UIWebViewDelegate,UIActionSheetDelegate>{
	Newsletter * newsletter;
	NSArray * savedSearches;
	IBOutlet UIWebView * webView;
	IBOutlet UIBarButtonItem * publishButton;
	IBOutlet UIToolbar * toolBar;
}

@property(nonatomic,retain) Newsletter * newsletter;

@property(nonatomic,retain) NSArray * savedSearches;
@property(nonatomic,retain) IBOutlet UIWebView * webView;
@property(nonatomic,retain) IBOutlet UIBarButtonItem * publishButton;
@property(nonatomic,retain) IBOutlet UIToolbar * toolBar;

- (void) renderHtml;

- (IBAction) publish;

@end
