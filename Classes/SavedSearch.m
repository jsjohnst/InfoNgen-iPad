//
//  SavedSearch.m
//  Untitled
//
//  Created by Robert Stewart on 2/4/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import "SavedSearch.h"
#import "SearchResult.h"
#import "Base64.h"
#import "TouchXML.h"

@implementation SavedSearch
@synthesize name,url,items,username,password,lastUpdated,ID;

- (id) init
{
	return [self initWithName:@"Unknown" withID:@"id" withUrl:@"http://noplace.com"];
}

- (id) initWithName:(NSString *)theName withID:(NSString*) theID withUrl:(NSString *) theUrl
{
	if(![super init])
	{
		return nil;
	}
	
	self.name=theName;
	self.url=theUrl;
	self.ID=theID;
	self.items=[[NSMutableArray alloc] init];
	self.lastUpdated=[[NSDate alloc] init];
	
	return self;
}
/*
- (void)encodeWithCoder:(NSCoder*)encoder
{
	[encoder encodeObject:name forKey:@"name"];
	[encoder encodeObject:url forKey:@"url"];
	[encoder encodeObject:ID forKey:@"id"];
	
	[encoder encodeObject:items forKey:@"items"];
	[encoder encodeObject:lastUpdated forKey:@"lastUpdated"];
}

- (id)initWithCoder:(NSCoder*)decoder
{
	if(self==[super init])
	{
		self.name=[decoder decodeObjectForKey:@"name"];
		self.url=[decoder decodeObjectForKey:@"url"];
		self.ID=[decoder decodeObjectForKey:@"id"];
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
	copy.ID=[self.ID copy];
	copy.lastUpdated=[self.lastUpdated copy];
	copy.items=[self.items copy];
	return copy;
}
*/
- (void) update
{
	if(items==nil || [items count]==0)
	{
		NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy
														   timeoutInterval:90.0];
		// use FF user agent so server is ok with us...
		[request setValue: @"Mozilla/5.0 (Macintosh; U; Intel Mac OS X; en-US; rv:1.8.1.16) Gecko/20080702 Firefox/2.0.0.16" forHTTPHeaderField: @"User-Agent"];
		
		if (self.username!=nil && self.password!=nil && [self.username length]>0)
		{
			NSString *authString = [Base64 encode:[[NSString stringWithFormat:@"%@:%@",self.username,self.password] dataUsingEncoding:NSUTF8StringEncoding]]; 
			[request setValue:[NSString stringWithFormat:@"Basic %@", authString] forHTTPHeaderField:@"Authorization"];
		}
		
		NSData * data= [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
		
		NSDictionary *nsdict = [NSDictionary dictionaryWithObjectsAndKeys:
							  @"http://www.rixml.org/2005/3/RIXML",
							  @"rixml", 
							  nil];
		
		CXMLDocument *xmlParser = [[[CXMLDocument alloc] initWithData:data options:0 error:nil] autorelease];
		
		// Set the resultNodes Array to contain an object for every instance of an  node in our RSS feed
		NSArray * itemNodes = [xmlParser nodesForXPath:@"//item" error:nil];
		
		NSMutableArray * array=[[NSMutableArray alloc] init];

		// Loop through the resultNodes to access each items actual data
		for (CXMLElement *itemNode in itemNodes) {
			NSArray * contentNodes=[itemNode nodesForXPath:@".//rixml:Synopsis" namespaceMappings:nsdict error:nil];
			
			NSString * synopsis=nil;
			
			if (contentNodes) {
				if([contentNodes count]>0)
				{
					synopsis=[[contentNodes objectAtIndex:0] stringValue];
					
				}
			}
			
			NSString * title=[[[itemNode elementsForName:@"title"] objectAtIndex:0] stringValue];
			NSString * link=[[[itemNode elementsForName:@"link"] objectAtIndex:0] stringValue];
			//NSString * pubDate=[[[itemNode elementsForName:@"pubDate"] objectAtIndex:0] stringValue];
			
			SearchResult * result=[[SearchResult alloc] initWithHeadline:title withUrl:link withSynopsis:synopsis withDate:[NSDate date]];
			
			[array addObject:result];
			
			[result release];
			
		}
		 
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
	[ID release];
	[items release];
	[username release];
	[password release];
	[lastUpdated release];
	[super dealloc];
}
@end
