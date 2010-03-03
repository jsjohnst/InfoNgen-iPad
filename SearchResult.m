//
//  SearchResult.m
//  InfoNgen-Basic
//
//  Created by Robert Stewart on 2/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SearchResult.h"


@implementation SearchResult
@synthesize headline,url,synopsis,date,notes,image;

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

-(NSString *)relativeDateOffset 
{
    NSDate *todayDate = [NSDate date];
    double ti = [self.date timeIntervalSinceDate:todayDate];
    ti = ti * -1;
    if(ti < 0) {
        return @"too small";
    } else      if (ti < 60) {
        return @"less than a minute ago";
    } else if (ti < 3600) {
        int diff = round(ti / 60);
        return [NSString stringWithFormat:@"%d minutes ago", diff];
    } else if (ti < 86400) {
        int diff = round(ti / 60 / 60);
        return[NSString stringWithFormat:@"%d hours ago", diff];
    } else if (ti < 2629743) {
        int diff = round(ti / 60 / 60 / 24);
        return[NSString stringWithFormat:@"%d days ago", diff];
    } else {
        return @"too big";
    }   
}

- (void)encodeWithCoder:(NSCoder*)encoder
{
	[encoder encodeObject:headline forKey:@"headline"];
	[encoder encodeObject:synopsis forKey:@"synopsis"];
	[encoder encodeObject:url forKey:@"url"];
	[encoder encodeObject:date forKey:@"date"];	
	[encoder encodeObject:image forKey:@"image"];
	[encoder encodeObject:notes	forKey:@"notes"];
}

- (id)initWithCoder:(NSCoder*)decoder
{
	if(self==[super init])
	{
		self.headline=[decoder decodeObjectForKey:@"headline"];
		self.synopsis=[decoder decodeObjectForKey:@"synopsis"];
		self.url=[decoder decodeObjectForKey:@"url"];
		self.date=[decoder decodeObjectForKey:@"date"];
		self.image=[decoder decodeObjectForKey:@"image"];
		self.notes=[decoder decodeObjectForKey:@"notes"];
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
	copy.notes=[self.notes copy];
	copy.image=[self.image copy];
	
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
	[notes release];
	[image release];
	
	[super dealloc];
}
@end
