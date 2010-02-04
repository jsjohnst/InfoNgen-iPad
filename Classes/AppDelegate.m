//
//  UntitledAppDelegate.m
//  Untitled
//
//  Created by Robert Stewart on 2/2/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import "AppDelegate.h"
#import "SavedSearchesViewController.h"
#import "MainViewController.h"

@implementation AppDelegate

@synthesize window,splitViewController, savedSearchesViewController, mainViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	savedSearchesViewController = [[SavedSearchesViewController alloc] initWithNibName:@"SavedSearchesView" bundle:nil];
    
    mainViewController = [[MainViewController alloc] initWithNibName:@"MainView" bundle:nil];
	
    savedSearchesViewController.mainViewController = mainViewController;
    
	// setup a split view with saved searches on the left side and the main view on the right side
    splitViewController = [[UISplitViewController alloc] init];
    splitViewController.viewControllers = [NSArray arrayWithObjects:savedSearchesViewController, mainViewController, nil];
	splitViewController.delegate = mainViewController;
    
    // Add the split view controller's view to the window and display.
    [window addSubview:splitViewController.view];
    [window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Save data if appropriate
}

- (void)dealloc {
    [splitViewController release];
    [window release];
    [super dealloc];
}

@end

