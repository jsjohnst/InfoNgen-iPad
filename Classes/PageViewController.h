//
//  PageViewController.h
//  Untitled
//
//  Created by Robert Stewart on 2/18/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Page;

@interface PageViewController : UIViewController< UITableViewDelegate,UITableViewDataSource> {
	IBOutlet UITableView * pageTableView;
	Page * page;
	IBOutlet UIBarButtonItem * editMoveButton;
	IBOutlet UIBarButtonItem * editSettingsButton;
	
}
@property(nonatomic,retain) IBOutlet UITableView * pageTableView;
@property (nonatomic,retain) Page * page;
@property (nonatomic,retain) IBOutlet UIBarButtonItem * editMoveButton;
@property (nonatomic,retain) IBOutlet UIBarButtonItem * editSettingsButton;


- (void)renderPage;
- (IBAction) toggleEditPage;
- (IBAction) settings;
 

@end
