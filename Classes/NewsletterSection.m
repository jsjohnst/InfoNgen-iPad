//
//  NewsletterSection.m
//  Untitled
//
//  Created by Robert Stewart on 2/25/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import "NewsletterSection.h"


@implementation NewsletterSection
@synthesize name,savedSearchName,comment,items,lastUpdated;


- (void)encodeWithCoder:(NSCoder*)encoder
{
	[encoder encodeObject:name forKey:@"name"];
	[encoder encodeObject:savedSearchName forKey:@"savedSearchName"];
	[encoder encodeObject:comment forKey:@"comment"];
	[encoder encodeObject:items forKey:@"items"];
	[encoder encodeObject:lastUpdated forKey:@"lastUpdated"];

	
}

- (id)initWithCoder:(NSCoder*)decoder
{
	if(self==[super init])
	{
		self.name=[decoder decodeObjectForKey:@"name"];
		self.savedSearchName=[decoder decodeObjectForKey:@"savedSearchName"];
		self.comment=[decoder decodeObjectForKey:@"comment"];
		self.items=[decoder decodeObjectForKey:@"items"];
		self.lastUpdated=[decoder decodeObjectForKey:@"lastUpdated"];
		 
	}
	return self;
}

-(id)copyWithZone:(NSZone*)zone
{
	NewsletterSection * copy=[[[self class] allocWithZone:zone] init];
	copy.name=[self.name copy];
	copy.savedSearchName=[self.savedSearchName copy];
	copy.comment=[self.comment copy];
	copy.items=[self.items copy];
	copy.lastUpdated=[self.lastUpdated copy];
	 
	return copy;
}


- (void)dealloc {
	[name release];
	[savedSearchName release];
	[comment release];
	[items release];
	[lastUpdated release];
	 
    [super dealloc];
}

@end
