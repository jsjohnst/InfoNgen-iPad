//
//  DocumentImage.h
//  Untitled
//
//  Created by Robert Stewart on 2/19/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DocumentImage : NSObject {
	NSString * src;
	NSInteger width;
	NSInteger height;
	NSInteger area;
}
@property(nonatomic,retain) NSString * src;
@property(nonatomic) NSInteger width;
@property(nonatomic) NSInteger height;
@property(nonatomic) NSInteger area;

- (UIImage *) getImage;


@end
