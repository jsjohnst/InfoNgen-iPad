//
//  PageViewController.h
//  Untitled
//
//  Created by Robert Stewart on 2/18/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Newsletter;
@class SearchResult;
@class SavedSearch;

@interface NewsletterViewController : UIViewController< UITableViewDelegate,UITableViewDataSource> {
	IBOutlet UITableView * newsletterTableView;
	IBOutlet UIBarButtonItem * editMoveButton;
	IBOutlet UIBarButtonItem * editSettingsButton;
	IBOutlet UIBarButtonItem * updateButton;
	IBOutlet UIBarButtonItem * previewButton;
	
	Newsletter * newsletter;
	
}
@property(nonatomic,retain) IBOutlet UITableView * newsletterTableView;
@property (nonatomic,retain) IBOutlet UIBarButtonItem * editMoveButton;
@property (nonatomic,retain) IBOutlet UIBarButtonItem * editSettingsButton;
@property(nonatomic,retain) IBOutlet UIBarButtonItem * updateButton;
@property(nonatomic,retain) IBOutlet UIBarButtonItem * previewButton;

@property (nonatomic,retain) Newsletter * newsletter;

- (void) addSearchResultToCurrentNewsletter:(SearchResult*)searchResult fromSavedSearch:(SavedSearch*)savedSearch;
- (void) setCurrentNewsletter:(Newsletter*)newsletter;
- (void) renderNewsletter;

- (IBAction) toggleEditPage;
- (IBAction) settings;
- (IBAction) preview;
- (IBAction) update;

@end
