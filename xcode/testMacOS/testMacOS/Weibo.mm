
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
//    [weibo setAccessToken:@"2.0047eJnBwuHMpB596bbb5137sxwwOE"];
    [weibo setAccessToken:@"2.0047eJnBwuHMpB596bbb5137sxwwOE"];

    //NSString *authorizeURL =[NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&response_type=code&redirect_uri=%@", clientID, redirectURL];
    //[[NSWorkspace sharedWorkspace]openURL:[NSURL URLWithString:authorizeURL]];
    
    id<AKWeiboMethodProtocol> method = [weibo getMethod];
    
    //[method oauth2Code:@"b337dee2e7fcaac6411e1a166d826684" url:redirectURL pTask:nil];
    

    //[NSThread sleepForTimeInterval:5];
    
    NSString *status = @"The difference between failure and success is doing a thing nearly right and doing it exactly right.";
    
    AKVariableParams *var = [AKVariableParams new];
    var.accessToken = @"2.0047eJnBwuHMpB596bbb5137sxwwOE";
    //[method postStatusesUpdate:status var:var pTask:nil];
    


//    NSURL *url=[NSURL fileURLWithPath:@"/Users/kent/Pictures/test image/focalpoint.jpg"];
    NSArray *filePathes = [[NSArray alloc ] initWithObjects:[NSURL fileURLWithPath:@"/Users/kent/Pictures/test image/kg.png"],
                           [NSURL fileURLWithPath:@"/Users/kent/Pictures/test image/focalpoint.jpg"],
                           nil];
    
    [method postStatusesUpload:@"testing image upload" filePath:filePathes var:nil pTask:nil];
    
//    [method getStatusesHomeTimeline:nil pTask:nil];
    
    //[method getUsersShow:[[AKID alloc] initWithIdType:AKIDTypeID text:@"1672616342" key:nil] extend:@"" var:nil pTask:nil];
    //[NSThread sleepForTimeInterval:5];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:5]];
    
//    [weibo stopAll];
//    [weibo shutDown];
    
    
    
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
            NSString * access_token = [result getSubStringByKey:@"access_token"];
            
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
        
        //[[NSFileManager defaultManager] createFileAtPath:@"/Users/kent/Desktop/statuses.txt" contents:[[result getOriginString] dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    
    
    }


    
}

-(void)OnDelegateErrored:(id<AKWeibo>)weibo methodOption:(NSUInteger)methodOption errCode:(NSInteger)errCode subErrCode:(NSInteger)subErrCode result:(AKParsingObject *)result pTask:(AKUserTaskInfo *)pTask{
    
    // Please reference http://open.weibo.com/wiki/Help/error
    if (methodOption == AKWBOPT_OAUTH2_ACCESS_TOKEN)
    {
        if (result && result.isUseable)
        {
            
            NSString * error_code = [result getSubStringByKey:@"error_code"];
            NSString * request = [result getSubStringByKey:@"request"];
            NSString * error = [result getSubStringByKey:@"error"];
            
            //[error compare:@"" options:NSCaseInsensitiveSearch]
            
            NSLog(@"ERROR_CODE = %@\nREQUEST = %@\nERROR = %@",error_code, request, error);
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
