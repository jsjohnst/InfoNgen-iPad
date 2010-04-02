//
//  NewsletterItemCell.h
//  Untitled
//
//  Created by Robert Stewart on 3/12/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SearchResult;

#define kCellWidth 675
#define kCellPadding 10
#define kFontSize 14
#define kHeadlineFontSize 16
#define kDateFontSize 14
#define kLineSpacing 4

struct ItemSize {
	CGSize size;
	CGRect headline_rect;
	CGRect date_rect;
	CGRect image_rect;
	int synopsis_break;
	CGRect synopsis_rect1;
	CGRect synopsis_rect2;
	CGRect comments_rect;
};
typedef struct ItemSize ItemSize;


@interface NewsletterItemContentView : UIView <UIActionSheetDelegate>{
	SearchResult * searchResult;
	//NSTimer * holdTimer;
	UIViewController * parentController;
	UITableView * parentTableView;
	UIPopoverController * imagePickerPopover;
	
	BOOL viewModeExpanded;
	
	ItemSize _itemSize;
	
	UIButton * imageButton;
	UIButton * addImageButton;
	UIButton * synopsisButton1;
	UIButton * synopsisButton2;
	UIButton * commentsButton;
	UIButton * headlineButton;
	 
	
}
@property (nonatomic,retain) SearchResult * searchResult;
//@property(nonatomic,retain) NSTimer * holdTimer;
@property(nonatomic,retain) UIViewController * parentController;
@property(nonatomic,retain) UITableView * parentTableView;
@property(nonatomic,retain) UIPopoverController * imagePickerPopover;
+ (int) findBestFit:(NSString*)text constraint:(CGSize)constraint;

- (void) redraw;
- (void) touchHeadline;
- (void) touchSynopsis;
- (void) touchComments;

- (void) setViewMode:(BOOL)expanded;
//- (BOOL) didTouchRect:(UITouch*)touch rect:(CGRect)rect;

+ (ItemSize) sizeForCell:(SearchResult *)searchResult viewMode:(BOOL)expanded rect:(CGRect)rect;
//+(CGFloat) heightForCell:(SearchResult *)searchResult viewMode:(BOOL)expanded;
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;
/*- (void)doSomething:(NSTimer *)theTimer;
- (BOOL) didTouchImage:(UITouch*)touch;
- (BOOL) didTouchSynopsis:(UITouch*)touch;
- (BOOL) didTouchComments:(UITouch*)touch;
- (BOOL) didTouchHeadline:(UITouch*)touch;
- (void) doHeadlineTouch;*/
@end
