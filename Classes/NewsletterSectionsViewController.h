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
@class Newsletter ;


@interface NewsletterSectionsViewController : UIViewController {
	IBOutlet UITableView * sectionsTable;
	Newsletter * newsletter;
}
@property(nonatomic,retain) IBOutlet UITableView * sectionsTable;
@property(nonatomic,retain) Newsletter * newsletter;

- (void) edit:(id)sender;
- (void)editDone:(id)sender;

@end
