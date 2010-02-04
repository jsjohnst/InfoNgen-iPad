//
//  Page.h
//  Untitled
//
//  Created by Robert Stewart on 2/4/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Page : NSObject {
	NSString * name;
	NSArray * items;
}
@property(nonatomic,retain) NSString * name;
@property(nonatomic,retain) NSArray * items;

- (void) save;

- (void) delete;

- (void) publish;

@end
