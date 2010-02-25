    //
//  ImagePickerViewController.m
//  Untitled
//
//  Created by Robert Stewart on 2/22/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import "ImagePickerViewController.h"


@implementation ImagePickerViewController
 
- (void)imagePickerController:(UIImagePickerController *)picker 
		didFinishPickingImage:(UIImage *)image
				  editingInfo:(NSDictionary *)editingInfo
{
	NSLog(@"didFinishPickingImage");
	
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	 
    [super dealloc];
}


@end
