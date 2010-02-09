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
	self.items=[[NSMutableArray alloc] init];
	self.lastUpdated=[[NSDate alloc] init];
	
	return self;
}

- (void)encodeWithCoder:(NSCoder*)encoder
{
	[encoder encodeObject:name forKey:@"name"];
	[encoder encodeObject:url forKey:@"url"];
	[encoder encodeObject:items forKey:@"items"];
	[encoder encodeObject:lastUpdated forKey:@"lastUpdated"];
}

- (id)initWithCoder:(NSCoder*)decoder
{
	if(self==[super init])
	{
		self.name=[decoder decodeObjectForKey:@"name"];
		self.url=[decoder decodeObjectForKey:@"url"];
		self.items=[decoder decodeObjectForKey:@"items"];
		self.lastUpdated=[decoder decodeObjectForKey:@"lastUpdated"];
	}
	return self;
}

-(id)copyWithZone:(NSZone*)zone
{
	SavedSearch * copy=[[[self class] allocWithZone:zone] init];
	copy.name=[self.name copy];
	copy.url=[self.url copy];
	copy.lastUpdated=[self.lastUpdated copy];
	copy.items=[self.items copy];
	return copy;
}

- (void) update
{
	if(items==nil || [items count]==0)
	{
	//[items release];
	
	int x=0;
		
	// create artificial delay to simulate network traffic...
	for (int j=0; j<500000000; j++) {
		x=j*2;
	}
		
	NSMutableArray * array=[[NSMutableArray alloc] init];
	
	for(int i=0;i<50;i++)
	{
		SearchResult * result=[[SearchResult alloc] initWithHeadline:@"This is the headline" withUrl:@"http://www.cnn.com" withSynopsis:@"This is the headline synopsis. It has a few sentences in it.  Here is another one." withDate:[[NSDate alloc] init]];
	
		[array addObject:result];
		
		[result release];
	}
	
	//[items release];	
	self.items=array;
	
	[array release];
	
	[lastUpdated release];
	lastUpdated=[[NSDate alloc] init];
	}
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
