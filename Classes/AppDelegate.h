//
//  UntitledAppDelegate.h
//  Untitled
//
//  Created by Robert Stewart on 2/2/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SavedSearchesViewController;
@class MainViewController;
@class LoginTicket;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    
    UISplitViewController *splitViewController;
    SavedSearchesViewController *savedSearchesViewController;
    MainViewController *mainViewController;
	NSMutableArray * pages;
	NSMutableArray * savedSearches;
	
}

@property (retain) NSMutableArray * pages;
@property (retain) NSMutableArray * savedSearches;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic,retain) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic,retain) IBOutlet SavedSearchesViewController *savedSearchesViewController;
@property (nonatomic,retain) IBOutlet MainViewController *mainViewController;

- (NSString *)dataFilePath;
- (void) loadArchivedData;
- (void) saveData;

@end
