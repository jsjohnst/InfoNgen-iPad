//
//  NewsletterItemCell.h
//  Untitled
//
//  Created by Robert Stewart on 3/12/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SearchResult;

#define kCellWidth 700
#define kCellPadding 10
#define kFontSize 14
#define kHeadlineFontSize 16
#define kDateFontSize 14
#define kLineSpacing 4

@interface NewsletterItemContentView : UIView <UIActionSheetDelegate>{
	SearchResult * searchResult;
	NSTimer * holdTimer;
	UIViewController * parentController;
	UITableView * parentTableView;
	UIPopoverController * imagePickerPopover;
	BOOL viewModeExpanded;
}
@property (nonatomic,retain) SearchResult * searchResult;
@property(nonatomic,retain) NSTimer * holdTimer;
@property(nonatomic,retain) UIViewController * parentController;
@property(nonatomic,retain) UITableView * parentTableView;
@property(nonatomic,retain) UIPopoverController * imagePickerPopover;
+ (int) findBestFit:(NSString*)text constraint:(CGSize)constraint;

- (void) redraw;

- (void) setViewMode:(BOOL)expanded;


+(CGFloat) heightForCell:(SearchResult *)searchResult viewMode:(BOOL)expanded;
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;
- (void)doSomething:(NSTimer *)theTimer;
- (BOOL) didTouchImage:(UITouch*)touch;
- (BOOL) didTouchSynopsis:(UITouch*)touch;
- (BOOL) didTouchComments:(UITouch*)touch;
- (BOOL) didTouchHeadline:(UITouch*)touch;
- (void) doHeadlineTouch;
@end
