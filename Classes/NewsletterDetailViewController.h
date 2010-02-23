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
#define kScheduleTypeRow 0
#define kScheduleRow 1

#define kRssEnabledRow 2
#define kEmailFormatRow 3
#define kSubscribersRow 4

@class Page;

@interface NewsletterDetailViewController : UIViewController <UITextFieldDelegate> {
	IBOutlet UITableView * settingsTable;
	Page * page;
}

@property(nonatomic,retain) IBOutlet UITableView * settingsTable;
@property(nonatomic,retain) Page * page;

- (void) emailFormatChanged:(id)sender;
- (void) publishTypeChanged:(id)sender;
- (void) rssEnabledChanged:(id)sender;

@end
