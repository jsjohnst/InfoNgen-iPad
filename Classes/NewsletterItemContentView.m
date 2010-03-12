//
//  NewsletterItemCell.m
//  Untitled
//
//  Created by Robert Stewart on 3/12/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import "NewsletterItemContentView.h"
#import "SearchResult.h"

@implementation NewsletterItemContentView
@synthesize searchResult;


- (id)initWithFrame:(CGRect)frame {
	
	if (self = [super initWithFrame:frame]) {
	
		self.opaque = YES;
		self.backgroundColor = [UIColor whiteColor];
	}
	return self;
}


+ (int) findBestFit:(NSString*)text constraint:(CGSize)constraint
{
	int i=[text length] -1;
	
	UIFont * font=[UIFont systemFontOfSize:kFontSize];
	
	while(i>0)
	{
		unichar c=[text characterAtIndex:i--];
		
		if(c==' ' || c=='\n')
		{
			CGSize size = [[text substringToIndex:i] sizeWithFont:font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
		
			if(size.height <= constraint.height)
			{
				break;
			}
		}
	}
	
	return i;
	
}

+(CGFloat) heightForCell:(SearchResult *)searchResult;
{
	UIImage * image=searchResult.image;
	NSString * synopsis=searchResult.synopsis;
	
	UIFont * font=[UIFont systemFontOfSize:kFontSize];
	CGSize size;
	
	if(image)
	{
		CGFloat minHeight=image.size.height + (kCellPadding*2);
		
		CGSize constraint = CGSizeMake(kCellWidth - image.size.width  -  (kCellPadding * 3), 20000.0f);
		
		size = [synopsis sizeWithFont:font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
		
		if(size.height > image.size.height)
		{
			int i=[NewsletterItemContentView findBestFit:synopsis constraint:CGSizeMake(kCellWidth-image.size.width - (kCellPadding*3), image.size.height)];
			
			if(i>0)
			{
				NSString * second_part=[synopsis substringFromIndex:i+1];
				
				size=[second_part sizeWithFont:font constrainedToSize:CGSizeMake(kCellWidth - (kCellPadding*2), 20000.0f) lineBreakMode:UILineBreakModeWordWrap];
				
				minHeight+=kCellPadding + size.height;
				
				return minHeight;
			}
		}
		else 
		{
			return minHeight;
		}
	}
	else {
		if (synopsis) {
			size=[synopsis sizeWithFont:font constrainedToSize:CGSizeMake(kCellWidth - (kCellPadding*2), 20000.0f) lineBreakMode:UILineBreakModeWordWrap];
			return (kCellPadding*2) + size.height;
		}
	} 
		
	return 44;
}

- (void)drawRect:(CGRect)rect
{
	UIImage * image=searchResult.image;
	NSString * synopsis=searchResult.synopsis;
		
	UIFont * font=[UIFont systemFontOfSize:kFontSize];
	CGSize size;
	
	if (image) 
	{
	
		[image drawInRect:CGRectMake(kCellPadding	, kCellPadding, image.size.width, image.size.height)];
		
		// draw synopsis
		if(synopsis)
		{
			if(image.size.width < kCellWidth * 0.67)
			{
				CGSize constraint = CGSizeMake(kCellWidth - image.size.width  -  (kCellPadding * 3), 20000.0f);
				
				size = [synopsis sizeWithFont:font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
				
				if(size.height > image.size.height)
				{
					int i=[NewsletterItemContentView findBestFit:synopsis constraint:CGSizeMake(kCellWidth-image.size.width - (kCellPadding*3), image.size.height)];
					
					if(i>0)
					{
						NSString * first_part=[synopsis substringToIndex:i];
						
						[first_part drawInRect:CGRectMake((kCellPadding*2)+image.size.width, kCellPadding, size.width, image.size.height) withFont:font lineBreakMode:UILineBreakModeWordWrap];
						
						NSString * second_part=[synopsis substringFromIndex:i+1];
						
						size=[second_part sizeWithFont:font constrainedToSize:CGSizeMake(kCellWidth - (kCellPadding*2), 20000.0f) lineBreakMode:UILineBreakModeWordWrap];
						
						[second_part drawInRect:CGRectMake(kCellPadding, (kCellPadding*2)+image.size.height, size.width, size.height) withFont:font lineBreakMode:UILineBreakModeWordWrap];
					}
				}
				else 
				{
					// it fits next to image
					
					[synopsis drawInRect:CGRectMake((kCellPadding*2)+image.size.width, kCellPadding, size.width, size.height) withFont:font  lineBreakMode:UILineBreakModeWordWrap];
				}
			}
		}
	}
	else 
	{
		// draw synopsis
		if(synopsis)
		{
			size=[synopsis sizeWithFont:font constrainedToSize:CGSizeMake(kCellWidth - (kCellPadding*2), 20000.0f) lineBreakMode:UILineBreakModeWordWrap];
			
			[synopsis drawInRect:CGRectMake(kCellPadding, kCellPadding, size.width, size.height) withFont:font  lineBreakMode:UILineBreakModeWordWrap];
			
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

 

- (void)dealloc {
	[searchResult release];
    [super dealloc];
}

@end
