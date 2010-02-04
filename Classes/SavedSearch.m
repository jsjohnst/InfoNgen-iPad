//
//  SavedSearch.m
//  Untitled
//
//  Created by Robert Stewart on 2/4/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import "SavedSearch.h"


@implementation SavedSearch
@synthesize name,url,items,lastUpdated;

- (id) init
{
	return [self initWithName:@"Unknown" withUrl:@"http://noplace.com"];
}

- (id) initWithName:(NSString *)name withUrl:(NSString *) url
{
	if(![super init])
	{
		return nil;
	}
	
	self.name=name;
	self.url=url;
	self.items=[[NSArray alloc] init];
	self.lastUpdated=[[NSDate alloc] init];
	
	return self;
}

- (void) update
{
	// TODO: get items from URL... set lastUpdated=now
}

- (void) dealloc
{
	[name release];
	[url release];
	[items release];
	[lastUpdated release];
	[super dealloc];
}
@end
