//
//  MetaTag.m
//  Untitled
//
//  Created by Robert Stewart on 4/5/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import "MetaTag.h"


@implementation MetaTag
@synthesize name,value,ticker,fieldName,fieldValue,matches,relevance;

- (void)dealloc {
	[name release];
	[value release];
	[ticker release];
	[fieldName release];
	[fieldValue release];
	[matches release];
	[super dealloc];
}
@end
