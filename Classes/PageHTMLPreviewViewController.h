//
//  PageHTMLPreviewViewController.h
//  Untitled
//
//  Created by Robert Stewart on 2/25/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Page;

@interface PageHTMLPreviewViewController : UIViewController <UIWebViewDelegate>{
	Page * page;
	NSArray * savedSearches;
	IBOutlet UIWebView * webView;
}

@property(nonatomic,retain) Page * page;
@property(nonatomic,retain) NSArray * savedSearches;
@property(nonatomic,retain) IBOutlet UIWebView * webView;

@end
