//
//  NewsletterAddSectionViewController.h
//  Untitled
//
//  Created by Robert Stewart on 2/25/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Page;

@interface NewsletterAddSectionViewController : UIViewController {
	IBOutlet UITableView * sectionsTable;
	Page * page;
	NSArray * savedSearches;
}
@property(nonatomic,retain) IBOutlet UITableView * sectionsTable;
@property(nonatomic,retain) Page * page;
@property(nonatomic,retain) NSArray * savedSearches;

@end
