//
//  NewslettersScrollViewController.h
//  Untitled
//
//  Created by Robert Stewart on 3/29/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Newsletter;

@interface NewslettersScrollViewController : UIViewController <UIScrollViewDelegate>{
	IBOutlet UIScrollView * scrollView;
	IBOutlet UIPageControl * pageControl;
	BOOL pageControlIsChangingPage;
	Newsletter * currentNewsletter;
	NSArray * newsletters;
	NSArray * scrollItems;
	IBOutlet UIToolbar * toolBar;
	IBOutlet UIButton * deleteButton;
	IBOutlet UIButton * sendButton;
	IBOutlet UILabel * titleLabel;
	IBOutlet UILabel * dateLabel;
}
@property(nonatomic,retain) IBOutlet UIScrollView * scrollView;
@property(nonatomic,retain) IBOutlet UIPageControl * pageControl;
@property(nonatomic,retain) NSArray * newsletters;
@property(nonatomic,retain) NSArray * scrollItems;
@property(nonatomic,retain) Newsletter * currentNewsletter;
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
