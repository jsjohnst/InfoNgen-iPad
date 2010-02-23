//
//  Page.m
//  Untitled
//
//  Created by Robert Stewart on 2/4/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import "Page.h"

@implementation Page
@synthesize name,items,subscribers,rssEnabled,emailFormat,publishType,logoImage;

- (id) init
{
	return [self initWithName:@"Unknown"];
}

- (id) initWithName:(NSString *)theName 
{
	if(![super init])
	{
		return nil;
	}
	
	self.name=theName;
	self.items=[[NSMutableArray alloc] init];
	self.subscribers=[[NSMutableArray alloc] init];
	self.emailFormat=@"HTML";
	self.publishType=@"Preview";
	
	return self;
}

- (void)encodeWithCoder:(NSCoder*)encoder
{
	[encoder encodeObject:name forKey:@"name"];
	[encoder encodeObject:items forKey:@"items"];
	[encoder encodeObject:subscribers forKey:@"subscribers"];
	[encoder encodeObject:logoImage forKey:@"logoImage"];
	[encoder encodeBool:rssEnabled forKey:@"rssEnabled"];
	[encoder encodeObject:emailFormat forKey:@"emailFormat"];
	[encoder encodeObject:publishType forKey:@"publishType"];
}

- (id)initWithCoder:(NSCoder*)decoder
{
	if(self==[super init])
	{
		self.name=[decoder decodeObjectForKey:@"name"];
		self.items=[decoder decodeObjectForKey:@"items"];
		self.logoImage=[decoder decodeObjectForKey:@"logoImage"];
		self.subscribers=[decoder decodeObjectForKey:@"subscribers"];
		self.rssEnabled=[decoder decodeBoolForKey:@"rssEnabled"];
		self.emailFormat=[decoder decodeObjectForKey:@"emailFormat"];
		self.publishType=[decoder decodeObjectForKey:@"publishType"];
	}
	return self;
}

-(id)copyWithZone:(NSZone*)zone
{
	Page * copy=[[[self class] allocWithZone:zone] init];
	copy.name=[self.name copy];
	copy.items=[self.items copy];
	copy.subscribers=[self.subscribers copy];
	copy.rssEnabled=self.rssEnabled;
	copy.emailFormat=[self.emailFormat copy];
	copy.publishType=[self.publishType copy];
	copy.logoImage=[self.logoImage copy];
	return copy;
}

- (void) save
{
	// TODO: save this some place
}

- (void) delete
{
	// TODO: delete it from db
}

- (void) publish
{
	// TODO: ???
}

- (void)dealloc {
	[name release];
	[items release];
	[subscribers release];
	[logoImage release];
	[emailFormat release];
	[publishType release];
    [super dealloc];
}
@end
