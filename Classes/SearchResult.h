//
//  SearchResult.h
//  Untitled
//
//  Created by Robert Stewart on 2/4/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/NSDate.h>

@interface SearchResult : NSObject {
	NSString * headline;
	NSString * url;
	NSString * synopsis;
	NSDate	* date;
}

@property(nonatomic,retain) NSString * headline;
@property(nonatomic,retain) NSString * url;
@property(nonatomic,retain) NSString * synopsis;
@property(nonatomic,retain) NSDate * date;

- (id) initWithHeadline:(NSString *)theHeadline withUrl:(NSString *) theUrl withSynopsis:(NSString*)theSynopsis withDate:(NSDate*)theDate;


@end
