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

#define kSummarySection 1
#define kSummaryRow 0

#define kLogoImageSection 2
#define kLogoImageRow 0

#define kPublishingSection 3
#define kScheduleTypeRow 0
#define kScheduleRow 1
#define kRssEnabledRow 2
#define kEmailFormatRow 3
#define kSubscribersRow 4

#define kSavedSearchesSection 4
#define kSavedSearchesRow 0

@class Newsletter;

@interface NewsletterSettingsViewController : UIViewController <UITextFieldDelegate,UITextViewDelegate> {
	IBOutlet UITableView * settingsTable;
	Newsletter  * newsletter ;
}

@property(nonatomic,retain) IBOutlet UITableView * settingsTable;
@property(nonatomic,retain) Newsletter  * newsletter;

- (void) emailFormatChanged:(id)sender;
- (void) publishTypeChanged:(id)sender;
- (void) rssEnabledChanged:(id)sender;

@end
