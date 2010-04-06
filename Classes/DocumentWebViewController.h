//
//  DocumentViewController.h
//  Untitled
//
//  Created by Robert Stewart on 2/18/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SearchResult;
@class MetaTag;

@interface DocumentWebViewController : UIViewController <UIWebViewDelegate,UIActionSheetDelegate> {
	IBOutlet UIWebView * webView;
	IBOutlet UIBarButtonItem * backButton;
	IBOutlet UIBarButtonItem * forwardButton;
	//IBOutlet UIBarButtonItem * stopButton;
	//IBOutlet UIBarButtonItem * reloadButton;
	IBOutlet UIBarButtonItem * selectImageButton;
	IBOutlet UIBarButtonItem * readabilityButton;
	SearchResult * searchResult;
	
	NSString * selectedImageSource;
	NSString * selectedImageLink;
}

@property(nonatomic,retain) IBOutlet UIWebView * webView;
@property(nonatomic,retain) SearchResult * searchResult;
@property(nonatomic,retain) IBOutlet UIBarButtonItem * backButton;
@property(nonatomic,retain) IBOutlet UIBarButtonItem * forwardButton;
@property(nonatomic,retain) IBOutlet UIBarButtonItem * selectImageButton;
@property(nonatomic,retain) IBOutlet UIBarButtonItem * readabilityButton;
//@property(nonatomic,retain) IBOutlet UIBarButtonItem * stopButton;
//@property(nonatomic,retain) IBOutlet UIBarButtonItem * reloadButton;

@property(nonatomic,retain) NSString * selectedImageSource;
@property(nonatomic,retain) NSString * selectedImageLink;

- (void) highlightText:(MetaTag *)tag;
- (IBAction) selectImages:(id)sender;
- (void)appendSynopsis:(id)sender;
- (void)replaceSynopsis:(id)sender;

/*- (NSString *)flattenHTML:(NSString *)html;*/
- (void)doSomething:(NSTimer *)theTimer;
-(NSString*) getString:(NSString*)javascript;
-(NSInteger) getInt:(NSString*)javascript;
/*-(IBAction) getImages;*/
-(IBAction) getText;
/*-(IBAction) edit;
*/
- (IBAction) readability;
- (NSString *)showSubviews:(UIView *)view tabs:(NSString *)tabs;

@end
