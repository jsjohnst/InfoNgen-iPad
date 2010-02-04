//
//  SearchResult.m
//  Untitled
//
//  Created by Robert Stewart on 2/4/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import "SearchResult.h"


@implementation SearchResult
@synthesize headline,url,synopsis,date;

- (id) init
{
	return [self initWithHeadline:@"Unknown" withUrl:@"http://noplace.com" withSynopsis:nil withDate:[[NSDate alloc] init]];
}

- (id) initWithHeadline:(NSString *)theHeadline withUrl:(NSString *) theUrl withSynopsis:(NSString*)theSynopsis withDate:(NSDate*)theDate
{
	if(![super init])
	{
		return nil;
	}
	
	self.headline=theHeadline;
	self.synopsis=theSynopsis;
	self.url=theUrl;
	self.date=theDate;
	
	return self;
}

- (NSString*) description
{
	return [NSString stringWithFormat:@"%@",headline];
}

- (void) dealloc
{
	[headline release];
	[synopsis release];
	[url release];
	[date release];
}
@end
