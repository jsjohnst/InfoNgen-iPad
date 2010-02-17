//
//  SearchArguments.m
//  InfoNgen-Basic
//
//  Created by Robert Stewart on 2/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SearchArguments.h"


@implementation SearchArguments
@synthesize query;

- (id) initWithQuery:(NSString*)query
{
	[super init];
	
	self.query=query;
	
	return self;
}

- (void)dealloc {
	[query release];
	[super dealloc];
}

void appendParam(NSMutableString * params,NSString * name,NSString * value)
{
	if(value!=nil && [value length]>0)
	{
		if([params length]>0)
		{
			[params appendString:@"&"];
		}
		
		NSString *encodedValue = (NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)value, NULL, CFSTR(":/?#[]@!$&’()*+,;=\""), kCFStringEncodingUTF8);
		//NSString *encodedValue = (NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)value, NULL, CFSTR(":/?#[]@!$&’()*+,;=\""), kCFStringEncodingUTF8);
		
		//[params appendFormat:@"%@=%@",name,[value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		[params appendFormat:@"%@=%@",name,encodedValue]; //[value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		[encodedValue release];
	}
}



- (NSString *) urlParams
{
	NSMutableString * params=[NSMutableString string];
	
	// query
	appendParam(params,@"q",query);
							  
	// date range
	// TODO: get real dates
	appendParam(params,@"sd",@"2010-01-01");
	appendParam(params,@"ed",@"2010-03-01");
	
	// page number
	appendParam(params,@"pn",@"1");
	appendParam(params,@"ps",@"10");

	// sorting
	appendParam(params,@"sort",@"date desc");
	
	// clustering
	appendParam(params,@"cluster",@"true");
	appendParam(params,@"cluster.sort",@"EARLIEST");
	
	// facet fields
	appendParam(params,@"facet.field",@"primarycompany");
	appendParam(params,@"facet.field",@"topic");
	appendParam(params,@"facet.field",@"keyword");
	appendParam(params,@"facet.field",@"industry");
	appendParam(params,@"facet.field",@"region");
	appendParam(params,@"facet.field",@"country");
	
	// fields to return
	appendParam(params,@"fl",@"subject");
	appendParam(params,@"fl",@"date");
	appendParam(params,@"fl",@"synopsis");
	appendParam(params,@"fl",@"uri");
	// clusterid is required for clustering to work...
	appendParam(params, @"fl", @"clusterid");
	
	appendParam(params, @"fl.maxsize", @"2000");
	
	return params;
	
}

@end
