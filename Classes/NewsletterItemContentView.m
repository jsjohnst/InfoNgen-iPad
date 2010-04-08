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
#import <QuartzCore/QuartzCore.h>

@implementation NewsletterItemContentView
@synthesize searchResult,parentController,parentTableView,imagePickerPopover;//,holdTimer;

- (id)initWithFrame:(CGRect)frame {
	
	if (self = [super initWithFrame:frame]) {
	
		self.opaque = YES;
		self.backgroundColor = [UIColor whiteColor];
		
		imageButton=[[UIButton buttonWithType:UIButtonTypeCustom] retain];
		imageButton.frame=CGRectZero;
		imageButton.hidden=YES;
		imageButton.backgroundColor=[UIColor clearColor];
		imageButton.opaque=NO;
		[imageButton addTarget:self action:@selector(touchImage) forControlEvents:UIControlEventTouchUpInside];
		
		addImageButton=[[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
		[addImageButton setTitle:@"Add Image" forState:UIControlStateNormal];
		addImageButton.frame=CGRectZero;
		addImageButton.hidden=YES;
		[addImageButton addTarget:self action:@selector(addImage) forControlEvents:UIControlEventTouchUpInside];
		
		headlineButton=[[UIButton buttonWithType:UIButtonTypeCustom] retain];
		synopsisButton1=[[UIButton buttonWithType:UIButtonTypeCustom] retain];
		synopsisButton2=[[UIButton buttonWithType:UIButtonTypeCustom] retain];
		commentsButton=[[UIButton buttonWithType:UIButtonTypeCustom] retain];
		
		[headlineButton addTarget:self action:@selector(touchHeadline) forControlEvents:UIControlEventTouchUpInside];
		[synopsisButton1 addTarget:self action:@selector(touchSynopsis) forControlEvents:UIControlEventTouchUpInside];
		[synopsisButton2 addTarget:self action:@selector(touchSynopsis) forControlEvents:UIControlEventTouchUpInside];
		[commentsButton addTarget:self action:@selector(touchComments) forControlEvents:UIControlEventTouchUpInside];
		
		synopsisButton1.hidden=YES;
		synopsisButton2.hidden=YES;
		commentsButton.hidden=YES;
		synopsisButton1.frame=CGRectZero;
		synopsisButton2.frame=CGRectZero;
		commentsButton.frame=CGRectZero;
		
		[self addSubview:imageButton];
		[self addSubview:addImageButton];
		[self addSubview:headlineButton];
		[self addSubview:synopsisButton1];
		[self addSubview:synopsisButton2];
		[self addSubview:commentsButton];
	}
	return self;
}

- (void) touchImage
{
	UIActionSheet * actionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
	
	[actionSheet addButtonWithTitle:@"Choose Existing Image"];
	[actionSheet addButtonWithTitle:@"Delete Image"];
	
	[actionSheet showFromRect:_itemSize.image_rect inView:self animated:YES];
	
	[actionSheet release];
}

- (void) redraw
{
	NSLog(@"redraw");
	[self setNeedsDisplay];
	[self setNeedsLayout];
	[parentTableView reloadData];
}

- (void) touchSynopsis
{
	DocumentEditFormViewController *controller = [[DocumentEditFormViewController alloc] initWithNibName:@"DocumentEditFormView" bundle:nil];
	
	controller.searchResult=searchResult;
	
	controller.delegate=self;
	
	[controller setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
	[controller setModalPresentationStyle:UIModalPresentationFormSheet];
	
	[self.parentController presentModalViewController:controller animated:YES];
	
	[controller release];
}

- (void) touchHeadline
{
	if(self.searchResult.url && [self.searchResult.url length]>0)
	{
		DocumentWebViewController * docViewController=[[DocumentWebViewController alloc] initWithNibName:@"DocumentWebView" bundle:nil];
		
		docViewController.searchResult=self.searchResult;
		
		//[self.navigationController pushNavigationItem:docViewController animated:YES];
		
		UINavigationController * navController=[(AppDelegate*)[[UIApplication sharedApplication] delegate] navigationController];
		
		[navController pushViewController:docViewController animated:YES];
		
		[docViewController release];
	}
}

- (void) touchComments
{
	[self touchSynopsis];
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

- (void) addImage
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
	
	[popover presentPopoverFromRect:_itemSize.image_rect inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	
	[picker release];
	
	[popover release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex==0)
	{
		[self addImage];
				
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
	NSLog(@"NewsletterItemContentView:sizeForCell: %@",searchResult.headline);
	
	ItemSize itemSize;
	
	itemSize.size=CGSizeZero;
	itemSize.headline_rect=CGRectZero;
	itemSize.date_rect=CGRectZero;
	itemSize.synopsis_break=0;
	itemSize.synopsis_rect1=CGRectZero;
	itemSize.synopsis_rect2=CGRectZero;
	itemSize.comments_rect=CGRectZero;
	itemSize.rect=rect;
	
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
	
	NSString * fonttmp=@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
	
	CGSize fontsize=[fonttmp sizeWithFont:font constrainedToSize:CGSizeMake(20000.0, 20000.0) lineBreakMode:UILineBreakModeWordWrap];
	
	CGFloat fontHeight=fontsize.height;
	
	UIImage * image=searchResult.image;
	NSString * synopsis=searchResult.synopsis;
	NSString * comments=searchResult.notes;

	itemSize.size.width=cellWidth;
	
	// TODO: make headline_rect respect the width of the headline text so we can only touch on the headline text to go to URL
	itemSize.headline_rect=CGRectMake(kCellPadding, kLineSpacing, cellWidth-(kCellPadding*2), kHeadlineFontSize+kLineSpacing);
	
	itemSize.date_rect=CGRectMake(kCellPadding, itemSize.headline_rect.origin.y+itemSize.headline_rect.size.height+kLineSpacing,cellWidth-(kCellPadding*2),kDateFontSize+kLineSpacing);
	
	itemSize.size.height=itemSize.date_rect.origin.y+itemSize.date_rect.size.height+kLineSpacing;
	
	itemSize.synopsis_break=0;
	
	if(expanded)
	{
		if(image)
		{
			itemSize.image_rect=CGRectMake(kCellPadding, itemSize.date_rect.origin.y+itemSize.date_rect.size.height+kCellPadding, image.size.width, image.size.height);
		}
		else 
		{
			itemSize.image_rect=CGRectMake(kCellPadding, itemSize.date_rect.origin.y+itemSize.date_rect.size.height+kCellPadding, 88, 88);
		}

		itemSize.size.height=itemSize.image_rect.origin.y+itemSize.image_rect.size.height+kCellPadding;
		
		if(synopsis && [synopsis length]>0)
		{
			if(itemSize.image_rect.size.width < cellWidth * .67)
			{
				CGSize constraint = CGSizeMake(cellWidth - itemSize.image_rect.size.width  -  (kCellPadding * 3), 20000.0f);
				
				itemSize.synopsis_rect1=CGRectMake(itemSize.image_rect.origin.x+itemSize.image_rect.size.width+kCellPadding, itemSize.image_rect.origin.y, constraint.width, itemSize.image_rect.size.height+fontHeight);
				
				CGSize size = [synopsis sizeWithFont:font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
				
				if(size.height > itemSize.image_rect.size.height+fontHeight)
				{
					itemSize.synopsis_break=[NewsletterItemContentView findBestFit:synopsis constraint:CGSizeMake(cellWidth-itemSize.image_rect.size.width - (kCellPadding*3), itemSize.image_rect.size.height+fontHeight)];
					
					if(itemSize.synopsis_break>0)
					{
						NSString * first_part=[synopsis substringToIndex:itemSize.synopsis_break+1];
						
						CGSize newSize=[first_part sizeWithFont:font constrainedToSize:itemSize.synopsis_rect1.size lineBreakMode:UILineBreakModeWordWrap];
						
						// compensate for incorrect height when there are consecutive line breaks (not sure why yet...)
						if(newSize.height <= itemSize.image_rect.size.height)
						{
							newSize.height=itemSize.image_rect.size.height+1;
						}
						
						itemSize.synopsis_rect1.size.height=newSize.height;
						
						NSString * second_part=[synopsis substringFromIndex:itemSize.synopsis_break+2];
						
						size=[second_part sizeWithFont:font constrainedToSize:CGSizeMake(cellWidth - (kCellPadding*2), 20000.0f) lineBreakMode:UILineBreakModeWordWrap];
						
						itemSize.synopsis_rect2=CGRectMake(kCellPadding,  itemSize.synopsis_rect1.origin.y+itemSize.synopsis_rect1.size.height, cellWidth-(kCellPadding*2), size.height);

						itemSize.size.height=itemSize.synopsis_rect2.origin.y+itemSize.synopsis_rect2.size.height+kCellPadding;
					}
				}
			}
			else 
			{
				CGSize constraint = CGSizeMake(cellWidth-(kCellPadding*2), 20000.0f);
				
				CGSize size = [synopsis sizeWithFont:font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
				
				itemSize.synopsis_rect1=CGRectMake(kCellPadding,itemSize.image_rect.origin.y+itemSize.image_rect.size.height+fontHeight,cellWidth-(kCellPadding*2),size.height);
			
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

- (void) layoutButtons:(ItemSize) itemSize
{
	UIImage * image=searchResult.image;
	NSString * synopsis=searchResult.synopsis;
	NSString * comments=searchResult.notes;
	
	headlineButton.frame=itemSize.headline_rect;
	headlineButton.backgroundColor=[UIColor clearColor];
	headlineButton.opaque=NO;
	
	if(viewModeExpanded)
	{
		if (image) 
		{
			addImageButton.frame=CGRectZero;
			addImageButton.hidden=YES;
			imageButton.frame=itemSize.image_rect;
			imageButton.hidden=NO;
		}
		else 
		{
			imageButton.hidden=YES;
			imageButton.frame=CGRectZero;
			addImageButton.hidden=NO;
			addImageButton.frame=itemSize.image_rect;
		}
		
		// draw synopsis
		if(synopsis && [synopsis length]>0)
		{
			if(itemSize.synopsis_break>0)
			{
				synopsisButton1.hidden=NO;
				synopsisButton1.frame=itemSize.synopsis_rect1;
				synopsisButton1.backgroundColor=[UIColor clearColor];
				synopsisButton1.opaque=NO;
				synopsisButton2.hidden=NO;
				synopsisButton2.frame=itemSize.synopsis_rect2;
				synopsisButton2.backgroundColor=[UIColor clearColor];
				synopsisButton2.opaque=NO;
			}
			else
			{
				synopsisButton1.hidden=NO;
				synopsisButton1.frame=itemSize.synopsis_rect1;
				synopsisButton1.backgroundColor=[UIColor clearColor];
				synopsisButton1.opaque=NO;
				synopsisButton2.hidden=YES;
				synopsisButton2.frame=CGRectZero;
			}
		}
		
		if(comments && [comments length]>0)
		{ 
			commentsButton.hidden=NO;
			commentsButton.frame=itemSize.comments_rect;
		}
		else 
		{
			commentsButton.hidden=YES;
			commentsButton.frame=CGRectZero;
		}
	}
	else 
	{
		// hide buttons on headline view
		addImageButton.hidden=YES;
		addImageButton.frame=CGRectZero;
		imageButton.hidden=YES;
		imageButton.frame=CGRectZero;
		synopsisButton1.hidden=YES;
		synopsisButton1.frame=CGRectZero;
		synopsisButton2.hidden=YES;
		synopsisButton2.frame=CGRectZero;
		commentsButton.hidden=YES;
		commentsButton.frame=CGRectZero;
	} 
}

- (void) layoutSubviews
{
	NSLog(@"NewsletterItemContentView:layoutSubviews");
	[super layoutSubviews];
	
	CGRect rect=self.bounds;
	
	_itemSize=[NewsletterItemContentView sizeForCell:searchResult viewMode:viewModeExpanded rect:rect];
	
	[self layoutButtons:_itemSize];
}

- (void)drawRect:(CGRect)rect
{
	NSLog(@"NewsletterItemContentView:drawRect");
	
	_itemSize=[NewsletterItemContentView sizeForCell:searchResult viewMode:viewModeExpanded rect:rect];
	
	[self drawText:_itemSize];
}

- (void) drawText:(ItemSize) itemSize
{
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
			
			CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(),[UIColor blackColor].CGColor); //   [NewsletterItemContentView colorWithHexString:@"b00027"].CGColor);//b00027
			
			[comments drawInRect:itemSize.comments_rect withFont:font];
		}
	}
}

- (void)imagePickerController:(UIImagePickerController *)picker 
		didFinishPickingImage:(UIImage *)image
				  editingInfo:(NSDictionary *)editingInfo
{
	
    // Dismiss the image selection, hide the picker and
    //show the image view with the picked image
    [imagePickerPopover dismissPopoverAnimated:YES];

	searchResult.image=image;
	
	[self redraw];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    // Dismiss the image selection and close the program
    [imagePickerPopover dismissPopoverAnimated:YES];
}

- (void)dealloc {
	[searchResult release];
	[parentController release];
	[parentTableView release];
	[imagePickerPopover release];
	[headlineButton release];
	[synopsisButton1 release];
	[synopsisButton2 release];
	[commentsButton release];
	[imageButton release];
	[addImageButton release];
    [super dealloc];
}

@end
