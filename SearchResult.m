//
//  SearchResult.m
//  InfoNgen-Basic
//
//  Created by Robert Stewart on 2/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
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


- (void)encodeWithCoder:(NSCoder*)encoder
{
	[encoder encodeObject:headline forKey:@"headline"];
	[encoder encodeObject:synopsis forKey:@"synopsis"];
	[encoder encodeObject:url forKey:@"url"];
	[encoder encodeObject:date forKey:@"date"];	
}

- (id)initWithCoder:(NSCoder*)decoder
{
	if(self==[super init])
	{
		self.headline=[decoder decodeObjectForKey:@"headline"];
		self.synopsis=[decoder decodeObjectForKey:@"synopsis"];
		self.url=[decoder decodeObjectForKey:@"url"];
		self.date=[decoder decodeObjectForKey:@"date"];
	}
	return self;
}

-(id)copyWithZone:(NSZone*)zone
{
	SearchResult * copy=[[[self class] allocWithZone:zone] init];
	copy.headline=[self.headline copy];
	copy.synopsis=[self.synopsis copy];
	copy.url=[self.url copy];
	copy.date=[self.date copy];
	
	return copy;
}

- (NSString*) description
{
	return [NSString stringWithFormat:@"%@",headline];
}


- (void)dealloc {
	[headline release];
	[synopsis release];
	[url release];
	[date release];
	
	[super dealloc];
}
@end
