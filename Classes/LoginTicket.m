//
//  LoginTicket.m
//  Untitled
//
//  Created by Robert Stewart on 2/16/10.
//  Copyright 2010 InfoNgen. All rights reserved.
//

#import "LoginTicket.h"

@implementation LoginTicket
@synthesize ticket,delegate;

- (NSString *)urlEncodeValue:(NSString *)str
{
	return str;
	//NSString *result = (NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, NULL, CFSTR("?=&+"), kCFStringEncodingUTF8);
	//NSString *result = (NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, NULL, CFSTR(":/?#[]@!$&’()*+,;=\""), kCFStringEncodingUTF8);
	//NSString *result = (NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)str, NULL, CFSTR(":/?#[]@!$&’()*+,;=\""), kCFStringEncodingUTF8);
	//return result;
	
	//return [result autorelease];
}

- (id) initWithUsername:(NSString *)username password:(NSString *) password
{
	if(![super init])
	{
		return nil;
	}
	
	self.ticket=nil;
	
	NSURL * URL=[NSURL URLWithString:@"http://www.infongen.com/loginsm.aspx"];
	
	
	NSMutableURLRequest * request=[NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
	
	[request setHTTPMethod:@"POST"];
	
	[request addValue:@"www.infongen.com" forHTTPHeaderField:@"Host"];
	[request addValue:@"Mozilla/5.0 (Windows; U; Windows NT 5.2; en-US; rv:1.9.0.17) Gecko/2009122116 Firefox/3.0.17 (.NET CLR 3.5.30729)" forHTTPHeaderField:@"User-Agent"];
	[request addValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
	[request addValue:@"http://www.infongen.com/loginsm.aspx" forHTTPHeaderField:@"Referer"];
	[request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	
	NSString *post = [NSString stringWithFormat:@"AuthenticationErrorGuid=18fa53a074934c938c49e35dbcf62324&__VIEWSTATE=%@&btn=SignIn&userLogin=%@&userPassword=%@", 
					  [self urlEncodeValue:@"/wEPDwUJMTQ2OTM0MDA0ZGTK/OdHxdKPVviHT6StBiN8J/jusQ=="],
					  [self urlEncodeValue:username],					  
					  [self urlEncodeValue:password]
					  ];
	
	NSLog(post);
	
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
	
	[request addValue:postLength forHTTPHeaderField:@"Content-Length"];
	
	[request setHTTPBody:postData];
	
	NSURLResponse * response=NULL;
	
	NSData * data=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
	
	NSHTTPCookieStorage * cookieStorage=[NSHTTPCookieStorage sharedHTTPCookieStorage];
	
	NSArray * cookies=[cookieStorage cookiesForURL:URL];
	
	for(int i=0;i<[cookies count];i++)
	{
		NSHTTPCookie * cookie=[cookies objectAtIndex:i];
		if([cookie.name isEqualToString:@"iiAuth"])
		{
			NSLog(@"ticket=%@",cookie.value);
			
			self.ticket=cookie.value;
			break;
		}
	}
	
	if(!self.ticket)
	{
		NSLog(@"Failed to get login cookie!");
	}

	
	return self;
	
}
- (id) initAsyncWithUsername:(NSString *)username password:(NSString *) password delegate:(id)delegate
{
	if(![super init])
	{
		return nil;
	}
	
	self.delegate=delegate;
	self.ticket=nil;
	
	NSURL * URL=[NSURL URLWithString:@"http://www.infongen.com/loginsm.aspx"];
	
	//NSHTTPURLResponse * response=NULL;
	
	NSMutableURLRequest * request=[NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
	
	[request setHTTPMethod:@"POST"];
	
	[request addValue:@"www.infongen.com" forHTTPHeaderField:@"Host"];
	[request addValue:@"Mozilla/5.0 (Windows; U; Windows NT 5.2; en-US; rv:1.9.0.17) Gecko/2009122116 Firefox/3.0.17 (.NET CLR 3.5.30729)" forHTTPHeaderField:@"User-Agent"];
	[request addValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
	[request addValue:@"http://www.infongen.com/loginsm.aspx" forHTTPHeaderField:@"Referer"];
	[request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	
	NSString *post = [NSString stringWithFormat:@"AuthenticationErrorGuid=18fa53a074934c938c49e35dbcf62324&__VIEWSTATE=%@&btn=SignIn&userLogin=%@&userPassword=%@", 
					  [self urlEncodeValue:@"/wEPDwUJMTQ2OTM0MDA0ZGTK/OdHxdKPVviHT6StBiN8J/jusQ=="],
					  [self urlEncodeValue:username],					  
					  [self urlEncodeValue:password]
					  ];
	
	NSLog(post);
	
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
	
	[request addValue:postLength forHTTPHeaderField:@"Content-Length"];
	
	[request setHTTPBody:postData];
	
	
	
	
	NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	
	
	
	return self;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	NSLog(@"didReceiveResponse");
}

- (NSURLRequest *)connection:(NSURLConnection *)connection
willSendRequest:(NSURLRequest *)request redirectResponse:
(NSURLResponse *)redirectResponse {

	NSLog(@"redirectResponse");

	if(redirectResponse) {
	
		NSHTTPURLResponse *response = (NSHTTPURLResponse *)redirectResponse;       
		
		//NSDictionary * headers=[response allHeaderFields];
		
		NSLog(@"status=%d",[response statusCode]);
		
		NSArray * cookies=[NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:[NSURL URLWithString:@"http://www.infongen.com/loginsm.aspx"]];
		
		for(int i=0;i<[cookies count];i++)
		{
			NSHTTPCookie * cookie=[cookies objectAtIndex:i];
			if([cookie.name isEqualToString:@"iiAuth"])
			{
				NSLog(@"ticket=%@",cookie.value);
				int j=0;
				for(int i=0;i<1000000000;i++)
				{
					j=i+2;
				}
				self.ticket=cookie.value;
			}
		}
						   
		return nil;
	}
	else 
	{
		NSLog(@"redirectResponse is nil");
		return request;
	}
	
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
	NSLog(@"didFailWithError");
    // release the connection, and the data object
    [connection release];
    
	[self.delegate loginTicketDidFinish:self];
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	NSLog(@"didReceiveData");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    NSLog(@"connectionDidFinishLoading");
	
	
    // release the connection, and the data object
    [connection release];

	[self.delegate loginTicketDidFinish:self];

}

- (void)dealloc {
	[ticket release];
	[delegate release];
	[super dealloc];
}
@end
