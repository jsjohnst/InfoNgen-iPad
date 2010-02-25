//
//  NewsletterSection.h
//  Untitled
//
//  Created by Robert Stewart on 2/25/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsletterSection : NSObject <NSCoding, NSCopying> {
	NSString * name;
	NSString * savedSearchName;
	NSString * comment;
	NSMutableArray * items;
}

@property(nonatomic,retain) NSString * name;
@property(nonatomic,retain) NSString * comment;
@property(nonatomic,retain) NSString * savedSearchName;
@property(nonatomic,retain) NSMutableArray * items;
@end
