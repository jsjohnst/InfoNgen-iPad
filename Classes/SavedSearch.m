//
//  SavedSearch.m
//  Untitled
//
//  Created by Robert Stewart on 2/4/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import "SavedSearch.h"
#import "SearchResult.h"

@implementation SavedSearch
@synthesize name,url,items,lastUpdated;

- (id) init
{
	return [self initWithName:@"Unknown" withUrl:@"http://noplace.com"];
}

- (id) initWithName:(NSString *)theName withUrl:(NSString *) theUrl
{
	if(![super init])
	{
		return nil;
	}
	
	self.name=theName;
	self.url=theUrl;
	self.items=[[NSArray alloc] init];
	self.lastUpdated=[[NSDate alloc] init];
	
	return self;
}

- (void) update
{
	[items release];
	NSMutableArray * array=[[NSMutableArray alloc] init];
	
	int x=0;
	// create artificial delay...
	for (int j=0; j<500000000; j++) {
		x=j*2;
	}
	
	for(int i=0;i<50;i++)
	{
		SearchResult * result=[[SearchResult alloc] initWithHeadline:@"This is the headline" withUrl:@"http://www.cnn.com" withSynopsis:@"This is the headline synopsis. It has a few sentences in it.  Here is another one." withDate:[[NSDate alloc] init]];
	
		[array addObject:result];
		
		[result release];
	}
	
	self.items=array;
	
	[array release];
	
	[lastUpdated release];
	lastUpdated=[[NSDate alloc] init];
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
