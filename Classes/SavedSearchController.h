//
//  SavedSearchController.h
//  Untitled
//
//  Created by Robert Stewart on 2/3/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SavedSearchController : UITableViewController<UITableViewDelegate,UITableViewDataSource> {
	NSArray * list;
}
@property(nonatomic,retain) NSArray *list;


@end
