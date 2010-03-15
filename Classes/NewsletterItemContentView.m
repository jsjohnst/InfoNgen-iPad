//
//  NewsletterItemCell.m
//  Untitled
//
//  Created by Robert Stewart on 3/12/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import "NewsletterItemContentView.h"
#import "SearchResult.h"
#import "DocumentEditFormViewController.h"
#import "AppDelegate.h"
#import "DocumentWebViewController.h"

@implementation NewsletterItemContentView
@synthesize searchResult,holdTimer,parentController,parentTableView,imagePickerPopover;


- (id)initWithFrame:(CGRect)frame {
	
	if (self = [super initWithFrame:frame]) {
	
		self.opaque = YES;
		self.backgroundColor = [UIColor whiteColor];
	}
	return self;
}


- (BOOL) didTouchImage:(UITouch*)touch
{
	if(searchResult.image)
	{
		CGPoint loc=[touch locationInView:self];
		
		int top=kCellPadding +kHeadlineFontSize+kDateFontSize+kLineSpacing*3;
		
		if(loc.y>=kCellPadding+top && loc.y <=kCellPadding+top+searchResult.image.size.height)
		{
			if(loc.x>=kCellPadding && loc.x <=kCellPadding+searchResult.image.size.width)
			{
				return YES;
			}
		}
	}
	return NO;
}

- (BOOL) didTouchSynopsis:(UITouch*)touch
{
	if ([self didTouchImage:touch]) 
	{
		return NO;
	}
	else 
	{
		CGPoint loc=[touch locationInView:self];
		if(loc.y > kCellPadding +kHeadlineFontSize+kLineSpacing+kCellPadding)
		{
			return YES;
		}
		else 
		{
			return NO;
		}
	}

}

- (BOOL) didTouchComments:(UITouch*)touch
{
	if ([self didTouchImage:touch]) 
	{
		return NO;
	}
	else 
	{
		CGPoint loc=[touch locationInView:self];
		if(loc.y > kCellPadding +kHeadlineFontSize+kLineSpacing+kCellPadding)
		{
			return YES;
		}
		else 
		{
			return NO;
		}
	}
}

- (BOOL) didTouchHeadline:(UITouch*)touch
{
	CGPoint loc=[touch locationInView:self];
	if(loc.y <= kCellPadding +kHeadlineFontSize+kLineSpacing)
	{
		return YES;
	}
	else 
	{
		return NO;
	}
}

- (void) touchesBegan:(NSSet*) touches withEvent:(UIEvent*)event
{	
	NSLog(@"touchesBegan");
	
	// where did user select? 
		// if on headline, open the target...
	
	if([event.allTouches count]==1)
	{
		if([self didTouchHeadline:[event.allTouches anyObject]])
		{
			NSLog(@"touchesBegan touched headline");
			[self doHeadlineTouch];
			return;
		}
	}
	
	if(viewModeExpanded)
	{
		holdTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(doSomething:) userInfo:event repeats:NO];
		[holdTimer retain];
	}
}

- (void) touchesMoved:(NSSet*) touches withEvent:(UIEvent*)event
{	
	NSLog(@"touchesMoved");
	if ([holdTimer isValid]) 
	{
		[holdTimer invalidate];
	}
}

- (void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{	
	NSLog(@"touchesEnded");
	
	if ([holdTimer isValid]) 
	{
		[holdTimer invalidate];
	}
}

- (void) doHeadlineTouch
{
	if(self.searchResult.url && [self.searchResult.url length]>0)
	{
		DocumentWebViewController * docViewController=[[DocumentWebViewController alloc] initWithNibName:@"DocumentWebView" bundle:nil];
		
		docViewController.searchResult=self.searchResult;
		
		UINavigationController * navController=[(AppDelegate*)[[UIApplication sharedApplication] delegate] navigationController];
	
		[navController pushViewController:docViewController animated:YES];
		
		[docViewController release];
	}
}

- (void) redraw
{
	[self setNeedsDisplay];
	[parentTableView reloadData];
}

- (void)doSomething:(NSTimer *)theTimer
{
	NSLog(@"Timer Fired");
	
	if([theTimer isValid])
	{
		UIEvent * event=(UIEvent*)theTimer.userInfo;
	
		NSSet * touches=[event allTouches];
		
		for(UITouch * touch in touches)
		{
			// what did user touch on hold on?
			
			if ([self didTouchHeadline:touch]) 
			{
				NSLog(@"Touched headline");
				[self doHeadlineTouch];
				return;
				// go to target
			}
			if ([self didTouchImage:touch]) 
			{
				NSLog(@"Touched image");
				
				// pop up image edit menu 				
				UIActionSheet * actionSheet=[[UIActionSheet alloc] initWithTitle:searchResult.headline delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
				
				[actionSheet addButtonWithTitle:@"Choose Existing Image"];
				//[actionSheet addButtonWithTitle:@"Edit Image"];
				[actionSheet addButtonWithTitle:@"Delete Image"];
			
				[actionSheet showInView:self];
				
				[actionSheet release];
				return;
				
			}
			if ([self didTouchSynopsis:touch] || [self didTouchComments:touch]) 
			{
				NSLog(@"Touched synopsis");
				
				// popup edit dialod
				DocumentEditFormViewController *controller = [[DocumentEditFormViewController alloc] initWithNibName:@"DocumentEditFormView" bundle:nil];
				
				controller.searchResult=searchResult;
				
				controller.delegate=self;
				
				[controller setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
				[controller setModalPresentationStyle:UIModalPresentationFormSheet];
				
				[self.parentController presentModalViewController:controller animated:YES];
				
				[controller release];
				return;
				
			}
			 
		}
	}
}


- (void) setViewMode:(BOOL)expanded
{
	viewModeExpanded=expanded;
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
	NSLog(@"actionSheetCancel");
	
}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
	NSLog(@"actionSheet:willDismissWithButtonIndex %d",buttonIndex);
	
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex==0)
	{
		UIImagePickerController * picker=[[UIImagePickerController alloc] init];
		
		picker.allowsEditing = YES;
		
		picker.delegate=self;
		
		if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
		{
			picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		}
		else
		{
			if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
			{
				picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
				
			}
			else
			{
				if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
				{
					picker.sourceType = UIImagePickerControllerSourceTypeCamera;
				}
				else 
				{
					return;
				}
			}
		}
		
		UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:picker];
		
		self.imagePickerPopover=popover;
		
		CGRect rect=CGRectMake(self.bounds.origin.x+(self.bounds.size.width/2)-10, self.bounds.origin.y+(self.bounds.size.height/2)-10, 20, 20);
		 
		[popover presentPopoverFromRect:rect inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	
		[picker release];
		
		[popover release];
		
		return;
	}	
	if(buttonIndex==1)
	{
		// delete image...
		self.searchResult.image=nil;
		[self redraw];
	}
}


+ (int) findBestFit:(NSString*)text constraint:(CGSize)constraint
{
	
	// replace & chars since their appears to be a BUG in sizeWithFont where it returns WRONG value if string has & in it...
	int i=[text length] -1;
	
	UIFont * font=[UIFont systemFontOfSize:kFontSize];
	
	CGSize tmp_size=CGSizeMake(constraint.width, 20000.0f);
	
	while(i>0)
	{
		unichar c=[text characterAtIndex:i--];
		
		if(c==' ' || c=='\n')
		{
			NSString * tmp=[text substringToIndex:i+1];
			CGSize size = [tmp sizeWithFont:font constrainedToSize:tmp_size lineBreakMode:UILineBreakModeWordWrap];
		
			if(size.height <= constraint.height)
			{
				break;
			}
		}
	}
	
	return i;
	
}

+(CGFloat) heightForCell:(SearchResult *)searchResult viewMode:(BOOL)expanded;
{
	UIImage * image=searchResult.image;
	NSString * synopsis=searchResult.synopsis;
	
	UIFont * font=[UIFont systemFontOfSize:kFontSize];
	CGSize size;
	
	CGFloat buffer=kCellPadding +kHeadlineFontSize+kDateFontSize+kLineSpacing*3+kCellPadding*2; // bottom buffer so we dont overflow during edit mode, etc.
	
	if(expanded)
	{
		if(image)
		{
			CGFloat minHeight=image.size.height + (kCellPadding*2);
			
			
			if(image.size.width < kCellWidth * 0.67)
			{
			
				CGSize constraint = CGSizeMake(kCellWidth - image.size.width  -  (kCellPadding * 3), 20000.0f);
				
				size = [synopsis sizeWithFont:font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
				
				if(size.height > image.size.height+kFontSize)
				{
					int i=[NewsletterItemContentView findBestFit:synopsis constraint:CGSizeMake(kCellWidth-image.size.width - (kCellPadding*3), image.size.height+kFontSize)];
					
					if(i>0)
					{
						NSString * second_part=[synopsis substringFromIndex:i+2];
						
						size=[second_part sizeWithFont:font constrainedToSize:CGSizeMake(kCellWidth - (kCellPadding*2), 20000.0f) lineBreakMode:UILineBreakModeWordWrap];
						
						minHeight+=kFontSize + size.height;
						
						return minHeight + buffer;
					}
				}
				else 
				{
					return minHeight + buffer;
				}
			}
			else {
				
				size=[synopsis sizeWithFont:font constrainedToSize:CGSizeMake(kCellWidth - (kCellPadding*2), 20000.0f) lineBreakMode:UILineBreakModeWordWrap];
				
				minHeight+=kFontSize + size.height;
				
				return minHeight + buffer;
			}

		}
		else {
			if (synopsis) {
				size=[synopsis sizeWithFont:font constrainedToSize:CGSizeMake(kCellWidth - (kCellPadding*2), 20000.0f) lineBreakMode:UILineBreakModeWordWrap];
				return (kCellPadding*2) + size.height + buffer;
			}
		} 
	}
		
	return buffer; // default empty cell height
}


+ (UIColor *) colorWithHexString: (NSString *) stringToConvert  
{  
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];  
	
    // String should be 6 or 8 characters  
    if ([cString length] < 6) return [UIColor grayColor];  
	
    // strip 0X if it appears  
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];  
	
    if ([cString length] != 6) return  [UIColor grayColor];  
	
    // Separate into r, g, b substrings  
    NSRange range;  
    range.location = 0;  
    range.length = 2;  
    NSString *rString = [cString substringWithRange:range];  
	
    range.location = 2;  
    NSString *gString = [cString substringWithRange:range];  
	
    range.location = 4;  
    NSString *bString = [cString substringWithRange:range];  
	
    // Scan values  
    unsigned int r, g, b;  
    [[NSScanner scannerWithString:rString] scanHexInt:&r];  
    [[NSScanner scannerWithString:gString] scanHexInt:&g];  
    [[NSScanner scannerWithString:bString] scanHexInt:&b];  
	
    return [UIColor colorWithRed:((float) r / 255.0f)  
                           green:((float) g / 255.0f)  
                            blue:((float) b / 255.0f)  
                           alpha:1.0f];  
} 


- (void)drawRect:(CGRect)rect
{
	//[super drawRect:rect];
	
	NSLog(@"drawRect:%@, %@",NSStringFromCGRect(rect),searchResult.headline );
	
	UIImage * image=searchResult.image;
	NSString * synopsis=searchResult.synopsis;
		
	UIFont * font=[UIFont systemFontOfSize:kFontSize];
	
	CGSize size;
	
	CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [NewsletterItemContentView colorWithHexString:@"336699"].CGColor);//    [UIColor blueColor].CGColor);//336699
	
	// draw headline
	[searchResult.headline drawInRect:CGRectMake(kCellPadding, kCellPadding, kCellWidth - (kCellPadding*2), kHeadlineFontSize+kLineSpacing) withFont:[UIFont boldSystemFontOfSize:kHeadlineFontSize] lineBreakMode:UILineBreakModeTailTruncation];
	
	CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [UIColor grayColor].CGColor);//666666
	
	// draw date
	[[searchResult.date description] drawInRect:CGRectMake(kCellPadding, kCellPadding+(kHeadlineFontSize+kLineSpacing)+kLineSpacing, kCellWidth-(kCellPadding*2), kDateFontSize+kLineSpacing) withFont:[UIFont systemFontOfSize:kDateFontSize] lineBreakMode:UILineBreakModeTailTruncation];
	
	if(viewModeExpanded)
	{
	
		int top=kCellPadding +kHeadlineFontSize+kDateFontSize+kLineSpacing*3;
		
		CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [UIColor grayColor].CGColor);//666666
		
		if (image) 
		{
		
			[image drawInRect:CGRectMake(kCellPadding	, kCellPadding+top, image.size.width, image.size.height)];
			
			// draw synopsis
			if(synopsis)
			{
				if(image.size.width < kCellWidth * 0.67)
				{
					CGSize constraint = CGSizeMake(kCellWidth - image.size.width  -  (kCellPadding * 3), 20000.0f);
					
					size = [synopsis sizeWithFont:font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
					
					if(size.height > image.size.height+kFontSize)
					{
						int i=[NewsletterItemContentView findBestFit:synopsis constraint:CGSizeMake(kCellWidth-image.size.width - (kCellPadding*3), image.size.height+kFontSize)];
						
						if(i>0)
						{
							NSString * first_part=[synopsis substringToIndex:i+1];
							
							[first_part drawInRect:CGRectMake((kCellPadding*2)+image.size.width, kCellPadding+top, size.width, image.size.height+kFontSize) withFont:font lineBreakMode:UILineBreakModeWordWrap];
							
							NSString * second_part=[synopsis substringFromIndex:i+2];
							
							size=[second_part sizeWithFont:font constrainedToSize:CGSizeMake(kCellWidth - (kCellPadding*2), 20000.0f) lineBreakMode:UILineBreakModeWordWrap];
							
							[second_part drawInRect:CGRectMake(kCellPadding, top+kCellPadding+image.size.height+ kFontSize, size.width, size.height) withFont:font lineBreakMode:UILineBreakModeWordWrap];
						}
					}
					else 
					{
						// it fits next to image
						
						[synopsis drawInRect:CGRectMake((kCellPadding*2)+image.size.width, kCellPadding+top, size.width, size.height) withFont:font  lineBreakMode:UILineBreakModeWordWrap];
					}
				}
				else
				{
					// put synopsis below the image since image is wide
					size=[synopsis sizeWithFont:font constrainedToSize:CGSizeMake(kCellWidth - (kCellPadding*2), 20000.0f) lineBreakMode:UILineBreakModeWordWrap];
					
					[synopsis drawInRect:CGRectMake(kCellPadding, top+kCellPadding+image.size.height+ kFontSize, size.width, size.height) withFont:font lineBreakMode:UILineBreakModeWordWrap];
					
				}	
			}
		}
		else 
		{
			// draw synopsis
			if(synopsis)
			{
				size=[synopsis sizeWithFont:font constrainedToSize:CGSizeMake(kCellWidth - (kCellPadding*2), 20000.0f) lineBreakMode:UILineBreakModeWordWrap];
				
				[synopsis drawInRect:CGRectMake(kCellPadding, kCellPadding+top, size.width, size.height) withFont:font  lineBreakMode:UILineBreakModeWordWrap];
				
			}
		}
	}
	
	
	// color for comments: b00027
	
	// draw row seperators
	
	// set width of line to single pixel
	/*CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 1.0);
		
	// draw seperator line on top of cell rect
	CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 1.0, 1.0, 0.8);
	CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 0, 0);
	CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), rect.size.width, 0);
	CGContextStrokePath(UIGraphicsGetCurrentContext());	
		
	// draw seperator line on bottom of cell rect in a different color
	CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.25, 0.25, 0.25, 0.8);
	CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 0, rect.size.height);
	CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), rect.size.width, rect.size.height);
	CGContextStrokePath(UIGraphicsGetCurrentContext());*/
}

- (void)imagePickerController:(UIImagePickerController *)picker 
		didFinishPickingImage:(UIImage *)image
				  editingInfo:(NSDictionary *)editingInfo
{
	
    // Dismiss the image selection, hide the picker and
    //show the image view with the picked image
    [imagePickerPopover dismissPopoverAnimated:YES];
	//[imagePickerPopover release];
	
	self.searchResult.image=image;
	
	[self redraw];
	//[self.editTable reloadData];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    // Dismiss the image selection and close the program
    //[picker dismissModalViewControllerAnimated:YES];
    [imagePickerPopover dismissPopoverAnimated:YES];
	//[imagePickerPopover release];
}

- (void)dealloc {
	[searchResult release];
	[holdTimer release];
	[parentController release];
	[parentTableView release];
	[imagePickerPopover release];
    [super dealloc];
}

@end
