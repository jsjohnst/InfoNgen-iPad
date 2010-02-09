//
//  Page.m
//  Untitled
//
//  Created by Robert Stewart on 2/4/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import "Page.h"

@implementation Page
@synthesize name,items;

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
	
	return self;
}

- (void)encodeWithCoder:(NSCoder*)encoder
{
	[encoder encodeObject:name forKey:@"name"];
	[encoder encodeObject:items forKey:@"items"];
}

- (id)initWithCoder:(NSCoder*)decoder
{
	if(self==[super init])
	{
		self.name=[decoder decodeObjectForKey:@"name"];
		self.items=[decoder decodeObjectForKey:@"items"];
	}
	return self;
}

-(id)copyWithZone:(NSZone*)zone
{
	Page * copy=[[[self class] allocWithZone:zone] init];
	copy.name=[self.name copy];
	copy.items=[self.items copy];
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
    [super dealloc];
}
@end
