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
@synthesize name,url,items,lastUpdated,ID;

- (id) init
{
	return [self initWithName:@"Unknown" withUrl:@"http://noplace.com"];
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

- (void) update
{
	if(items==nil || [items count]==0)
	{
	//[items release];
	
		
		NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy
														   timeoutInterval:90.0];
		// use FF user agent so server is ok with us...
		[request setValue: @"Mozilla/5.0 (Macintosh; U; Intel Mac OS X; en-US; rv:1.8.1.16) Gecko/20080702 Firefox/2.0.0.16" forHTTPHeaderField: @"User-Agent"];
		
		
		NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
		
		NSString * username=[defaults objectForKey:@"username"];
		NSString * password=[defaults objectForKey:@"password"];
		
		if (username!=nil && password!=nil && [username length]>0)
		{
			NSString *authString = [Base64 encode:[[NSString stringWithFormat:@"%@:%@",username,password] dataUsingEncoding:NSUTF8StringEncoding]]; 
			[request setValue:[NSString stringWithFormat:@"Basic %@", authString] forHTTPHeaderField:@"Authorization"];
		}
		
		NSData * data= [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
		
		NSDictionary *nsdict = [NSDictionary dictionaryWithObjectsAndKeys:
							  @"http://www.rixml.org/2005/3/RIXML",
							  @"rixml", 
							  nil];
		
		
		CXMLDocument *xmlParser = [[[CXMLDocument alloc] initWithData:data options:0 error:nil] autorelease];
		
		NSLog([xmlParser description]);
		
		// Set the resultNodes Array to contain an object for every instance of an  node in our RSS feed
		NSArray * itemNodes = [xmlParser nodesForXPath:@"//item" error:nil];
		
		NSMutableArray * array=[[NSMutableArray alloc] init];

		// Loop through the resultNodes to access each items actual data
		for (CXMLElement *itemNode in itemNodes) {
			NSArray * contentNodes=[itemNode nodesForXPath:@".//rixml:Synopsis" namespaceMappings:nsdict error:nil];
			
			//NSArray * contentNodes=[itemNode nodesForXPath:@"rixml:Synopsis" error:nil];
			NSString * synopsis=nil;
			
			if (contentNodes) {
				if([contentNodes count]>0)
				{
					synopsis=[[contentNodes objectAtIndex:0] stringValue];
					
				}
			}
			
			NSString * title=[[[itemNode elementsForName:@"title"] objectAtIndex:0] stringValue];
			//NSString * description=[[[itemNode elementsForName:@"description"] objectAtIndex:0] stringValue];
			NSString * link=[[[itemNode elementsForName:@"link"] objectAtIndex:0] stringValue];
			NSString * pubDate=[[[itemNode elementsForName:@"pubDate"] objectAtIndex:0] stringValue];
			
			SearchResult * result=[[SearchResult alloc] initWithHeadline:title withUrl:link withSynopsis:synopsis withDate:[NSDate date]];
			
			[array addObject:result];
			
			[result release];
			
		}
		 
		
	/*int x=0;
		
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
	}*/
	
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
	[ID release];
	[items release];
	[lastUpdated release];
	[super dealloc];
}
@end
