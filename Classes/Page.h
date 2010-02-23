//
//  Page.h
//  Untitled
//
//  Created by Robert Stewart on 2/4/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Page : NSObject <NSCoding, NSCopying>{
	NSString * name;
	NSMutableArray * items;
	NSMutableArray * subscribers;
	BOOL rssEnabled;
	
	NSString * emailFormat;
	NSString * publishType;
	UIImage * logoImage;
	
}
@property(nonatomic,retain) NSString * name;
@property(retain) NSMutableArray * items;
@property(nonatomic,retain) NSMutableArray * subscribers;
@property(nonatomic) BOOL rssEnabled;
@property(nonatomic,retain) NSString * emailFormat;
@property(nonatomic,retain) NSString * publishType;
@property(nonatomic,retain) UIImage * logoImage;

- (id) initWithName:(NSString *)theName;


 - (void) save;

- (void) delete;

- (void) publish;

@end
