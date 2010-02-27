//
//  Page.m
//  Untitled
//
//  Created by Robert Stewart on 2/4/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import "Newsletter.h"

@implementation Newsletter 
@synthesize name,items,distributionList,rssEnabled,emailFormat,publishType,logoImage,sections,lastUpdated,summary;

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
	self.distributionList=[[NSMutableArray alloc] init];
	self.emailFormat=@"HTML";
	self.publishType=@"Preview";
	self.lastUpdated=[NSDate date];
	self.sections=[[NSMutableArray alloc] init];
	
	return self;
}

- (void)encodeWithCoder:(NSCoder*)encoder
{
	[encoder encodeObject:name forKey:@"name"];
	[encoder encodeObject:items forKey:@"items"];
	[encoder encodeObject:distributionList forKey:@"distributionList"];
	[encoder encodeObject:logoImage forKey:@"logoImage"];
	[encoder encodeBool:rssEnabled forKey:@"rssEnabled"];
	[encoder encodeObject:emailFormat forKey:@"emailFormat"];
	[encoder encodeObject:publishType forKey:@"publishType"];
	[encoder encodeObject:sections forKey:@"sections"];
	[encoder encodeObject:lastUpdated forKey:@"lastUpdated"];
	[encoder encodeObject:summary	forKey:@"summary"];
}

- (id)initWithCoder:(NSCoder*)decoder
{
	if(self==[super init])
	{
		self.name=[decoder decodeObjectForKey:@"name"];
		self.items=[decoder decodeObjectForKey:@"items"];
		self.logoImage=[decoder decodeObjectForKey:@"logoImage"];
		self.distributionList=[decoder decodeObjectForKey:@"distributionList"];
		self.rssEnabled=[decoder decodeBoolForKey:@"rssEnabled"];
		self.emailFormat=[decoder decodeObjectForKey:@"emailFormat"];
		self.publishType=[decoder decodeObjectForKey:@"publishType"];
		self.lastUpdated=[decoder decodeObjectForKey:@"lastUpdated"];
		self.sections=[decoder	decodeObjectForKey:@"sections"];
		self.summary=[decoder decodeObjectForKey:@"summary"];
	}
	return self;
}

-(id)copyWithZone:(NSZone*)zone
{
	Newsletter * copy=[[[self class] allocWithZone:zone] init];
	copy.name=[self.name copy];
	copy.items=[self.items copy];
	copy.distributionList=[self.distributionList copy];
	copy.rssEnabled=self.rssEnabled;
	copy.emailFormat=[self.emailFormat copy];
	copy.publishType=[self.publishType copy];
	copy.logoImage=[self.logoImage copy];
	copy.sections=[self.sections copy];
	copy.lastUpdated=[self.lastUpdated copy];
	copy.summary=[self.summary copy];
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
	[distributionList release];
	[logoImage release];
	[emailFormat release];
	[publishType release];
	[sections release];
	[lastUpdated release];
	[summary release];
    [super dealloc];
}
@end
