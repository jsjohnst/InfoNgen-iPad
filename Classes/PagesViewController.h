//
//  PagesViewController.h
//  Untitled
//
//  Created by Robert Stewart on 2/2/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PagesViewController : UIViewController {
	NSMutableArray * pages;
	IBOutlet UITableView * pagesTable;
}
@property(nonatomic,retain) NSMutableArray * pages;
@property(nonatomic,retain) IBOutlet UITableView * pagesTable;

- (IBAction) newPage;

@end
