//
//  UntitledAppDelegate.m
//  Untitled
//
//  Created by Robert Stewart on 2/2/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import "UntitledAppDelegate.h"


#import "MasterViewController.h"
#import "DetailViewController.h"


@implementation UntitledAppDelegate

@synthesize window,splitViewController, masterViewController, detailViewController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after app launch    
    
    //masterViewController = [[MasterViewController alloc] initWithStyle:UITableViewStylePlain];
    
	masterViewController = [[MasterViewController alloc] initWithNibName:@"MasterView" bundle:nil];
    
	//self.savedSearchNavController=masterViewController.savedSearchNavController;
	
	
	//[masterViewController.view addSubview:masterViewController.savedSearchNavController.view];
	
	//UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
	
    detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailView" bundle:nil];
    masterViewController.detailViewController = detailViewController;
    
    splitViewController = [[UISplitViewController alloc] init];
    splitViewController.viewControllers = [NSArray arrayWithObjects:masterViewController, detailViewController, nil];
	splitViewController.delegate = detailViewController;
    
    
    // Add the split view controller's view to the window and display.
    [window addSubview:splitViewController.view];
    [window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Save data if appropriate
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [splitViewController release];
    [window release];
    [super dealloc];
}


@end

