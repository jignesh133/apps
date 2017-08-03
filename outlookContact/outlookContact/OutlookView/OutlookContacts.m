//
//  OutlookContacts.m
//  googleData
//
//  Created by OWNER on 03/08/17.
//  Copyright © 2017 OWNER. All rights reserved.
//

#import "OutlookContacts.h"
#import <AFNetworking.h>

// IT WILL CREATE APP CREATED FROM CONSOLE
#define kClientId @""
#define kRedirectId @""



@implementation OutlookContacts
+(OutlookContacts *)initWithNIB{
    // INITILIAZE THE VIEW
    OutlookContacts*  view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] objectAtIndex:0];
    return view;
}
-(void)methodAuthorizatation{
    // INITIALIZE THE OBJECT
    objWebLinkedIn.delegate=self;
    objActivity.hidden=FALSE;
    [objActivity startAnimating];
    
    // URL REQUEST
    NSURL *urlRequest = [NSURL URLWithString:[NSString stringWithFormat:@"https://login.microsoftonline.com/common/oauth2/v2.0/authorize?client_id=%@&redirect_uri=%@&response_type=code&scope=openid+Contacts.ReadWrite",kClientId,kRedirectId]];
    // URL REQUEST
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:urlRequest];
    // LOAD REQUEST
    [objWebLinkedIn loadRequest:requestObj];
}

-(void)methodCancelClick:(id)sender{
    // BACK TO THE FAILLER METHODS
    if ([self.delegate respondsToSelector:@selector(methodGetDataFailler:)]) {
        [self.delegate methodGetDataFailler:nil];
    }
}

#pragma mark - UIWEBVIEW METHOD
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    // STOP ACTIVITY
    [self stopAnimator];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    // STOP ACTIVITY
    [self stopAnimator];
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    // GET THE AUTH CODE FROM LINKED IN
    [self startAnimator];
    NSURL *webUrl=request.URL;
    if ([webUrl.host isEqualToString:@"auth"]) {
        if ([webUrl.absoluteString rangeOfString:@"code"].location != NSNotFound) {
            [self methodGetAccessToken:webUrl.absoluteString];
        }
    }
    return YES;
}

-(void)methodGetAccessToken:(NSString *)code{
    
    NSString *string = code;
    NSString *match = @"code=";
    NSString *preCode,*postCode;
    
    // MAKE SCANER FOR CODE= TEXT
    NSScanner *scanner = [NSScanner scannerWithString:string];
    [scanner scanUpToString:match intoString:&preCode];
    [scanner scanString:match intoString:nil];
    
    // SCAN AND GET SUBSTRING FROM SCANNER SCAN LOCATATION
    postCode = [string substringFromIndex:scanner.scanLocation];
    
    // SET THE HEADER FOR THE GET ACCESS TOKEN
    NSDictionary *headers = @{ @"content-type": @"application/x-www-form-urlencoded",
                               @"cache-control": @"no-cache"};
    
    // SET THE CLIENT ID AND ALL PARAMAS
    NSString *strClientId = [NSString stringWithFormat:@"client_id=%@",kClientId];
    NSString *strredirect_uri  = [NSString stringWithFormat:@"&redirect_uri=%@",kRedirectId];
    NSString *strCode = [NSString stringWithFormat:@"&Code=%@",postCode];
    
    // SET THE POST DATA REQUEST
    NSMutableData *postData = [[NSMutableData alloc] initWithData:[strClientId dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[strCode dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[@"&grant_type=authorization_code" dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[strredirect_uri dataUsingEncoding:NSUTF8StringEncoding]];
    
    // CREATE MUTABLE REQUEST
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://login.microsoftonline.com/common/oauth2/v2.0/token"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    
    [objActivity startAnimating];
    objActivity.hidden=false;
    
    // GENERATE REQUEST
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [self stopAnimator];
        if (error) {
            // FAIL HANDLER
            if ([self.delegate respondsToSelector:@selector(methodGetDataFailler:)]) {
                [self.delegate methodGetDataFailler:error];
            }
        } else {
            // SUCCESS
            NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
            if (statusCode == 200) {
                
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                NSLog(@"%@", httpResponse);
                
                [self methodGetDataFromToken:responseObject];
            }
            
        }
        
    }] resume];
}

-(void)methodGetDataFromToken:(NSDictionary *)data{
    
    NSString *strHeader = [NSString stringWithFormat:@"Bearer %@",[data valueForKey:@"access_token"]];
    NSDictionary *headers = @{ @"authorization": strHeader,
                               @"content-type": @"application/json",
                               @"cache-control": @"no-cache"};
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://graph.microsoft.com/v1.0/me/contacts"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];
    [self startAnimator];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [self stopAnimator];
        if (error) {
            // FAIL HANDLER
            if ([self.delegate respondsToSelector:@selector(methodGetDataFailler:)]) {
                [self.delegate methodGetDataFailler:error];
            }
        } else {
            // SUCCESS
            NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
            if (statusCode == 200) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                NSLog(@"%@", httpResponse);
                
                if ([self.delegate respondsToSelector:@selector(methodGetDataSuccess:)]) {
                    [self.delegate methodGetDataSuccess:responseObject];
                }
            }
            
        }
        
    }] resume];
    
}
-(void)startAnimator{
    [objActivity startAnimating];
    objActivity.hidden=false;
}
-(void)stopAnimator{
    [objActivity stopAnimating];
    objActivity.hidden=true;
}
@end
