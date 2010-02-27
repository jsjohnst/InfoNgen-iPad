//
//  PageHTMLPreviewViewController.h
//  Untitled
//
//  Created by Robert Stewart on 2/25/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Newsletter ;

@interface NewsletterHTMLPreviewViewController : UIViewController <UIWebViewDelegate>{
	Newsletter * newsletter;
	NSArray * savedSearches;
	IBOutlet UIWebView * webView;
}

@property(nonatomic,retain) Newsletter * newsletter;

@property(nonatomic,retain) NSArray * savedSearches;
@property(nonatomic,retain) IBOutlet UIWebView * webView;

@end
