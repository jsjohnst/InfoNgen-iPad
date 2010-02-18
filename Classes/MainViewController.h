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
@class PageViewController;

@interface MainViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate> {
    
	UIPopoverController *searchesPopoverController;
	UIPopoverController *pagesPopoverController;
	PagesViewController *pagesViewController;
	IBOutlet PageViewController *pageViewController;
	IBOutlet UIView * newPageView;
    SavedSearchesViewController * savedSearchesViewController;
    IBOutlet UITextField * pageName;
	IBOutlet UINavigationController *navController;
}

@property (nonatomic,retain) IBOutlet UIView * newPageView;
@property(nonatomic,retain) IBOutlet UITextField * pageName;
@property (nonatomic,retain) PagesViewController * pagesViewController;
@property (nonatomic,retain) IBOutlet  PageViewController * pageViewController;
@property (nonatomic, retain) UIPopoverController *searchesPopoverController;
@property (nonatomic, retain) UIPopoverController *pagesPopoverController;
@property(nonatomic,retain) SavedSearchesViewController * savedSearchesViewController;
@property (nonatomic,retain) IBOutlet UINavigationController *navController;

- (void)setCurrentPage:(Page*)thePage;
- (IBAction)showPagesTable:(id)sender;
- (IBAction)showSavedSearches:(id)sender;
- (IBAction) newPage:(id)sender;
- (IBAction) createNewPage:(id)sender;
- (IBAction) cancelNewPage:(id)sender;

@end
