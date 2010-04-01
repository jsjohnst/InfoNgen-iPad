//
//  PageViewController.h
//  Untitled
//
//  Created by Robert Stewart on 2/18/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsletterBaseViewController.h"

#define kClearItemsActionSheet 1
#define kDeleteActionSheet 2
#define kClearSelectedItemsActionSheet 3

@class Newsletter;
@class SearchResult;
@class SavedSearch;
@class NewsletterHTMLPreviewViewController;

@interface NewsletterViewController : NewsletterBaseViewController< UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate> {
	IBOutlet UITableView * newsletterTableView;
	IBOutlet UIBarButtonItem * editMoveButton;
	IBOutlet UIButton * addImageButton;
	IBOutlet UISegmentedControl * segmentedControl;
	IBOutlet UITextField * titleTextField;
	IBOutlet UITextView * descriptionTextField;
	BOOL updating;
	BOOL viewModeExpanded;
}

@property(nonatomic,retain) IBOutlet UITableView * newsletterTableView;
@property (nonatomic,retain) IBOutlet UIBarButtonItem * editMoveButton;
@property (nonatomic,retain) IBOutlet UIButton * addImageButton;
@property (nonatomic,retain) IBOutlet UISegmentedControl * segmentedControl;
@property (nonatomic,retain) IBOutlet UITextField * titleTextField;
@property (nonatomic,retain) IBOutlet UITextView * descriptionTextField;

- (void) addImageTouch:(id)sender;


-(void) closePreview;
- (void) scrollToSection:(NSString*)sectionName;

-(void) setViewMode:(BOOL)expanded;

-(void) toggleViewMode:(id)sender;

- (void) addSearchResultToCurrentNewsletter:(SearchResult*)searchResult fromSavedSearch:(SavedSearch*)savedSearch;
- (void) setCurrentNewsletter:(Newsletter*)newsletter;

- (IBAction) clearNewsletterItems;
- (IBAction) deleteNewsletter;
- (IBAction) toggleEditPage:(id)sender;
- (IBAction) settings;
- (IBAction) preview;
- (IBAction) update;
- (UILabel *)newLabelWithPrimaryColor:(UIColor *)primaryColor selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold;
-(void) setButtonsEnabled:(BOOL)enabled;
- (void) deleteSelectedRows;
- (void) actionTouch:(id)sender;
@end
