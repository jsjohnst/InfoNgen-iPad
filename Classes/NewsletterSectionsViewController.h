//
//  NewsletterSectionsViewController.h
//  Untitled
//
//  Created by Robert Stewart on 2/25/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kSectionsSection 0

#define kAddSectionSection 1
@class Page;


@interface NewsletterSectionsViewController : UIViewController {
	IBOutlet UITableView * sectionsTable;
	Page * page;
}
@property(nonatomic,retain) IBOutlet UITableView * sectionsTable;
@property(nonatomic,retain) Page * page;

- (void) edit:(id)sender;
- (void)editDone:(id)sender;

@end
