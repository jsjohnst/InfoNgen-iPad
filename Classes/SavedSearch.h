//
//  SavedSearch.h
//  Untitled
//
//  Created by Robert Stewart on 2/4/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SavedSearch : NSObject {
	NSString * name;
	NSString * url;
	NSArray * items;
	NSDate * lastUpdated;
}
@property(nonatomic,retain) NSString * name;
@property(nonatomic,retain) NSString * url;
@property(nonatomic,retain) NSArray * items;
@property(nonatomic,retain) NSDate * lastUpdated;

- (void) update;


@end
