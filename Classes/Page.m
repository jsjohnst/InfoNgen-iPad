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
