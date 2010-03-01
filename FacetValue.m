//
//  FacetValue.m
//  InfoNgen-Basic
//
//  Created by Robert Stewart on 2/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FacetValue.h"


@implementation FacetValue
@synthesize displayName,fieldName,fieldValue,count,search;

- (void)dealloc {
	[displayName release];
	[fieldName release];
	[fieldValue release];
	//[count release];
	[search release];
	[super dealloc];
}
@end
