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

- (BOOL) didTouchRect:(UITouch*)touch rect:(CGRect)rect
{
	CGPoint loc=[touch locationInView:self];
	
	if(loc.y>=rect.origin.y && loc.y<=rect.origin.y+rect.size.height)
	{
		if(loc.x>=rect.origin.x && loc.x<=rect.origin.x+rect.size.width)
		{
			return YES;
		}
	}
	return NO;
}


- (BOOL) didTouchImage:(UITouch*)touch
{
	if(searchResult.image)
	{
		return [self didTouchRect:touch rect:_itemSize.image_rect];
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
		return ([self didTouchRect:touch rect:_itemSize.synopsis_rect1] || [self didTouchRect:touch rect:_itemSize.synopsis_rect2] );
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
		return ([self didTouchRect:touch rect:_itemSize.comments_rect]);
	}
}

- (BOOL) didTouchHeadline:(UITouch*)touch
{
	return [self didTouchRect:touch rect:_itemSize.headline_rect];
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
		holdTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(doSomething:) userInfo:event repeats:NO];
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

+(ItemSize) sizeForCell:(SearchResult *)searchResult viewMode:(BOOL)expanded rect:(CGRect)rect
{
	ItemSize itemSize;
	
	itemSize.size=CGSizeZero;
	itemSize.headline_rect=CGRectZero;
	itemSize.date_rect=CGRectZero;
	itemSize.synopsis_break=0;
	itemSize.synopsis_rect1=CGRectZero;
	itemSize.synopsis_rect2=CGRectZero;
	itemSize.comments_rect=CGRectZero;
	
	int cellWidth;
	
	if(rect.size.width>0)
	{
		cellWidth=rect.size.width;
	}
	else 
	{
		cellWidth=kCellWidth;
	}

	UIFont * font=[UIFont systemFontOfSize:kFontSize];
	
	UIImage * image=searchResult.image;
	NSString * synopsis=searchResult.synopsis;
	NSString * comments=searchResult.notes;

	itemSize.size.width=cellWidth;
	
	itemSize.headline_rect=CGRectMake(kCellPadding, kLineSpacing, cellWidth-(kCellPadding*2), kHeadlineFontSize+kLineSpacing);
	
	itemSize.date_rect=CGRectMake(kCellPadding, itemSize.headline_rect.origin.y+itemSize.headline_rect.size.height+kLineSpacing,cellWidth-(kCellPadding*2),kDateFontSize+kLineSpacing);
	
	itemSize.size.height=itemSize.date_rect.origin.y+itemSize.date_rect.size.height+kLineSpacing;
	
	itemSize.synopsis_break=0;
	
	if(expanded)
	{
		if(image)
		{
			itemSize.image_rect=CGRectMake(kCellPadding, itemSize.date_rect.origin.y+itemSize.date_rect.size.height+kCellPadding, image.size.width, image.size.height);
			
			itemSize.size.height=itemSize.image_rect.origin.y+itemSize.image_rect.size.height+kCellPadding;
			
			if(synopsis && [synopsis length]>0)
			{
				if(image.size.width < cellWidth * .67)
				{
					CGSize constraint = CGSizeMake(cellWidth - image.size.width  -  (kCellPadding * 3), 20000.0f);
					
					itemSize.synopsis_rect1=CGRectMake(itemSize.image_rect.origin.x+itemSize.image_rect.size.width+kCellPadding, itemSize.image_rect.origin.y, constraint.width, image.size.height+kFontSize);
					
					CGSize size = [synopsis sizeWithFont:font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
					
					if(size.height > image.size.height+kFontSize)
					{
						itemSize.synopsis_break=[NewsletterItemContentView findBestFit:synopsis constraint:CGSizeMake(cellWidth-image.size.width - (kCellPadding*3), image.size.height+kFontSize)];
						
						if(itemSize.synopsis_break>0)
						{
							NSString * second_part=[synopsis substringFromIndex:itemSize.synopsis_break+2];
							
							size=[second_part sizeWithFont:font constrainedToSize:CGSizeMake(cellWidth - (kCellPadding*2), 20000.0f) lineBreakMode:UILineBreakModeWordWrap];
							
							itemSize.synopsis_rect2=CGRectMake(kCellPadding, itemSize.image_rect.origin.y+itemSize.image_rect.size.height+kFontSize, cellWidth-(kCellPadding*2), size.height);

							itemSize.size.height=itemSize.synopsis_rect2.origin.y+itemSize.synopsis_rect2.size.height+kCellPadding;
						}
					}
				}
				else 
				{
					CGSize constraint = CGSizeMake(cellWidth-(kCellPadding*2), 20000.0f);
					
					CGSize size = [synopsis sizeWithFont:font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
					
					itemSize.synopsis_rect1=CGRectMake(kCellPadding,itemSize.image_rect.origin.y+itemSize.image_rect.size.height+kFontSize,cellWidth-(kCellPadding*2),size.height);
				
					itemSize.size.height=itemSize.synopsis_rect1.origin.y+itemSize.synopsis_rect1.size.height+kCellPadding;
				}
			}
		}
		else 
		{
			if(synopsis && [synopsis length]>0)
			{
				CGSize constraint = CGSizeMake(cellWidth-(kCellPadding*2), 20000.0f);
				
				CGSize size = [synopsis sizeWithFont:font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
				
				itemSize.synopsis_rect1=CGRectMake(kCellPadding,itemSize.date_rect.origin.y+itemSize.date_rect.size.height+kCellPadding,cellWidth-(kCellPadding*2),size.height);
			
				itemSize.size.height=itemSize.synopsis_rect1.origin.y+itemSize.synopsis_rect1.size.height+kCellPadding;
			}
		}
		
		if(comments && [comments length]>0)
		{
			CGSize constraint = CGSizeMake(cellWidth-(kCellPadding*4), 20000.0f);
			
			CGSize size = [comments sizeWithFont:font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
			
			itemSize.comments_rect=CGRectMake(kCellPadding *2  , itemSize.size.height+kCellPadding, cellWidth-(kCellPadding*4),size.height);
		
			itemSize.size.height=itemSize.comments_rect.origin.y+itemSize.comments_rect.size.height+(kCellPadding*2);
		}
	}
	
	return itemSize;
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
	ItemSize itemSize=[NewsletterItemContentView sizeForCell:searchResult viewMode:viewModeExpanded rect:rect];
	
	_itemSize=itemSize;
	
	UIImage * image=searchResult.image;
	NSString * synopsis=searchResult.synopsis;
	NSString * comments=searchResult.notes;
	
	UIFont * font=[UIFont systemFontOfSize:kFontSize];
	
	CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [NewsletterItemContentView colorWithHexString:@"336699"].CGColor);//336699
	
	// draw headline
	[searchResult.headline drawInRect:itemSize.headline_rect withFont:[UIFont boldSystemFontOfSize:kHeadlineFontSize] lineBreakMode:UILineBreakModeTailTruncation];
	
	CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [UIColor grayColor].CGColor);//666666
	
	// draw date
	
	NSDateFormatter *format = [[NSDateFormatter alloc] init];
	[format setDateFormat:@"MMM d, yyyy h:mm"];
	
	NSString *dateString = [NSString stringWithFormat:@"%@ %@",[format stringFromDate:searchResult.date],[searchResult relativeDateOffset]];
	
	[format release];

	[dateString drawInRect:itemSize.date_rect withFont:[UIFont systemFontOfSize:kDateFontSize] lineBreakMode:UILineBreakModeTailTruncation];
	
	if(viewModeExpanded)
	{
		CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [UIColor blackColor].CGColor);//666666
		
		if (image) 
		{
			[image drawInRect:itemSize.image_rect];
		}
		
		// draw synopsis
		if(synopsis && [synopsis length]>0)
		{
			if(itemSize.synopsis_break>0)
			{
				NSString * first_part=[synopsis substringToIndex:itemSize.synopsis_break+1];
				
				[first_part drawInRect:itemSize.synopsis_rect1 withFont:font lineBreakMode:UILineBreakModeWordWrap];
				
				NSString * second_part=[synopsis substringFromIndex:itemSize.synopsis_break+2];
				
				[second_part drawInRect:itemSize.synopsis_rect2 withFont:font lineBreakMode:UILineBreakModeWordWrap];
			}
			else
			{
				[synopsis drawInRect:itemSize.synopsis_rect1 withFont:font];
			}
		}
		
		if(comments && [comments length]>0)
		{ 
			UIImage* balloon = [[UIImage imageNamed:@"balloon.png"] stretchableImageWithLeftCapWidth:15  topCapHeight:15]; // you need to have the .png image, it's not a system one.
			
			
			CGRect rect=CGRectMake(itemSize.comments_rect.origin.x-kCellPadding, itemSize.comments_rect.origin.y-kCellPadding, itemSize.comments_rect.size.width+(kCellPadding*2), itemSize.comments_rect.size.height+(kCellPadding*2));
			
			[balloon drawInRect:rect];
			
			/*CGContextRef context = UIGraphicsGetCurrentContext();
			
			CGContextSetFillColorWithColor(context, [UIColor yellowColor].CGColor);
			
			//CGContextSetRGBFillColor(context, 0,0,0,0.75);
			
			CGFloat radius=kCellPadding;
			
			CGContextMoveToPoint(context, rect.origin.x, rect.origin.y + radius);
			
			CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + rect.size.height - radius);
			
			CGContextAddArc(context, rect.origin.x + radius, rect.origin.y + rect.size.height - radius, 
							radius, M_PI / 4, M_PI / 2, 1);
			
			CGContextAddLineToPoint(context, rect.origin.x + rect.size.width - radius, 
									rect.origin.y + rect.size.height);
			
			CGContextAddArc(context, rect.origin.x + rect.size.width - radius, 
							rect.origin.y + rect.size.height - radius, radius, M_PI / 2, 0.0f, 1);
			
			CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + radius);
			
			CGContextAddArc(context, rect.origin.x + rect.size.width - radius, rect.origin.y + radius, 
							radius, 0.0f, -M_PI / 2, 1);
			
			CGContextAddLineToPoint(context, rect.origin.x + radius, rect.origin.y);
			
			CGContextAddArc(context, rect.origin.x + radius, rect.origin.y + radius, radius, 
							-M_PI / 2, M_PI, 1);
			
			CGContextFillPath(context);
			 */
			CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(),[UIColor blackColor].CGColor); //   [NewsletterItemContentView colorWithHexString:@"b00027"].CGColor);//b00027
			
			[comments drawInRect:itemSize.comments_rect withFont:font];
		
		}
	}
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
