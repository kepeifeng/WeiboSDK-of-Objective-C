//
//  Weibo.m
//  testMacOS
//
//  Created by Kent Peifeng Ke on 13-10-24.
//  Copyright (c) 2013年 Kent Peifeng Ke. All rights reserved.
//

#import "Weibo.h"
#import <AKWeibo.h>
#import <AKWeiboFactory.h>
#import <AppKit/AppKit.h>

@implementation Weibo{

    id<AKWeibo> weibo;
    BOOL logined;

}


- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)start{

    weibo = [AKWeiboFactory getWeibo];
    //Weibo *weiboDelegator = [[Weibo alloc]init];
    
    [weibo setDelegate:self];
    
    NSString *clientID = @"1672616342";
    NSString *redirectURL = @"http://coffeeandsandwich.com/pinwill/authorize.php";
    
    [weibo startUp];
    [weibo setConsumer:clientID secret:@"57663124f7eb21e1207a2ee09fed507b"];
    [weibo setAccessToken:@"2.0047eJnBwuHMpB596bbb5137sxwwOE"];
    
    //https://api.weibo.com/oauth2/authorize?client_id=YOUR_CLIENT_ID&response_type=code&redirect_uri=YOUR_REGISTERED_REDIRECT_URI
    //https://api.weibo.com/oauth2/access_token?client_id=YOUR_CLIENT_ID&client_secret=YOUR_CLIENT_SECRET&grant_type=authorization_code&redirect_uri=YOUR_REGISTERED_REDIRECT_URI&code=CODE

    
    //NSString *authorizeURL =[NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&response_type=code&redirect_uri=%@", clientID, redirectURL];
    //[[NSWorkspace sharedWorkspace]openURL:[NSURL URLWithString:authorizeURL]];
    
    id<AKWeiboMethodProtocol> method = [weibo getMethod];
    
    //[method oauth2Code:@"84f2dc2b14d64160dd0b39b01d572604" url:redirectURL pTask:nil];
    

    [NSThread sleepForTimeInterval:5];
    
    NSString *status = @"Never turn around as the longest road has its end. Do be cheerful for the happiest heart has its sorrow. ——再长的路都有尽头，千万不要回头；再快乐的心都有烦恼，千万不要在意";
    [method postStatusesUpdate:[status stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] var:nil pTask:nil];
    
    //[method getUsersShow:[[AKID alloc] initWithIdType:AKIDTypeID text:@"1672616342" key:nil] extend:@"" var:nil pTask:nil];
    [NSThread sleepForTimeInterval:5];
    
    [weibo stopAll];
    [weibo shutDown];
    
}


-(void)OnDelegateComplated:(id<AKWeibo>)weibo methodOption:(NSUInteger)methodOption httpHeader:(NSString *)httpHeader result:(AKParsingObject *)result pTask:(AKUserTaskInfo *)pTask{

    //[self printParsingObject:result];
    NSDictionary *dictionary = [result getDictionaryObject];
    NSLog(@"dictionary = %@",dictionary);
    //NSLog(@"Origin Source = %@",[result getOriginString]);
    if (methodOption == WBOPT_OAUTH2_ACCESS_TOKEN)
    {
        if (result.isUseable)
        {
            logined = true;
            NSString * access_token = [result getSubStringByKey:@"access_token"];
            
            // Note: Must set acess token to sdk!
            NSLog(@"Access Token = %@", access_token);
            [weibo setAccessToken:access_token];
            
        }
    }
    else if (methodOption == WBOPT_POST_STATUSES_UPDATE)
    {
        // Send weibo successed!
        // ...
        NSLog(@"Weibo Send.");
    }


    
}

-(void)OnDelegateErrored:(id<AKWeibo>)weibo methodOption:(NSUInteger)methodOption errCode:(NSInteger)errCode subErrCode:(NSInteger)subErrCode result:(AKParsingObject *)result pTask:(AKUserTaskInfo *)pTask{
    
    // Please reference http://open.weibo.com/wiki/Help/error
    if (methodOption == WBOPT_OAUTH2_ACCESS_TOKEN)
    {
        if (result && result.isUseable)
        {
            
            NSString * error_code = [result getSubStringByKey:@"error_code"];
            NSString * request = [result getSubStringByKey:@"request"];
            NSString * error = [result getSubStringByKey:@"error"];
            
            NSLog(@"ERROR_CODE = %@\nREQUEST = %@\nERROR = %@",error_code, request, error);
        }
    }
    else if (methodOption == WBOPT_POST_STATUSES_UPDATE)
    {
        // Send weibo failed!
        // ...
        NSLog(@"Send weibo failed.");
    }

    

}

-(void)OnDelegateWillRelease:(id<AKWeibo>)weibo methodOption:(NSUInteger)methodOption pTask:(AKUserTaskInfo *)pTask{

    

}

@end
