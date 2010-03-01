//
//  UntitledAppDelegate.h
//  Untitled
//
//  Created by Robert Stewart on 2/2/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class NewsletterViewController;
@class NewslettersViewController; 
@class LoginTicket;
@class SearchResult;
@class Newsletter;
@class SavedSearch;
@class SavedSearchesViewController;
//UIPopoverControllerDelegate
@interface AppDelegate : NSObject <UIApplicationDelegate,UISplitViewControllerDelegate, UINavigationControllerDelegate> {
    
    UIWindow *window;
    
    UISplitViewController *splitViewController;
    UINavigationController *navigationController;
	UIPopoverController *newslettersPopoverController;
	UIPopoverController *searchesPopoverController;
	
	NewslettersViewController * newslettersViewController;
	SavedSearchesViewController *savedSearchesViewController;
    NewsletterViewController * newsletterViewController;
	
	NSMutableArray * newsletters;
	NSMutableArray * savedSearches;
}

@property (retain) NSMutableArray * newsletters;
@property (retain) NSMutableArray * savedSearches;

@property (nonatomic, retain) UIPopoverController *newslettersPopoverController;
@property (nonatomic, retain) UIPopoverController *searchesPopoverController;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic,retain) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic,retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic,retain) IBOutlet SavedSearchesViewController *savedSearchesViewController;
@property (nonatomic,retain) IBOutlet NewslettersViewController * newslettersViewController;
@property (nonatomic,retain) IBOutlet NewsletterViewController * newsletterViewController;

- (void) setCurrentNewsletter:(Newsletter*)newsletter;
- (void)showNewslettersPopOver:(id)sender;
- (void)showSavedSearchesPopOver:(id)sender;
- (void) addSearchResultToCurrentNewsletter:(SearchResult*)searchResult fromSavedSearch:(SavedSearch*)savedSearch;

- (NSString *)dataFilePath;

- (void) loadArchivedData;

- (void) saveData;

@end
