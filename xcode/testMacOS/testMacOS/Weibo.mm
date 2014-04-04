
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
    NSString *redirectURL = @"http://coffeeandsandwich.com/pinwheel/authorize.php";
    
    [weibo startUp];
    [weibo setConsumer:clientID secret:@"57663124f7eb21e1207a2ee09fed507b"];
    [weibo setAccessToken:@"2.0047eJnBwuHMpB596bbb5137sxwwOE"];

    id<AKWeiboMethodProtocol> method = [weibo getMethod];
    [method getStatusesHomeTimeline:nil pTask:nil];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:5]];
    

    
    
}

-(void)testPostStatusWithImages{

    

}


-(void)OnDelegateCompleted:(id<AKWeibo>)weibo methodOption:(NSUInteger)methodOption httpHeader:(NSString *)httpHeader result:(AKParsingObject *)result pTask:(AKUserTaskInfo *)pTask{

    [[NSFileManager defaultManager] createFileAtPath:@"/Users/kent/Desktop/data(NSURLConnection).json" contents:result.originData attributes:nil];
    //return;
    
    
    //[self printParsingObject:result];
    //NSDictionary *dictionary = [result getDictionaryObject];
//    NSLog(@"dictionary = %@",dictionary);
    //NSLog(@"Origin Source = %@",[result getOriginString]);
    if (methodOption == AKWBOPT_OAUTH2_ACCESS_TOKEN)
    {
        if (result.isUseable)
        {
            logined = true;
            NSString * access_token = [(NSDictionary *)[result getObject] objectForKey:@"access_token"];
            
            // Note: Must set acess token to sdk!
            NSLog(@"Access Token = %@", access_token);
            [weibo setAccessToken:access_token];
            
        }
    }
    else if (methodOption == AKWBOPT_POST_STATUSES_UPDATE)
    {
        // Send weibo successed!
        // ...
        NSLog(@"Weibo Send.");
    }
    
    else if (methodOption == AKWBOPT_GET_STATUSES_HOME_TIMELINE){
        
        
        NSLog(@"AKWBOPT_GET_STATUSES_HOME_TIMELINE");
        
        [[NSFileManager defaultManager] createFileAtPath:@"/Users/mac/Desktop/statuses.txt" contents:[result originData] attributes:nil];
    

    }


    
}

-(void)OnDelegateErrored:(id<AKWeibo>)weibo methodOption:(NSUInteger)methodOption errCode:(NSInteger)errCode subErrCode:(NSInteger)subErrCode result:(AKParsingObject *)result pTask:(AKUserTaskInfo *)pTask{
    
    // Please reference http://open.weibo.com/wiki/Help/error
    if (methodOption == AKWBOPT_OAUTH2_ACCESS_TOKEN)
    {
        if (result && result.isUseable)
        {
            
//            NSString * error_code = [result getSubStringByKey:@"error_code"];
//            NSString * request = [result getSubStringByKey:@"request"];
//            NSString * error = [result getSubStringByKey:@"error"];
            
            //[error compare:@"" options:NSCaseInsensitiveSearch]
            
//            NSLog(@"ERROR_CODE = %@\nREQUEST = %@\nERROR = %@",error_code, request, error);
        }
    }
    else if (methodOption == AKWBOPT_POST_STATUSES_UPDATE)
    {
        // Send weibo failed!
        // ...
        NSLog(@"Send weibo failed.");
    }

    

}

-(void)OnDelegateWillRelease:(id<AKWeibo>)weibo methodOption:(NSUInteger)methodOption pTask:(AKUserTaskInfo *)pTask{

    

}

@end
