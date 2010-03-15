//
//  DocumentEditFormViewController.h
//  Untitled
//
//  Created by Robert Stewart on 3/15/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SearchResult;

@interface DocumentEditFormViewController : UIViewController {
	SearchResult * searchResult;
	IBOutlet UITextField * headlineTextField;
	IBOutlet UITextView * synopsisTextView;
	IBOutlet UITextView * commentsTextView;
	id delegate;
}
@property(nonatomic,retain) SearchResult * searchResult;
@property(nonatomic,retain) IBOutlet UITextField * headlineTextField;
@property(nonatomic,retain) IBOutlet UITextView * synopsisTextView;
@property(nonatomic,retain) IBOutlet UITextView * commentsTextView;
@property(nonatomic,retain) id delegate;
- (IBAction) dismiss;

@end
