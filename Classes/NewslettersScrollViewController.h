//
//  NewslettersScrollViewController.h
//  Untitled
//
//  Created by Robert Stewart on 3/29/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsletterBaseViewController.h"

#define kDeleteNewsletterActionSheet 1
#define kPublishNewsletterActionSheet 2

@class Newsletter;

@interface NewslettersScrollViewController : NewsletterBaseViewController <UIScrollViewDelegate,UIActionSheetDelegate>{
	IBOutlet UIScrollView * scrollView;
	IBOutlet UIPageControl * pageControl;
	BOOL pageControlIsChangingPage;
	NSMutableArray * newsletters;
	NSMutableArray * scrollItems;
	IBOutlet UIToolbar * toolBar;
	IBOutlet UIButton * deleteButton;
	IBOutlet UIButton * sendButton;
	IBOutlet UILabel * titleLabel;
	IBOutlet UILabel * dateLabel;
}
@property(nonatomic,retain) IBOutlet UIScrollView * scrollView;
@property(nonatomic,retain) IBOutlet UIPageControl * pageControl;
@property(nonatomic,retain) NSMutableArray * newsletters;
@property(nonatomic,retain) NSMutableArray * scrollItems;
@property(nonatomic,retain) IBOutlet UIButton * deleteButton;
@property(nonatomic,retain) IBOutlet UIButton * sendButton;
@property(nonatomic,retain) IBOutlet UILabel * dateLabel;
@property(nonatomic,retain) IBOutlet UILabel * titleLabel;
@property(nonatomic,retain) IBOutlet UIToolbar * toolBar;

- (IBAction)changePage:(id)sender;
//- (UIImage*)captureView:(UIView *)view ;
-(IBAction) deleteTouch:(id)sender;
-(IBAction) sendTouch:(id)sender;


@end
