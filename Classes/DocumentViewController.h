//
//  DocumentViewController.h
//  Untitled
//
//  Created by Robert Stewart on 2/18/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SearchResult;

@interface DocumentViewController : UIViewController <UIWebViewDelegate> {
	IBOutlet UIWebView * webView;
	IBOutlet UIBarButtonItem * backButton;
	IBOutlet UIBarButtonItem * forwardButton;
	IBOutlet UIBarButtonItem * stopButton;
	IBOutlet UIBarButtonItem * reloadButton;
	
	SearchResult * searchResult;
}

@property(nonatomic,retain) IBOutlet UIWebView * webView;
@property(nonatomic,retain) SearchResult * searchResult;
@property(nonatomic,retain) IBOutlet UIBarButtonItem * backButton;
@property(nonatomic,retain) IBOutlet UIBarButtonItem * forwardButton;
@property(nonatomic,retain) IBOutlet UIBarButtonItem * stopButton;
@property(nonatomic,retain) IBOutlet UIBarButtonItem * reloadButton;

-(NSString*) getString:(NSString*)javascript;
-(NSInteger) getInt:(NSString*)javascript;
-(IBAction) getImages;

@end
