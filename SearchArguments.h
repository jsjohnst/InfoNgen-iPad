//
//  SearchArguments.h
//  InfoNgen-Basic
//
//  Created by Robert Stewart on 2/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SearchArguments : NSObject {
	NSString * query;
}

@property(nonatomic,retain) NSString * query;

void appendParam(NSMutableString * params,NSString * name,NSString * value);

- (NSString *) urlParams;
- (id) initWithQuery:(NSString*)query;

@end
