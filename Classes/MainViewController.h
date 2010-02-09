//
//  DetailViewController.h
//  Untitled
//
//  Created by Robert Stewart on 2/2/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SavedSearchesViewController;
@class Page;
@class PagesViewController;

@interface MainViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate,UITableViewDelegate,UITableViewDataSource> {
    
    UIPopoverController *popoverController;
	UIPopoverController *popoverController2;
	UIPopoverController *pagesPopoverController;
	PagesViewController *pagesViewController;
	IBOutlet UIView * newPageView;
	UINavigationBar *navigationBar;
    SavedSearchesViewController * savedSearchesViewController;
	Page * page;
	UITableView * pageTableView;
    IBOutlet UITextField * pageName;
}
@property (nonatomic,retain) IBOutlet UIView * newPageView;
@property(nonatomic,retain) IBOutlet UITextField * pageName;
@property (nonatomic,retain) PagesViewController * pagesViewController;
@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) UIPopoverController *popoverController2;
@property (nonatomic, retain) UIPopoverController *pagesPopoverController;
@property(nonatomic,retain) SavedSearchesViewController * savedSearchesViewController;
@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic,retain) IBOutlet UITableView *pageTableView;
@property (nonatomic,retain) Page * page;

- (void)setCurrentPage:(Page*)thePage;
- (void)renderPage;
- (IBAction)showPagesTable:(id)sender;
- (IBAction)showSavedSearches:(id)sender;
- (IBAction) toggleEditPage;
- (IBAction) newPage:(id)sender;
- (IBAction) createNewPage:(id)sender;
- (IBAction) cancelNewPage:(id)sender;

@end
