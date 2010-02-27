//
//  Page.h
//  Untitled
//
//  Created by Robert Stewart on 2/4/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Newsletter  : NSObject <NSCoding, NSCopying>{
	NSString * name;
	NSMutableArray * items;
	NSMutableArray * distributionList;
	BOOL rssEnabled;
	
	NSString * emailFormat;
	NSString * publishType;
	UIImage * logoImage;
	
	NSMutableArray * sections;
	
	NSString * summary;
	
	NSDate * lastUpdated;
}
@property(nonatomic,retain) NSString * name;
@property(retain) NSMutableArray * items;
@property(nonatomic,retain) NSMutableArray * distributionList;
@property(nonatomic,retain) NSMutableArray * sections;
@property(nonatomic) BOOL rssEnabled;
@property(nonatomic,retain) NSString * emailFormat;
@property(nonatomic,retain) NSString * publishType;
@property(nonatomic,retain) UIImage * logoImage;
@property(nonatomic,retain) NSDate * lastUpdated;
@property(nonatomic,retain) NSString * summary;

- (id) initWithName:(NSString *)theName;


 - (void) save;

- (void) delete;

- (void) publish;

@end
