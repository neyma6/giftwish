//
//  ConnectionManager.m
//  Gift Wish
//
//  Created by neyma on 12/04/14.
//  Copyright (c) 2014 neyma. All rights reserved.
//

#import "ConnectionManager.h"

@interface ConnectionManager()

@property (strong, nonatomic) NSMutableData* responseData;
@property (strong, nonatomic) NSString* order;

@end

@implementation ConnectionManager

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    [self.delegate downloadCompilted:_responseData WithThisOrder:_order];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    [self.delegate errorDuringDownload:error];
}

-(void)requesWithUrl:(NSString*)url WithParameters:(NSDictionary*)parameters AndWithOrder:(NSString*)order
{
    _order = order;
    NSMutableString* requestUrl = [rootLocation mutableCopy];
    [requestUrl appendString:url];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:25.0];
    
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: jsonData];
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}



@end
