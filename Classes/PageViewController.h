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
}
@property(nonatomic,retain) IBOutlet UITableView * pageTableView;
@property (nonatomic,retain) Page * page;

- (void)renderPage;
- (IBAction) toggleEditPage;
- (IBAction) settings;

@end
