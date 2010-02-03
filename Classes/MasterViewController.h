//
//  MasterViewController.h
//  Untitled
//
//  Created by Robert Stewart on 2/2/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UIViewController {
    DetailViewController *detailViewController;
	IBOutlet UINavigationController *savedSearchNavController;
}
@property (nonatomic,retain) IBOutlet UINavigationController *savedSearchNavController;
@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;
@end
