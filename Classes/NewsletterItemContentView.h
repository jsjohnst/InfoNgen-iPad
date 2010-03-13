//
//  NewsletterItemCell.h
//  Untitled
//
//  Created by Robert Stewart on 3/12/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SearchResult;

#define kCellWidth 700
#define kCellPadding 10
#define kFontSize 14
#define kHeadlineFontSize 16
#define kDateFontSize 14
#define kLineSpacing 4

@interface NewsletterItemContentView : UIView {
	SearchResult * searchResult;
}
@property (nonatomic,retain) SearchResult * searchResult;

+ (int) findBestFit:(NSString*)text constraint:(CGSize)constraint;

+(CGFloat) heightForCell:(SearchResult *)searchResult;
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;

@end
