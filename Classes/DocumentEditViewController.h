//
//  DocumentEditViewController.h
//  Untitled
//
//  Created by Robert Stewart on 2/22/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SearchResult;

@interface DocumentEditViewController : UIViewController <UITextFieldDelegate,UITextViewDelegate>{
	SearchResult * searchResult;
	IBOutlet UITextField * headlineTextField;
	IBOutlet UITextView * synopsisTextView;
}

@property(nonatomic,retain) SearchResult * searchResult;
@property(nonatomic,retain) IBOutlet UITextField * headlineTextField;
@property(nonatomic,retain) IBOutlet UITextView * synopsisTextView;

/*- (IBAction) cancel;
- (IBAction) save;*/
/*- (IBAction) getText;*/
- (IBAction) getUrl;

@end
