//
//  SavedSearch.h
//  Untitled
//
//  Created by Robert Stewart on 2/4/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SavedSearch : NSObject <NSCoding, NSCopying>{
	NSString * name;
	NSString * url;
	NSMutableArray * items;
	NSDate * lastUpdated;
}
@property(nonatomic,retain) NSString * name;
@property(nonatomic,retain) NSString * url;
@property(retain) NSMutableArray * items;
@property(nonatomic,retain) NSDate * lastUpdated;

- (id) initWithName:(NSString *)theName withUrl:(NSString *) theUrl;

- (void) update;


@end
