//
//  SearchResults.m
//  InfoNgen-Basic
//
//  Created by Robert Stewart on 2/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SearchResults.h"


@implementation SearchResults
@synthesize results,facets;
 

- (void)dealloc {
	[results release];
	[facets release];
	[super dealloc];
}
@end
