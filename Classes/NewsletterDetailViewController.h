//
//  NewsletterDetailViewController.h
//  Untitled
//
//  Created by Robert Stewart on 2/22/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kTitleSection 0
#define kTitleRow 0

#define kLogoImageSection 1
#define kLogoImageRow 0

#define kPublishingSection 2
#define kScheduleRow 0
#define kRssEnabledRow 1
#define kPdfEnabledRow 2
#define kSubscribersRow 3


@interface NewsletterDetailViewController : UIViewController {
	IBOutlet UITableView * settingsTable;
}
@property(nonatomic,retain) IBOutlet UITableView * settingsTable;



@end
