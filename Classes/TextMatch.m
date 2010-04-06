//
//  TextMatch.m
//  Untitled
//
//  Created by Robert Stewart on 4/6/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import "TextMatch.h"


@implementation TextMatch
@synthesize text,position,length,weight;

- (void)dealloc {
	[text release];
	[super dealloc];
}
@end
