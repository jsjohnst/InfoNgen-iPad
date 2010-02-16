//
//  SearchClient.m
//  InfoNgen-Basic
//
//  Created by Robert Stewart on 2/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SearchClient.h"
#import "TouchXML.h"
#import "SearchResults.h"
#import "SearchResult.h"
#import "FacetField.h"
#import "FacetValue.h"
#import "Base64.h"

@implementation SearchClient
@synthesize serverUrl,username,password;

- (id) initWithServer:(NSString *)url  withUsername:(NSString*)theusername withPassword:(NSString*) thepassword
{
	[super init];
	
	self.serverUrl=url;
	self.username=theusername;
	self.password=thepassword;
	
	return self;
}


- (NSData *) loadDataFromURLForcingBasicAuth:(NSURL *)url  {
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy
													   timeoutInterval:90.0];
	// use FF user agent so server is ok with us...
	[request setValue: @"Mozilla/5.0 (Macintosh; U; Intel Mac OS X; en-US; rv:1.8.1.16) Gecko/20080702 Firefox/2.0.0.16" forHTTPHeaderField: @"User-Agent"];
	if (self.username!=nil && self.password!=nil && [self.username length]>0)
	{
		NSString *authString = [Base64 encode:[[NSString stringWithFormat:@"%@:%@",self.username,self.password] dataUsingEncoding:NSUTF8StringEncoding]]; 
		[request setValue:[NSString stringWithFormat:@"Basic %@", authString] forHTTPHeaderField:@"Authorization"];
	}
	return [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
}


- (SearchResults *) search:(SearchArguments *) args
{
	
	SearchResults * results=[[SearchResults alloc] init];
	
	NSString * params=[args urlParams];
	
	NSString * urlString=[NSString stringWithFormat:@"%@/search?%@",self.serverUrl,params];
	
	NSURL *url = [NSURL URLWithString: urlString];
	
	NSLog(urlString);
	
	NSData * data=[self loadDataFromURLForcingBasicAuth:url];
	
    CXMLDocument *xmlParser = [[[CXMLDocument alloc] initWithData:data options:0 error:nil] autorelease];
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	// This is required, Cocoa will try to use the current locale otherwise 
	NSLocale *enUS = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
	[formatter setLocale:enUS];
	[enUS release];
	[formatter setDateFormat:@"yyyyMMddHHmmss"]; 
	
	NSMutableArray * resultItems=[[NSMutableArray alloc] init];
	
    // Set the resultNodes Array to contain an object for every instance of an  node in our RSS feed
    NSArray * resultNodes = [xmlParser nodesForXPath:@"/SearchResults/Results/map/fields" error:nil];
	
    // Loop through the resultNodes to access each items actual data
    for (CXMLElement *fields in resultNodes) {
		
        SearchResult * result=[[SearchResult alloc] init];
		
        int counter;
		
        for(counter = 0; counter < [fields childCount]; counter++) {
			
			CXMLElement * f=(CXMLElement*)[fields childAtIndex:counter];
			
			// get field name
			NSString * name=[[f attributeForName:@"n"] stringValue];
			
			NSString * value=[[f childAtIndex:0] stringValue];
			
			if([name isEqualToString:@"subject"])
			{
				result.headline=value;
			}
			if([name isEqualToString:@"date"])
			{
				//20091121082741 = YYYYMMDDHHMMSS
				if([value length]==14)
				{
					
					result.date = [formatter dateFromString:value];  
				}
			}
			if([name isEqualToString:@"synopsis"])
			{
				result.synopsis=value;
			}
			if([name isEqualToString:@"uri"])
			{
				result.url=value;
			}
		}
		
        [resultItems addObject:result];
		
		[result release];
    }
	
	NSLog(@"Got %d results.",[resultItems count]);
	
	results.results=resultItems;
	
	[resultItems release];
	
	NSMutableArray * facetItems=[[NSMutableArray alloc] init];
	
	NSArray * facetNodes = [xmlParser nodesForXPath:@"/SearchResults/Facets/FieldFacets" error:nil];
	
    for (CXMLElement *fieldFacets in facetNodes) {
		
        FacetField * facetField=[[FacetField alloc] init];
		
		facetField.fieldName=[[fieldFacets attributeForName:@"name"] stringValue];
		// TODO: get the display name
		
		facetField.displayName=facetField.fieldName;
		
		NSArray * facetValues=[fieldFacets nodesForXPath:@"Facets/Facet" error:nil];
	
		NSMutableArray * values=[[NSMutableArray alloc] init];
		
		for (CXMLElement *facet in facetValues) {
			FacetValue * facetValue = [[FacetValue alloc ] init];
			facetValue.fieldName=facetField.fieldName;
			facetValue.fieldValue=[[facet attributeForName:@"value"] stringValue];
			// TODO: get the display name...
			facetValue.displayName=facetValue.fieldValue;
			facetValue.count=[[[facet attributeForName:@"count"] stringValue] intValue];
			Search * facetSearch=[[Search alloc] init];
			
			SearchArguments * facetArgs=[[SearchArguments alloc] init];
			
			if(args.query==nil || [args.query length]==0)
			{
				facetArgs.query=[NSString stringWithFormat:@"+(%@:%@>75)",facetValue.fieldName,facetValue.fieldValue];
			}
			else
			{
				facetArgs.query=[NSString stringWithFormat:@"+(%@) +(%@:%@>75)",args.query,facetValue.fieldName,facetValue.fieldValue];
			}
			
			NSLog(facetArgs.query);
			
			facetSearch.args=facetArgs;
			[facetArgs release];
			
			facetValue.search=facetSearch;
			
			[facetSearch release];
			
			
			[values addObject:facetValue];
			
			[facetValue release];
		}
		
		facetField.values=values;
		
		[values release];
		
        [facetItems addObject:facetField];
		
		[facetField release];
    }
	
	NSLog(@"Got %d facet items.",[facetItems count]);
	
	results.facets=facetItems;
	
	[facetItems release];
	
	[formatter release];
	//[xmlParser release];
	
	return results;
}

@end
