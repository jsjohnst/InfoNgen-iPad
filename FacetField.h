//
//  FacetField.h
//  InfoNgen-Basic
//
//  Created by Robert Stewart on 2/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FacetField : NSObject {
	NSString * displayName;
	NSString * fieldName;
	NSArray * values;
}
@property(nonatomic,retain) NSString * displayName;
@property(nonatomic,retain) NSString * fieldName;
@property(nonatomic,retain) NSArray * values;

@end
