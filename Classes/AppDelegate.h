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
@class NewsletterSettingsViewController;
@class NewsletterHTMLPreviewViewController;
@class LoginTicket;
@class SearchResult;
@class Newsletter;
@class SavedSearch;

@interface AppDelegate : NSObject <UIApplicationDelegate,UISplitViewControllerDelegate, UINavigationControllerDelegate> {
    
    UIWindow *window;
    
    UISplitViewController *splitViewController;
    
	UINavigationController *navigationController;
	
	UIPopoverController *newslettersPopoverController;
	
	UITabBarController * tabBarController;
	
	NewslettersViewController * newslettersViewController;
	
	NewsletterViewController * headlineViewController;
	NewsletterViewController * synopsisViewController;
	NewsletterSettingsViewController * newsletterSettingsViewController;
	NewsletterHTMLPreviewViewController * newsletterHTMLPreviewViewController;
	
	Newsletter * newsletter;
	
	NSMutableArray * newsletters;
	NSMutableArray * savedSearches;
}

@property (retain) NSMutableArray * newsletters;
@property (retain) NSMutableArray * savedSearches;
@property (nonatomic,retain) Newsletter * newsletter;
@property (nonatomic, retain) UIPopoverController *newslettersPopoverController;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic,retain) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic,retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic,retain) IBOutlet NewslettersViewController * newslettersViewController;
@property (nonatomic,retain) IBOutlet NewsletterViewController * headlineViewController;
@property (nonatomic,retain) IBOutlet NewsletterViewController * synopsisViewController;
@property(nonatomic,retain) UITabBarController * tabBarController;
@property(nonatomic,retain) NewsletterSettingsViewController * newsletterSettingsViewController;
@property(nonatomic,retain) NewsletterHTMLPreviewViewController * newsletterHTMLPreviewViewController;

- (void) editNewsletter:(Newsletter*)newsletter;
- (void) newNewsletter;
- (void) deleteNewsletter:(Newsletter*)newsletter;
- (void) setCurrentNewsletter:(Newsletter*)newsletter;
- (void) showNewslettersPopOver:(id)sender;
- (void) addSearchResultToCurrentNewsletter:(SearchResult*)searchResult fromSavedSearch:(SavedSearch*)savedSearch;
- (void) renderNewsletter;

- (NSString *)dataFilePath;
- (void) loadArchivedData;
- (void) saveData;

@end
