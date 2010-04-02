//
//  PageHTMLPreviewViewController.h
//  Untitled
//
//  Created by Robert Stewart on 2/25/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NewsletterBaseViewController.h"

@class Newsletter ;

@interface NewsletterHTMLPreviewViewController : NewsletterBaseViewController <UIWebViewDelegate,UIActionSheetDelegate>{
	IBOutlet UIWebView * webView;
}
@property(nonatomic,retain) IBOutlet UIWebView * webView;

+ (NSString*) getHtml:(Newsletter*)newsletter;
@end
