//
//  PagesViewController.h
//  Untitled
//
//  Created by Robert Stewart on 2/2/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NewslettersViewController : UIViewController {
	NSMutableArray * newsletters;
	IBOutlet UITableView * newslettersTable;
}
@property(nonatomic,retain) NSMutableArray * newsletters;
@property(nonatomic,retain) IBOutlet UITableView * newslettersTable;

- (IBAction) newNewsletter;


@end
