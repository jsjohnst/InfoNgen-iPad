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
			CGSize size = [[text substringToIndex:i+1] sizeWithFont:font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
		
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
	
	CGFloat buffer=kCellPadding +kHeadlineFontSize+kDateFontSize+kLineSpacing*3+kCellPadding*2; // bottom buffer so we dont overflow during edit mode, etc.
	
	if(image)
	{
		CGFloat minHeight=image.size.height + (kCellPadding*2);
		
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
		if (synopsis) {
			size=[synopsis sizeWithFont:font constrainedToSize:CGSizeMake(kCellWidth - (kCellPadding*2), 20000.0f) lineBreakMode:UILineBreakModeWordWrap];
			return (kCellPadding*2) + size.height + buffer;
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
						
						NSLog(@"first_part=%@",first_part);
						
						NSString * second_part=[synopsis substringFromIndex:i+2];
						
						NSLog(@"second_part=%@",second_part);
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

 

- (void)dealloc {
	[searchResult release];
    [super dealloc];
}

@end
