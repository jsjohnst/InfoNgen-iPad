//
//  FacetValue.h
//  InfoNgen-Basic
//
//  Created by Robert Stewart on 2/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Search.h"

@interface FacetValue : NSObject {
	NSString * fieldName;
	NSString * fieldValue;
	NSString * displayName;
	NSInteger  count;
	Search * search;
}
@property(nonatomic,retain) NSString * fieldName;
@property(nonatomic,retain) NSString * fieldValue;
@property(nonatomic,retain) NSString * displayName;
@property(nonatomic) NSInteger count;
@property(nonatomic,retain) Search * search;

@end
