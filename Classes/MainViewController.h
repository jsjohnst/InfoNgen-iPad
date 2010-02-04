//
//  DetailViewController.h
//  Untitled
//
//  Created by Robert Stewart on 2/2/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SavedSearchesViewController;

@interface MainViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate> {
    
    UIPopoverController *popoverController;
	UIPopoverController *popoverController2;
	UIPopoverController *pagesPopoverController;
	
    UINavigationBar *navigationBar;
    SavedSearchesViewController * savedSearchesViewController;
    id detailItem;
}

@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) UIPopoverController *popoverController2;
@property (nonatomic, retain) UIPopoverController *pagesPopoverController;

@property(nonatomic,retain) SavedSearchesViewController * savedSearchesViewController;
@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, retain) id detailItem;

- (IBAction)showPagesTable:(id)sender;
- (IBAction)showSavedSearches:(id)sender;

@end
