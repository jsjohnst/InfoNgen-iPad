//
//  FacetField.m
//  InfoNgen-Basic
//
//  Created by Robert Stewart on 2/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FacetField.h"


@implementation FacetField
@synthesize displayName,fieldName,values;

- (void)dealloc {
	[displayName release];
	[fieldName release];
	[values release];
	[super dealloc];
}
@end
