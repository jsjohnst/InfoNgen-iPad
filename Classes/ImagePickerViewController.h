//
//  ImagePickerViewController.h
//  Untitled
//
//  Created by Robert Stewart on 2/22/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ImagePickerViewController : UIViewController {
	NSMutableArray * images;
	IBOutlet UIPickerView * pickerView;
}
@property(nonatomic,retain) NSMutableArray * images;
@property(nonatomic,retain) IBOutlet UIPickerView * pickerView;

- (IBAction) pick;
- (IBAction) cancel;
@end
