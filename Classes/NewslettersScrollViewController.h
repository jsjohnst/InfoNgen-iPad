//
//  NewslettersScrollViewController.h
//  Untitled
//
//  Created by Robert Stewart on 3/29/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NewslettersScrollViewController : UIViewController <UIScrollViewDelegate>{
	IBOutlet UIScrollView * scrollView;
	//IBOutlet UIPageControl * pageControl;
	BOOL pageControlIsChangingPage;
	
	NSArray * newsletters;
	NSArray * scrollItems;
}
@property(nonatomic,retain) IBOutlet UIScrollView * scrollView;
//@property(nonatomic,retain) IBOutlet UIPageControl * pageControl;
@property(nonatomic,retain) NSArray * newsletters;
@property(nonatomic,retain) NSArray * scrollItems;
/* for pageControl */
- (IBAction)changePage:(id)sender;
- (UIImage*)captureView:(UIView *)view ;

/* internal */
//- (void)setupPage;


@end
