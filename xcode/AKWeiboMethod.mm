//
//  AKWeiboMethod.m
//  weibosdk
//
//  Created by Kent Peifeng Ke on 13-10-18.
//
//

#import "AKWeiboMethod.h"
#include "SDKMethodImpl.hxx"
#include "IWeiboDef.hxx"
#import "AKSDKHelper.h"

using namespace weibo;

struct AKWeiboMethodOpaque{

    AKWeiboMethodOpaque(){};
    AKWeiboMethodOpaque(IWeiboMethod *object){cpp = object;};
    IWeiboMethod *cpp;

};


@implementation AKWeiboMethod{


    NSMutableDictionary *receivedDataDictionary;
}

//@synthesize delegate = _delegate;

- (id)init
{
    self = [super init];
    if (self) {
        _weiboMethod = new AKWeiboMethodOpaque();
        receivedDataDictionary = [[NSMutableDictionary alloc]init];
    }
    return self;
}

-(id)initWithObject:(void *)object{

    self = [super init];
    if (self) {
        _weiboMethod = new AKWeiboMethodOpaque((IWeiboMethod *)object);
        receivedDataDictionary = [[NSMutableDictionary alloc]init];
    }
    return self;
    
}

-(UserTaskInfo *)convertUserTaskInfo:(AKUserTaskInfo *)userTaskInfo{
    if(!userTaskInfo){
        
        return NULL;
    }
    
    UserTaskInfo *newUserTaskInfo = new UserTaskInfo();
    const char *cpUserTaskInfo = [userTaskInfo.taskId UTF8String];
    strncpy(newUserTaskInfo->mTaskId, cpUserTaskInfo, 255);
    newUserTaskInfo->mUsrData = userTaskInfo.userData;
    return newUserTaskInfo;
    //newUserTaskInfo->mTaskId = [userTaskInfo.mTaskId cStringUsingEncoding:NSUTF8StringEncoding];}
}

#pragma mark - 数据传输

-(NSMutableData *)getDataObjectForRequest:(AKWeiboRequest *)request{
    
    
    NSMutableData* newReceivedData = [receivedDataDictionary objectForKey:request.taskID];
    if(!newReceivedData){
        
        newReceivedData = [[NSMutableData alloc]init];
        [receivedDataDictionary setObject:newReceivedData forKey:request.taskID];
    }
    
    
    return newReceivedData;
    
}

-(void)removeDataObjectForRequest:(AKWeiboRequest *)request{
    
    [receivedDataDictionary removeObjectForKey:request.taskID];
}


-(AKWeiboResultCode)startRequest:(AKWeiboRequest *)request{
    
    request.accessToken = self.accessToken;
    
    //NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:paramString]];
    NSLog(@"Start Request: %@",request.URL.absoluteString);
    
    
    NSURLConnection *urlConnection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(!urlConnection){
        return AKWRC_INTERNAL_ERROR;
    }
    
    return AKWRC_OK;
    
    
    
}


-(AKWeiboRequest *)internalMakeWeiboRequest:(AKMethodAction)methodOption additionParam:(NSString *)additionParam requestFormat:(AKWeiboRequestFormat)requestFormat httpMethod:(NSString *)httpMethod pTask:(AKUserTaskInfo *)pTask{
    
    return [AKSDKHelper makeRequest:methodOption addtionParam:additionParam reqformat:requestFormat httpMethod:httpMethod appkey:self.consumerKey accessToken:self.accessToken pTask:pTask];
    
    
}

-(NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response{
    
    NSLog(@"Connection will send request.");
    return request;
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse object.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    // receivedData is an instance variable declared elsewhere.
    AKWeiboRequest *request = (AKWeiboRequest *)connection.originalRequest;
    NSMutableData *receivedData = [self getDataObjectForRequest:request];
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    NSLog(@"Receiving Data...");
    AKWeiboRequest *request = (AKWeiboRequest *)connection.originalRequest;
    NSMutableData *receivedData = [self getDataObjectForRequest:request];
    [receivedData appendData:data];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // Release the connection and the data object
    // by setting the properties (declared elsewhere)
    // to nil.  Note that a real-world app usually
    // requires the delegate to manage more than one
    // connection at a time, so these lines would
    // typically be replaced by code to iterate through
    // whatever data structures you are using.
    
    AKWeiboRequest *request = (AKWeiboRequest *)connection.originalRequest;
    //    NSMutableData *receivedData = [self getDataObjectForRequest:request];
    [self removeDataObjectForRequest:request];
    
    //theConnection = nil;
    //receivedData = nil;
    
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    
    if(self.delegate){
        
        [self.delegate OnDelegateErrored:request.option errCode:1 subErrCode:1 result:nil pTask:request.taskInfo];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a property elsewhere
    
    AKWeiboRequest *request = (AKWeiboRequest *)connection.originalRequest;
    NSMutableData *receivedData = [self getDataObjectForRequest:request];
    
    NSLog(@"Succeeded! Received %lu bytes of data",(unsigned long)[receivedData length]);
    
    //AKWeiboRequest *request = (AKWeiboRequest *)connection.originalRequest;
    
    if(self.delegate){
        
        AKParsingObject *parsingObject = [[AKParsingObject alloc]initWithData:receivedData];
        parsingObject.accessToken = request.accessToken;
        //parsingObject.originData = receivedData;
        [self.delegate OnDelegateCompleted:request.option httpHeader:nil result:parsingObject pTask:request.taskInfo];
        
    }
    
    [self removeDataObjectForRequest:request];
}


// 無論如何回傳 YES
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace{
    return YES;
}

// 不管那一種 challenge 都相信
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    
    [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
}




#pragma mark - 身份验证

-(AKWeiboResultCode)oauth2:(NSString *)userName password:(NSString *)password task:(AKUserTaskInfo *)pTask{

    return AKWRC_UNKNOW;
    //return _weiboMethod->cpp->oauth2([userName cStringUsingEncoding:NSUTF8StringEncoding], [password cStringUsingEncoding:NSUTF8StringEncoding], (UserTaskInfo *)[pTask getCore]);

}



-(AKWeiboResultCode)oauth2Code:(NSString *)code url:(NSString *)url  pTask:(AKUserTaskInfo*) pTask{

    ////return _weiboMethod->cpp->oauth2Code([code UTF8String], [url UTF8String], (UserTaskInfo *)[pTask getCore]);
    
    if(!code){
    
        return AKWRC_USERID_NULL ;
    
    }
    
    //NSString * param;
    NSString *param;
    
    
    
    [AKSDKHelper setParam:&param paramname:@"&client_id" paramval:self.consumerKey];
	[AKSDKHelper setParam:&param paramname:@"&client_secret" paramval:self.consumerSecret];
	[AKSDKHelper setParam:&param paramname:@"&code" paramval:code];
	[AKSDKHelper setParam:&param paramname:@"&redirect_uri" paramval:url];
	[AKSDKHelper setParam:&param paramname:@"&grant_type" paramval:@"authorization_code"];
    
    AKWeiboRequest *request = [[AKWeiboRequest alloc]initWithURL:[NSURL URLWithString:@"https://api.weibo.com/oauth2/access_token"]];
    
    
    //AKWeiboRequest *request = [[AKWeiboRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"https://api.weibo.com/oauth2/access_token",param]]];
    //request.option = WBOPT_OAUTH2_ACCESS_TOKEN;
    
    request.option = AKWBOPT_OAUTH2_ACCESS_TOKEN;
    request.HTTPMethod = @"POST";
    request.HTTPBody = [[param substringFromIndex:1] dataUsingEncoding:NSUTF8StringEncoding];
    [self startRequest:request];
    
    
    //AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_OAUTH2_ACCESS_TOKEN additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    return AKWRC_OK;
    
    
}

-(AKWeiboResultCode)endSession{
    
    
    //return _weiboMethod->cpp->endSession();
    
    NSString *param;
    [AKSDKHelper setParam:&param paramname:@"&source" paramval:self.consumerKey];
    
    AKWeiboRequest *request = [self getPostRequest:AKWBOPT_END_SESSION apiURL:@"http://api.weibo.com/account/end_session" param:param];
    
    return [self startRequest:request];

}

-(AKWeiboRequest *)getPostRequest:(AKMethodAction)methodOption apiURL:(NSString *)apiURL param:(NSString *)param {

    AKWeiboRequest *request = [[AKWeiboRequest alloc]initWithURL:[NSURL URLWithString:apiURL]];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [[param substringFromIndex:1] dataUsingEncoding:NSUTF8StringEncoding];
    request.option = methodOption;
    
    return request;
    
}


#pragma mark - 微博读取
// 微博读取
-(AKWeiboResultCode) getStatusesPublicTimeline:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_STATUSES_PUBLIC_TIMELINE additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
    return [self startRequest:request];
    ////return _weiboMethod->cpp->getStatusesPublicTimeline((VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getStatusesFriendTimeline:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_STATUSES_FRIENDS_TIMELINE
additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
    return [self startRequest:request];
    
    ////return _weiboMethod->cpp->getStatusesFriendTimeline((VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}


-(AKWeiboResultCode) getStatusesHomeTimeline:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{
   
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_STATUSES_HOME_TIMELINE additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
    return [self startRequest:request];
    
    
    
/*
    NSString *apiUrl = @"https://api.weibo.com/2/statuses/home_timeline.json";
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:@"2.0047eJnBwuHMpB596bbb5137sxwwOE" forKey:@"access_token"];
    
    NSString *paramString = [NSString stringWithFormat:@"%@?%@=%@",apiUrl,@"access_token",[params objectForKey:@"access_token"]];
    
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:paramString]];
    receivedData = [[NSMutableData alloc]init];
    NSURLConnection *urlConnection = [[NSURLConnection alloc]initWithRequest:request delegate:self];

    if(!urlConnection){
    
        receivedData = nil;
    }
    
    
    return 0;
*/
    return 0;
}







-(AKWeiboResultCode) getStatusesUserTimeline:(AKID *)usrId  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    
    NSString *param;
    [AKSDKHelper makeIDParams:&param length:1024 userID:usrId];
    [AKSDKHelper makeVariableParams:&param length:1024 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_STATUSES_USER_TIMELINE additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
    return [self startRequest:request];
    
    ////return _weiboMethod->cpp->getStatusesUserTimeline(*((weibo::ID *)[usrId getCore]),(VariableParams *)[var getCore],[self convertUserTaskInfo:pTask]);

}

-(AKWeiboResultCode) getStatusesTimelineBatch:(AKID *)usrId  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    
    NSString *param;
    [AKSDKHelper makeIDParams:&param length:1024 userID:usrId];
    [AKSDKHelper makeVariableParams:&param length:1024 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_STATUSES_TIMELINE_BATCH additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
    return [self startRequest:request];
    
    
    ////return _weiboMethod->cpp->getStatusesTimelineBatch((*(weibo::ID *)[usrId getCore]),(VariableParams *)[var getCore],[self convertUserTaskInfo:pTask]);
}

-(AKWeiboResultCode) getStatusesRepostTimeline:(NSString *)aID  var: (AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{
    
    if(!aID){
    
        return AKWRC_USERID_NULL;
    
    }
    
    NSString *param;
    [AKSDKHelper setParam:&param paramname:@"&id" paramval:aID];
    [AKSDKHelper makeVariableParams:&param length:255 var:var];

    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_STATUSES_REPOST_TIMELINE additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
    return [self startRequest:request];
    
    ////return _weiboMethod->cpp->getStatusesRepostTimeline([aID UTF8String],(VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getStatusesRepostByMe:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_STATUSES_REPOST_BYME additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
    return [self startRequest:request];
    
    ////return _weiboMethod->cpp->getStatusesRepostByMe((VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getStatusesMentions:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_STATUSES_MENTIONS additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
    return [self startRequest:request];
    
    ////return _weiboMethod->cpp->getStatusesMentions((VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getStatusesShow:(NSString *)aID  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    if(!aID){
        
        return AKWRC_USERID_NULL;
        
    }
    
    NSString *param;
    [AKSDKHelper setParam:&param paramname:@"&id" paramval:aID];
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_STATUSES_SHOW additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
    return [self startRequest:request];
    
    ////return _weiboMethod->cpp->getStatusesShow([aID UTF8String],(VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getStatusesShowBatch:(NSString *)inputIDs  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    if(!inputIDs){
        
        return AKWRC_WEIBOID_NULL;
        
    }
    
    NSString *param;
    [AKSDKHelper setParam:&param paramname:@"&ids" paramval:inputIDs];
    [AKSDKHelper makeVariableParams:&param length:1024 var:var];
    
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_STATUSES_REPOST_TIMELINE additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
    return [self startRequest:request];
    
    ////return _weiboMethod->cpp->getStatusesShowBatch([inputIDs UTF8String],(VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);
}

-(AKWeiboResultCode) getStatusesQueryMID:(NSString *) weiboId    type:(NSInteger)type  is_batch:(NSInteger) is_batch  pTask:(AKUserTaskInfo *) pTask{

    if (!weiboId)
	{
		return AKWRC_WEIBOID_NULL;
	}
    
	NSString * param;
    
	[AKSDKHelper setParam:&param paramname:@"&id" paramval:weiboId];

	[AKSDKHelper setIntParam:&param paramName:@"&type" paramval:type];
	[AKSDKHelper setIntParam:&param paramName:@"&is_batch" paramval:is_batch];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_STATUSES_QUERYMID additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    ////return _weiboMethod->cpp->getStatusesQueryMID([weiboId UTF8String], (int)type, (int)is_batch, (UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getStatusesQueryID:(NSString *) mId type:(NSInteger)type  is_batch:(NSInteger) is_batch  inbox:(NSInteger) inbox  isBase62:(NSInteger) isBase62  pTask:(AKUserTaskInfo *) pTask{

	if (!mId)
	{
		return AKWRC_WEIBOID_NULL;
	}
    
	NSString * param;
    
	[AKSDKHelper setParam:&param paramname:@"&mid" paramval:mId];

	[AKSDKHelper setIntParam:&param paramName:@"&type"      paramval:type];
	[AKSDKHelper setIntParam:&param paramName:@"&is_batch"  paramval:is_batch];
	[AKSDKHelper setIntParam:&param paramName:@"&inbox"     paramval:inbox];
	[AKSDKHelper setIntParam:&param paramName:@"&isBase62"  paramval:isBase62];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_STATUSES_QUERYID additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    ////return _weiboMethod->cpp->getStatusesQueryID([mId UTF8String], (int)type, (int)is_batch, (int)inbox, (int)isBase62, (UserTaskInfo *)[pTask getCore]);
}

-(AKWeiboResultCode) getStatusesRepostDaily:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

	NSString * param;
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_STATUSES_REPOST_DAILY additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    ////return _weiboMethod->cpp->getStatusesRepostDaily((VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getStatusesRepostWeekly:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

	NSString * param;
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_STATUSES_REPOST_WEEKLY additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    ////return _weiboMethod->cpp->getStatusesRepostWeekly((VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getStatusesHotCommmentsDaily:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    NSString * param;
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_STATUSES_HOT_COMMENTS_DAILY additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    ////return _weiboMethod->cpp->getStatusesHotCommmentsDaily((VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getStatusesHotCommmentsWeekly:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{
    
    NSString * param;
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_STATUSES_HOT_COMMENTS_WEEKLY additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    ////return _weiboMethod->cpp->getStatusesHotCommmentsDaily((VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);
}


#pragma mark - 微博写入
// 微博写入
-(AKWeiboResultCode) postStatusesRepost:(NSString *) weiboId   statusText:(NSString *)statusText isComment:(NSInteger)isComment  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    if (!weiboId)
	{
		return AKWRC_WEIBOID_NULL;
	}
    
	NSString * param;
	[AKSDKHelper setParam:&param paramname:@"&id" paramval:weiboId];
	[AKSDKHelper setParam:&param paramname:@"&status" paramval:statusText];
	[AKSDKHelper setIntParam:&param paramName:@"&is_comment" paramval:isComment];
    
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_POST_STATUSES_REPOST additionParam:param requestFormat:self.unifiedFormat httpMethod:@"POST" pTask:pTask];
    
	return [self startRequest:request];
    
    ////return _weiboMethod->cpp->postStatusesRepost([weiboId UTF8String], [statusText UTF8String], (int)isComment,(VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) postStatusesDestroy:(NSString *) weiboId   var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{
    
    if (!weiboId)
	{
		return AKWRC_WEIBOID_NULL;
	}
    
	NSString * param;
	[AKSDKHelper setParam:&param paramname:@"&id" paramval:weiboId];
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_POST_STATUSES_DESTROY additionParam:param requestFormat:self.unifiedFormat httpMethod:@"POST" pTask:pTask];
    
	return [self startRequest:request];
    
    
    ////return _weiboMethod->cpp->postStatusesDestroy([weiboId UTF8String],(VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);
}

-(AKWeiboResultCode) postStatusesUpdate:(NSString *)statusText  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{
    
    if (!statusText)
	{
		return AKWRC_TEXT_NULL;
	}
    
	NSString * param;
	[AKSDKHelper setParam:&param paramname:@"&status" paramval:statusText];
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_POST_STATUSES_UPDATE additionParam:param requestFormat:self.unifiedFormat httpMethod:@"POST" pTask:pTask];
    
	return [self startRequest:request];
    
    ////return _weiboMethod->cpp->postStatusesUpdate([statusText UTF8String],(VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);
}

-(AKWeiboResultCode) postStatusesUploadUrlText:(NSString *)statusText  picInfo:(NSString *)picInfo  isPicUrl:(BOOL)isPicUrl  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    if (!statusText)
	{
		return AKWRC_TEXT_NULL;
	}
    
	NSString * param;
	[AKSDKHelper setParam:&param paramname:@"&status" paramval:statusText];
	[AKSDKHelper setParam:&param paramname:isPicUrl ? @"&url":@"&pic_id" paramval:picInfo];
	[AKSDKHelper makeVariableParams:&param length: 1024 var:var];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_POST_STATUSES_UPLOAD_URL_TEXT additionParam:param requestFormat:self.unifiedFormat httpMethod:@"POST" pTask:pTask];
    
	return [self startRequest:request];
    
    //return  _weiboMethod->cpp->postStatusesUploadUrlText([statusText UTF8String],[picInfo UTF8String], isPicUrl, (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);
}

-(AKWeiboResultCode) postStatusesUpload:(NSString *)statusText  filePath:(NSArray *)filePath  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{
    
    if (!statusText)
	{
		return AKWRC_TEXT_NULL;
	}
    
	if (!filePath)
	{
		return AKWRC_FILEPATH_NULL;
	}
    
	NSString * param;
	[AKSDKHelper setParam:&param paramname:@"&status" paramval:statusText];
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    //AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_POST_STATUSES_UPLOAD_URL_TEXT additionParam:param requestFormat:self.unifiedFormat httpMethod:@"POST" pTask:pTask];
    
//    request.timeoutInterval = 60.0;
    
    AKWeiboRequest *request = [AKWeiboRequest requestWithURL:[NSURL URLWithString: @"https://upload.api.weibo.com/2/statuses/upload.json"] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:54.0];
    
    request.option = AKWBOPT_POST_STATUSES_UPLOAD;
    request.HTTPMethod = @"POST";
    request.taskInfo = [pTask copy];
    
    NSMutableData* body = [[NSMutableData alloc] initWithData:request.HTTPBody];
    
    NSString* boundary = [self randomStringWithLength:64];
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
    NSData *boundaryData = [[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding];
    //FILES===================
    
    [filePath enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [body appendData:boundaryData];

        NSURL *fileURL = obj;
        NSString *fileExtention = [[fileURL pathExtension] lowercaseString];
        NSString *contentType;
        
        if([fileExtention isEqualToString:@"jpg"] || [fileExtention isEqualToString:@"jpeg"]){
            contentType = @"image/jpeg";
        }
        else if([fileExtention isEqualToString:@"png"]){
            contentType = @"image/png";
        }
        else if([fileExtention isEqualToString:@"gif"]){
            contentType = @"image/gif";
        }
        
        [body appendData: [[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", @"pic", [fileURL lastPathComponent]] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n",contentType] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData: [NSData dataWithContentsOfURL:obj]]; // It just return NSData with loaded file in it
        [body appendData: [@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];


    }];
    
    //FILES END===============
    [body appendData:boundaryData];
    [body appendData: [[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n", @"status", statusText] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:boundaryData];
    [body appendData: [[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n", @"access_token", self.accessToken] dataUsingEncoding:NSUTF8StringEncoding]];

    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body writeToFile:@"/Users/kent/Desktop/data(upload).txt" atomically:YES];
    
    [request setValue:[NSString stringWithFormat:@"%lu", [body length]] forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPBody:body];
    
    return [self startRequest:request];


/*
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *rdata, NSError *error){
                           
                               NSLog(@"%@",[[NSString alloc] initWithData:rdata encoding:NSUTF8StringEncoding]);
                               NSLog(@"Status with photo posted");
                           
                           }];
 */
    
    //TODO:Implement status upload.
//	//Note: Set with post form
//	WeiboRequestPtr requestPtr = internalMakeWeiboRequest(WBOPT_POST_STATUSES_UPLOAD, param, getUnifiedFormat(), httpengine::HM_POSTFORM, pTask);
//    
//	requestPtr->mPostFileField = "pic";
//	requestPtr->makeUploadTaskDetail([self getNotNullString:filePath]);
//
    //return internalEnqueue(requestPtr);
    
    ////return _weiboMethod->cpp->postStatusesUpload([statusText UTF8String],[filePath UTF8String],(VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);
    
   return 1;
    
}

- (NSString *)randomStringWithLength:(int)length
{
    
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
    
    for (int i = 0; i < length; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    
    return randomString;
}

//-(void)uploadImage
//{
//    mainImageView.image=self.entryImage; //set this just to verify that
//    //image is valid
//    NSData *imgData = UIImageJPEGRepresentation(mainImageView.image, 90);
//    NSString *urlString = @"http://mydomain.com/grap/upload.php";
//    NSURL *url = [[NSURL alloc]initWithString:urlString];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    [request setURL:[NSURL URLWithString:urlString]];
//    [request setHTTPMethod:@"POST"];
//    NSString *boundary = @"0xKhTmLbOuNdArY";
//    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary, nil];
//    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
//    NSMutableData *body = [NSMutableData data];
//    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[@"Content-Disposition: form-data; name=\"pic\"; filename=\"iphonefile.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[NSData dataWithData:imgData]];
//    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [request setHTTPBody:body];
//    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
//    NSLog(returnString);
//    
//}

#pragma mark - 评论读取
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 评论读取
-(AKWeiboResultCode) getCommentsShow:(NSString *) weiboId   var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    if (!weiboId)
	{
		return AKWRC_USERID_NULL;
	}
    
	NSString * param;
	[AKSDKHelper setParam:&param paramname:@"&id" paramval:weiboId];
	[AKSDKHelper makeVariableParams:&param length: 1024 var:var];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_COMMENTS_SHOW additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    ////return _weiboMethod->cpp->getCommentsShow([weiboId UTF8String],(VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getCommentsByMe:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    NSString * param;
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_COMMENTS_BYME additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
//    //return _weiboMethod->cpp->getCommentsByMe((VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getCommentsToMe:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    NSString * param;
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_COMMENTS_TOME additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
//    //return _weiboMethod->cpp->getCommentsToMe((VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getCommentsTimeline:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    NSString * param;
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_COMMENTS_TIMELINE additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
//    //return _weiboMethod->cpp->getCommentsTimeline((VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getCommentsMentions:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    NSString * param;
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_COMMENTS_MENTIONS additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
//    //return _weiboMethod->cpp->getCommentsMentions((VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}


#pragma mark - 评论写入
// 评论写入
-(AKWeiboResultCode) getCommentsShowBatch:(NSString *)commentIds  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    NSString * param;
	[AKSDKHelper makeVariableParams:&param length: 1024 var:var];
	[AKSDKHelper setParam:&param paramname:@"&cids" paramval:commentIds];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_COMMENTS_SHOWBATCH additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
//    //return _weiboMethod->cpp->getCommentsShowBatch([commentIds UTF8String],(VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) postCommentsCreate:(NSString *)postId comment:(NSString *)comment commentOri:(NSInteger)commentOri var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    NSString * param;
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	[AKSDKHelper setParam:&param paramname:@"&id" paramval:postId];
	[AKSDKHelper setParam:&param paramname:@"&comment" paramval:comment];
	[AKSDKHelper setIntParam:&param paramName:@"&comment_ori" paramval:commentOri];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_POST_COMMENTS_CREATE additionParam:param requestFormat:self.unifiedFormat httpMethod:@"POST" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->postCommentsCreate([postId UTF8String],[comment UTF8String], (int)commentOri, (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) postCommentsDestroy:(NSString *)postId  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{
    
    NSString * param;
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
	[AKSDKHelper setParam:&param paramname:@"&cid" paramval:postId];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_POST_COMMENTS_DESTROY additionParam:param requestFormat:self.unifiedFormat httpMethod:@"POST" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->postCommentsDestroy([postId UTF8String],(VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);
}

-(AKWeiboResultCode) postCommentsDestroyBatch:(NSString *)postId  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    NSString * param;
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
	[AKSDKHelper setParam:&param paramname:@"&cids" paramval:postId];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_POST_COMMENTS_DESTROY_BATCH additionParam:param requestFormat:self.unifiedFormat httpMethod:@"POST" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->postCommentsDestroyBatch([postId UTF8String],(VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) postCommentsReply:(NSString *) commentId comment:(NSString *)comment weiboId:(NSString *)weiboId withoutMention:(NSInteger)withoutMention   commentOri:(NSInteger)commentOri  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    NSString * param;
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
	[AKSDKHelper setParam:&param paramname:@"&cid" paramval:commentId];
	[AKSDKHelper setParam:&param paramname:@"&id" paramval:weiboId];
	[AKSDKHelper setParam:&param paramname:@"&comment" paramval:comment];
	[AKSDKHelper setIntParam:&param paramName:@"&comment_ori" paramval:commentOri];
	[AKSDKHelper setIntParam:&param paramName:@"&without_mention" paramval:withoutMention];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_POST_COMMENTS_REPLY additionParam:param requestFormat:self.unifiedFormat httpMethod:@"POST" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->postCommentsReply([commentId UTF8String], [comment UTF8String], [weiboId UTF8String], (int)withoutMention, (int)commentOri, (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}


#pragma mark - 私信读取
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 私信读取
-(AKWeiboResultCode) getDirectMessages:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    //return _weiboMethod->cpp->getDirectMessages((VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);
    
    NSString * param;
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	//[AKSDKHelper setParam:&param paramname:@"&source" paramval:mAppKey.c_str()];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_DIRECTMESSAGES additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    

}

-(AKWeiboResultCode) getDirectMessagesSent:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    NSString * param;
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	//[AKSDKHelper setParam:&param paramname:@"&source" paramval:mAppKey.c_str()];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_DIRECTMESSAGES_SENT additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->getDirectMessagesSent((VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getDirectMessagesUserList:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    
    NSString * param;
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	//[AKSDKHelper setParam:&param paramname:@"&source" paramval:mAppKey.c_str()];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_DIRECTMESSAGES_USER_LIST additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->getDirectMessagesUserList((VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getDirectMessagesCoversation:(AKID  *)usrId  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    
    if (!usrId)
	{
		return AKWRC_USERID_NULL;
	}
    
	NSString * param;
    [AKSDKHelper setParam:&param paramname:@"&user_id" paramval:usrId.ID];
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	//[AKSDKHelper setParam:&param paramname:@"&source" paramval:mAppKey.c_str()];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_DIRECTMESSAGES_CONVERSATION additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->getDirectMessagesCoversation( *((ID *)[usrId getCore]), (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getDirectMessagesShowBatch:(NSString *)aID  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    if (!aID)
	{
		return AKWRC_USERID_NULL;
	}
    
	NSString * param;
	[AKSDKHelper setParam:&param paramname:@"&dmids" paramval:aID];
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	//[AKSDKHelper setParam:&param paramname:@"&source" paramval:mAppKey.c_str()];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_DIRECTMESSAGES_SHOW_BATCH additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->getDirectMessagesShowBatch([aID UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getDirectMessagesIsCapable:(NSString *)uid  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    if (!uid)
	{
		return AKWRC_USERID_NULL;
	}
    
	NSString * param;
	[AKSDKHelper setParam:&param paramname:@"&uid" paramval:uid];
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_DIRECTMESSAGES_IS_CAPABLE additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->getDirectMessagesIsCapable([uid UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);}

}

#pragma mark - 私信写入
// 私信写入
-(AKWeiboResultCode)postDirectMessagesNew:(NSString *)text uid:(AKID *) uid fields:(NSString *)fields weiboId:(NSString *) weiboId  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{
    
       if (!text)
       {
           return AKWRC_TEXT_NULL;
       }
       
       NSString * param;
       
       // Required params
    [AKSDKHelper makeIDParams:&param length:0124 userID:uid];
//       [AKSDKHelper makeIDParams:&param length:1024 userID:uid];
    [AKSDKHelper setParam:&param paramname:@"&text" paramval:text];
    [AKSDKHelper setParam:&param paramname:@"&fields" paramval:fields];
    [AKSDKHelper setParam:&param paramname:@"&id" paramval:weiboId];
   
   // Variable params
    [AKSDKHelper makeVariableParams:&param length: 1024 var:var];

    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_POST_DIRECTMESSAGES_NEW additionParam:param requestFormat:self.unifiedFormat httpMethod:@"POST" pTask:pTask];

    //WeiboRequestPtr ptr = internalMakeWeiboRequest(WBOPT_POST_DIRECTMESSAGES_NEW, param, getUnifiedFormat(), httpengine::HM_POST, pTask);

    return [self startRequest:request];
    //return _weiboMethod->cpp->postDirectMessagesNew([text UTF8String], *((ID *)[uid getCore]), [fields UTF8String], [weiboId UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) postDirectMessagesDestory:(NSString *)aID  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    if (!aID)
	{
		return AKWRC_USERID_NULL;
	}
    
	// Required params
	NSString * param;
	[AKSDKHelper setParam:&param paramname:@"&id" paramval:aID];
    
	// Variable params
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_POST_DIRECTMESSAGES_DESTORY additionParam:param requestFormat:self.unifiedFormat httpMethod:@"POST" pTask:pTask];
    
	return [self startRequest:request];
    
    
    //return _weiboMethod->cpp->postDirectMessagesDestory([aID UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) postDirectMessagesDestoryBatch:(NSString *)aIDs uid:(NSString *)uid  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    
    NSString * param;
	if (aIDs)
	{
		[AKSDKHelper setParam:&param paramname:@"&ids" paramval:aIDs];
	}
	else
	{
		[AKSDKHelper setParam:&param paramname:@"&uid" paramval:uid];
	}
    
	// Variable params
	[AKSDKHelper makeVariableParams:&param length: 1024 var:var];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_POST_DIRECTMESSAGES_DESTORY_BATCH additionParam:param requestFormat:self.unifiedFormat httpMethod:@"POST" pTask:pTask];
    
	return [self startRequest:request];
    
    
    //return _weiboMethod->cpp->postDirectMessagesDestoryBatch([aIDs UTF8String], [uid UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}



#pragma mark - 用户读取
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 用户读取
-(AKWeiboResultCode) getUsersShow:(AKID *)usrId extend:(NSString *)extend var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    if (!usrId)
	{
		return AKWRC_USERID_NULL;
	}
    
	NSString * param;
	[AKSDKHelper makeIDParams:&param length:255 userID:usrId];
	[AKSDKHelper setParam:&param paramname:@"&has_extend" paramval:extend];
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];

	
	//[AKSDKHelper setParam:&param paramname:@"&source" paramval:mAppKey.c_str()];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_USERS_SHOW additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
   
    
    //ID &userID = *(ID *)[usrId getCore];
    //return _weiboMethod->cpp->getUsersShow(userID, [extend UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);
}

-(AKWeiboResultCode) getUsersDomainShow:(NSString *) domain  extend:(NSString *)extend  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    NSString * param;
	[AKSDKHelper setParam:&param paramname:@"&has_extend" paramval:extend];
	[AKSDKHelper setParam:&param paramname:@"&domain" paramval:domain];
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	//[AKSDKHelper setParam:&param paramname:@"&source" paramval:mAppKey.c_str()];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_USERS_DOMAIN_SHOW additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->getUsersDomainShow([domain UTF8String], [extend UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getUsersShowBatch:(AKID *)usrId extend:(NSString *)extend  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{
    
    if (!usrId)
	{
		return AKWRC_USERID_NULL;
	}
    
	NSString * param;
    
	// Require param
	[AKSDKHelper setParam:&param paramname:@"&uids" paramval:usrId.ID];
    [AKSDKHelper setParam:&param paramname:@"&has_extend" paramval:(extend)];
	// Variable param
	[AKSDKHelper makeVariableParams:&param length: 2048 var:var];
    
	//[AKSDKHelper setParam:&param paramname:@"&source" paramval:mAppKey.c_str()];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_USERS_SHOW_BATCH additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    

    //return _weiboMethod->cpp->getUsersShowBatch(*((ID *)[usrId getCore]),[extend UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}


#pragma mark - 关注读取
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 关注读取
-(AKWeiboResultCode) getFriendshipsFriends:(AKID *)usrId   order:(NSInteger)order  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask {

    NSString * param;
	[AKSDKHelper makeIDParams:&param length:255 userID:usrId];
	[AKSDKHelper setIntParam:&param paramName:@"&order" paramval:order];
    
	// Variable params
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_FRIENDSHIPS_FRIENDS additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->getFriendshipsFriends(*((ID *)[usrId getCore]), (int)order, (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getFriendshipsInCommon:(NSString *)aID suid:(NSString *)suid  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask {
    
    if (!aID)
	{
		return AKWRC_WEIBOID_NULL;
	}
    
	NSString * param;
	[AKSDKHelper setParam:&param paramname:@"&uid" paramval:aID];
	[AKSDKHelper setParam:&param paramname:@"&suid" paramval:suid];
    
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_FRIENDSHIPS_IN_COMMON additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    

    //return _weiboMethod->cpp->getFriendshipsInCommon([aID UTF8String], [suid UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getFriendshipsBilateral:(NSString *)uid  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask {

    if (!uid)
	{
		return AKWRC_WEIBOID_NULL;
	}
    
	NSString * param;
	[AKSDKHelper setParam:&param paramname:@"&uid" paramval:uid];
    
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_FRIENDSHIPS_BILATERAL additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    
    //return _weiboMethod->cpp->getFriendshipsBilateral([uid UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getFriendshipsBilateralIDs:(NSString *)uid  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask {

    //return _weiboMethod->cpp->getFriendshipsBilateralIDs([uid UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);
    if (!uid)
	{
		return AKWRC_WEIBOID_NULL;
	}
    
	NSString * param;
	[AKSDKHelper setParam:&param paramname:@"&uid" paramval:uid];
    
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_FRIENDSHIPS_BILATERAL_IDS additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    

}

-(AKWeiboResultCode) getFriendshipsFriendIDs:(AKID *)usrId  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask {

    if (!usrId)
	{
		return AKWRC_WEIBOID_NULL;
	}
    
	NSString * param;
    
	[AKSDKHelper makeIDParams:&param length:255 userID:usrId];
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_FRIENDSHIPS_FRIENDS_IDS additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->getFriendshipsFriendIDs(*((ID *)[usrId getCore]), (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);
}

-(AKWeiboResultCode) getFriendshipsFriendRemarkBatch:(NSString *)uids  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask {

    if (!uids)
	{
		return AKWRC_WEIBOID_NULL;
	}
    
	NSString * param;
    
	// Required params
	[AKSDKHelper setParam:&param paramname:@"&uids" paramval:uids];
    
	// Varible params
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_FRIENDSHIPS_FRIENDS_REMARK_BATCH additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    
    //return _weiboMethod->cpp->getFriendshipsFriendRemarkBatch([uids UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

#pragma mark - 粉丝读取
// 粉丝读取
-(AKWeiboResultCode) getFriendshipsFriendsFollowers:(AKID *)usrId  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{
    
    if (!usrId)
	{
		return AKWRC_WEIBOID_NULL;
	}
	NSString * param;
    
	[AKSDKHelper makeIDParams:&param length:255 userID:usrId];
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_FRIENDSHIPS_FRIENDS_FOLLOWERS additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    

    //return _weiboMethod->cpp->getFriendshipsFriendsFollowers(*((ID *)[usrId getCore]),(VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getFriendshipsFriendsFollowersIDs:(AKID *)usrId  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask {

    if (!usrId)
	{
		return AKWRC_WEIBOID_NULL;
	}
	NSString * param;
    
	[AKSDKHelper makeIDParams:&param length:255 userID:usrId];
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_FRIENDSHIPS_FRIENDS_FOLLOWERS_IDS additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->getFriendshipsFriendsFollowersIDs(*((ID *)[usrId getCore]), (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getFriendshipsFriendsFollowersActive:(AKID *)usrIDs  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask {

    if (!usrIDs)
	{
		return AKWRC_WEIBOID_NULL;
	}
    
	NSString * param;
    
	[AKSDKHelper makeIDParams:&param length:255 userID:usrIDs];
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_FRIENDSHIPS_FRIENDS_FOLLOWERS_ACTIVE additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->getFriendshipsFriendsFollowersActive(*((ID *)[usrIDs getCore]), (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}


#pragma mark - 关系链读取
// 关系链读取
-(AKWeiboResultCode) getFriendshipsFriendsChainFollowers:(NSString *)uid  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask {
    
    if (!uid)
	{
		return AKWRC_WEIBOID_NULL;
	}
    
	NSString * param;
    
	[AKSDKHelper setParam:&param paramname:@"&uid" paramval:uid];
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_FRIENDSHIPS_CHAIN_FOLLOWERS additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];

    //return _weiboMethod->cpp->getFriendshipsFriendsChainFollowers([uid UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}


#pragma mark - 关系状态
// 关系状态
-(AKWeiboResultCode) getFriendshipShow:(AKID *)sourceId targetId:(AKID *)targetId  pTask:(AKUserTaskInfo *) pTask {

    if (!sourceId)
	{
		return AKWRC_USERID_NULL;
	}
	if (!targetId)
	{
		return AKWRC_USERID_NULL;
	}
    
	NSString * param;
    
	// Required params
	if (AKIDTypeID == sourceId.idType)
	{
        [AKSDKHelper setParam:&param paramname:@"&source_id" paramval:sourceId.ID];
//		[AKSDKHelper setParam:&param paramname:@"&source_id" paramval:sourceId.id.c_str()];
	}
	else if (AKIDTypeScreenname == sourceId.idType)
	{
        [AKSDKHelper setParam:&param paramname:@"&source_screen_name" paramval:sourceId.ID];
        
//		[AKSDKHelper setParam:&param paramname:@"&source_screen_name" paramval:sourceId.id.c_str()];
	}
    
	if (AKIDTypeID == targetId.idType)
	{
        [AKSDKHelper setParam:&param paramname:@"&target_id" paramval:sourceId.ID];
//		[AKSDKHelper setParam:&param paramname:@"&target_id" paramval:targetId.id.c_str()];
	}
	else if (AKIDTypeScreenname == targetId.idType)
	{
        [AKSDKHelper setParam:&param paramname:@"&target_screen_name" paramval:sourceId.ID];
//		[AKSDKHelper setParam:&param paramname:@"&target_screen_name" paramval:targetId.id.c_str()];
	}
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_FRIENDSHIPS_SHOW additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->getFriendshipShow(*((ID *)[sourceId getCore]), *((ID *)[targetId getCore]),(UserTaskInfo *)[pTask getCore]);

}




#pragma mark - 关系写入
// 关系写入
-(AKWeiboResultCode) postFriendshipsCreate:(AKID *)usrId   skipCheck:(NSInteger)skipCheck  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask {

    if (!usrId)
	{
		return AKWRC_USERID_NULL;
	}
    
	NSString * param;
	[AKSDKHelper makeIDParams:&param length:255 userID:usrId];
	[AKSDKHelper setIntParam:&param paramName:@"&skip_check" paramval:skipCheck];
    
	// Variable params
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_POST_FRIENDSHIPS_CREATE additionParam:param requestFormat:self.unifiedFormat httpMethod:@"POST" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->postFriendshipsCreate(*((ID *)[usrId getCore]), (int)skipCheck, (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) postFriendshipsCreateBatch:(NSString *)uids  pTask:(AKUserTaskInfo *) pTask {

    if (!uids)
	{
		return AKWRC_USERID_NULL;
	}
	NSString * param;
    
	// Required params
	[AKSDKHelper setParam:&param paramname:@"&uids" paramval:uids];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_POST_FRIENDSHIPS_CREATE_BATCH additionParam:param requestFormat:self.unifiedFormat httpMethod:@"POST" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->postFriendshipsCreateBatch([uids UTF8String],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) postFriendshipsDestroy:(AKID *)usrId  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask {
    
    if (!usrId)
	{
		return AKWRC_USERID_NULL;
	}
    
	NSString * param;
    
	// Id params
	[AKSDKHelper makeIDParams:&param length:255 userID:usrId];
    
	// Variable params
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_POST_FRIENDSHIPS_DESTROY additionParam:param requestFormat:self.unifiedFormat httpMethod:@"POST" pTask:pTask];
    
	return [self startRequest:request];

    //return _weiboMethod->cpp->postFriendshipsDestroy(*((ID *)[usrId getCore]), (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) postFriendshipsFollowersDestroy:(NSString *)uid  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask {
    
    if (!uid)
	{
		return AKWRC_USERID_NULL;
	}
    
	NSString * param;
    
	[AKSDKHelper setParam:&param paramname:@"&uid" paramval:uid];
    
	// Variable params
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_POST_FRIENDSHIPS_FOLLOWERS_DESTORY additionParam:param requestFormat:self.unifiedFormat httpMethod:@"POST" pTask:pTask];
    
	return [self startRequest:request];
    

    //return _weiboMethod->cpp->postFriendshipsFollowersDestroy([uid UTF8String],  (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) postFriendshipsRemarkUpdate:(NSString *) uid remark:(NSString *)remark  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask {
    
    if (!uid)
	{
		return AKWRC_USERID_NULL;
	}
    
	NSString * param;
    
	// Required params
	[AKSDKHelper setParam:&param paramname:@"&uid" paramval:uid];
	[AKSDKHelper setParam:&param paramname:@"&remark" paramval:remark];
    
	// Variable params
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_POST_FRIENDSHIPS_REMARK_UPDATE additionParam:param requestFormat:self.unifiedFormat httpMethod:@"POST" pTask:pTask];
    
	return [self startRequest:request];

    //return _weiboMethod->cpp->postFriendshipsRemarkUpdate([uid UTF8String], [remark UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}


#pragma mark - 好友分组

-(AKWeiboResultCode) getFriendshipsGroups:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_FRIENDSHIPS_GROUPS additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) getFriendshipsGroupsTimeline:(long)list_id var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_FRIENDSHIPS_GROUPS_TIMELINE additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) getFriendshipsGroupsTimelineIds:(long)list_id var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_FRIENDSHIPS_GROUPS_TIMELINE_IDS additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) getFriendshipsGroupsMembers:(long)list_id var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_FRIENDSHIPS_GROUPS_MEMBERS additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) getFriendshipsGroupsMembersIds:(long)list_id var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_FRIENDSHIPS_GROUPS_MEMBERS_IDS additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) getFriendshipsGroupsMembersDescription:(NSString *)uids list_id:(long)list_id var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_FRIENDSHIPS_GROUPS_MEMBERS_DESCRIPTION additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) getFriendshipsGroupsIsMember:(long)uid list_id:(long)list_id var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_FRIENDSHIPS_GROUPS_IS_MEMBER additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) getFriendshipsGroupsListed:(NSString *)uids var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_FRIENDSHIPS_GROUPS_LISTED additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) getFriendshipsGroupsShow:(long)list_id var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_FRIENDSHIPS_GROUPS_SHOW additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) getFriendshipsGroupsShowBatch:(long)list_ids uids:(NSString *)uids var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_FRIENDSHIPS_GROUPS_SHOW_BATCH additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) postFriendshipsGroupsCreate:(NSString *)name description:(NSString *)description tags:(NSString *)tags var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_POST_FRIENDSHIPS_GROUPS_CREATE additionParam:param requestFormat:self.unifiedFormat httpMethod:@"POST" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) postFriendshipsGroupsUpdate:(long)list_id name:(NSString *)name description:(NSString *)description tags:(NSString *)tags var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_POST_FRIENDSHIPS_GROUPS_UPDATE additionParam:param requestFormat:self.unifiedFormat httpMethod:@"POST" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) postFriendshipsGroupsDestroy:(long)list_id var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_POST_FRIENDSHIPS_GROUPS_DESTROY additionParam:param requestFormat:self.unifiedFormat httpMethod:@"POST" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) postFriendshipsGroupsMembersAdd:(long)uid list_id:(long)list_id var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_POST_FRIENDSHIPS_GROUPS_MEMBERS_ADD additionParam:param requestFormat:self.unifiedFormat httpMethod:@"POST" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) postFriendshipsGroupsMembersAddBatch:(long)list_id uids:(NSString *)uids group_descriptions:(NSString *)group_descriptions var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_POST_FRIENDSHIPS_GROUPS_MEMBERS_ADD_BATCH additionParam:param requestFormat:self.unifiedFormat httpMethod:@"POST" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) postFriendshipsGroupsMembersUpdate:(long)list_id uid:(long)uid group_description:(NSString *)group_description var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_POST_FRIENDSHIPS_GROUPS_MEMBERS_UPDATE additionParam:param requestFormat:self.unifiedFormat httpMethod:@"POST" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) postFriendshipsGroupsMembersDestroy:(long)uid list_id:(long)list_id var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_POST_FRIENDSHIPS_GROUPS_MEMBERS_DESTROY additionParam:param requestFormat:self.unifiedFormat httpMethod:@"POST" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) postFriendshipsGroupsOrder:(NSString *)list_ids var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_POST_FRIENDSHIPS_GROUPS_ORDER additionParam:param requestFormat:self.unifiedFormat httpMethod:@"POST" pTask:pTask];
    return [self startRequest:request];
    
}



#pragma mark - 帐号读取
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 帐号读取
-(AKWeiboResultCode) getAccountProfileBasic:(NSString *) uid   pTask:(AKUserTaskInfo *) pTask {

    
    NSString * param;
	[AKSDKHelper setParam:&param paramname:@"&uid" paramval:uid];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_ACCOUNT_PROFILE_BASIC additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->getAccountProfileBasic([uid UTF8String], (UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getAccountProfileEducation:(NSString *)uid  pTask:(AKUserTaskInfo *) pTask {

    NSString * param;
	[AKSDKHelper setParam:&param paramname:@"&uid" paramval:uid];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_ACCOUNT_PROFILE_EDUCATION additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    
    //return _weiboMethod->cpp->getAccountProfileEducation([uid UTF8String], (UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getAccountProfileEducationBatch:(NSString *)uids  pTask:(AKUserTaskInfo *) pTask {

    if (!uids)
	{
		return AKWRC_USERID_NULL;
	}
    
	NSString * param;
	[AKSDKHelper setParam:&param paramname:@"&uids" paramval:uids];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_ACCOUNT_PROFILE_EDUCATION_BATCH additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->getAccountProfileEducationBatch([uids UTF8String],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getAccountProfileCareer:(NSString *)uid  pTask:(AKUserTaskInfo *) pTask {

    NSString * param;
    
	[AKSDKHelper setParam:&param paramname:@"&uid" paramval:uid];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_ACCOUNT_PROFILE_CAREER additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->getAccountProfileCareer([uid UTF8String], (UserTaskInfo *)[pTask getCore]);
}

-(AKWeiboResultCode) getAccountProfileCareerBatch:(NSString *)uids  pTask:(AKUserTaskInfo *) pTask {

    if (!uids)
	{
		return AKWRC_USERID_NULL;
	}
    
	NSString * param;
	[AKSDKHelper setParam:&param paramname:@"&uids" paramval:uids];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_ACCOUNT_PROFILE_CAREER_BATCH additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->getAccountProfileCareerBatch([uids UTF8String],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getAccountGetPrivacy:(AKUserTaskInfo *) pTask {
    
    NSString * param;
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_ACCOUNT_GET_PRIVACY additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
}
    //return _weiboMethod->cpp->getAccountGetPrivacy((UserTaskInfo *)[pTask getCore]);}

-(AKWeiboResultCode) getAccountProfileSchoolList:(NSInteger) province  city:(NSInteger) city  area:(NSInteger) area  type:(NSInteger) type capital:(NSString *)capital keyword:(NSString *)keyword  counts:(NSInteger) counts  pTask:(AKUserTaskInfo *) pTask {

    NSString * param;
	[AKSDKHelper setIntParam:&param paramName:@"&province" paramval:province];
	[AKSDKHelper setIntParam:&param paramName:@"&city" paramval:city];
	[AKSDKHelper setIntParam:&param paramName:@"&type" paramval:type];
	[AKSDKHelper setIntParam:&param paramName:@"&counts" paramval:counts];
    [AKSDKHelper setParam:&param paramname:@"&capital" paramval:capital?capital:@""];
    [AKSDKHelper setParam:&param paramname:@"&keyword" paramval:keyword?keyword:@""];
    
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_ACCOUNT_PROFILE_SCHOOL_LIST additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->getAccountProfileSchoolList((int)province, (int)city, (int)area, (int)type, [capital UTF8String], [keyword UTF8String], (int)counts, (UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getAccountRateLimitStatus:(AKUserTaskInfo *) pTask {

    NSString * param;
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_ACCOUNT_RATE_LIMIT_STATUS additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->getAccountRateLimitStatus((UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getAccountGetUID:(AKUserTaskInfo *) pTask {

    NSString * param;
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_ACCOUNT_GET_UID additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->getAccountGetUID((UserTaskInfo *)[pTask getCore]);

}

-(NSString *)getNotNullString:(NSString*)target{

    return target?target:@"";

}

#pragma mark - 帐号写入
// 帐号写入
-(AKWeiboResultCode) postAccountProfileBasicUpdate:(AKBasicInfo*)basic  pTask:(AKUserTaskInfo *) pTask {

    NSString * param;
    
	[AKSDKHelper setParam:&param paramname:@"&screen_name" paramval:[self getNotNullString:basic.screen_name]];
	[AKSDKHelper setParam:&param paramname:@"&real_name" paramval:[self getNotNullString:basic.real_name]];
	[AKSDKHelper setParam:&param paramname:@"&real_name_visible" paramval:[self getNotNullString:basic.real_name_visible]];
	[AKSDKHelper setParam:&param paramname:@"&province" paramval:[self getNotNullString:basic.province]];
	[AKSDKHelper setParam:&param paramname:@"&city" paramval:[self getNotNullString:basic.city]];
	[AKSDKHelper setParam:&param paramname:@"&birthday" paramval:[self getNotNullString:basic.birthday]];
	[AKSDKHelper setParam:&param paramname:@"&birthday_visible" paramval:[self getNotNullString:basic.birthday_visible]];
	[AKSDKHelper setParam:&param paramname:@"&qq	false" paramval:[self getNotNullString:basic.qq]];
	[AKSDKHelper setParam:&param paramname:@"&qq_visible" paramval:[self getNotNullString:basic.qq_visible]];
	[AKSDKHelper setParam:&param paramname:@"&msn" paramval:[self getNotNullString:basic.msn]];
	[AKSDKHelper setParam:&param paramname:@"&msn_visible" paramval:[self getNotNullString:basic.msn_visible]];
	[AKSDKHelper setParam:&param paramname:@"&url_string" paramval:[self getNotNullString:basic.url_string]];
	[AKSDKHelper setParam:&param paramname:@"&url_visible" paramval:[self getNotNullString:basic.url_visible]];
	[AKSDKHelper setParam:&param paramname:@"&gender" paramval:[self getNotNullString:basic.gender]];
	[AKSDKHelper setParam:&param paramname:@"&credentials_type" paramval:[self getNotNullString:basic.credentials_type]];
	[AKSDKHelper setParam:&param paramname:@"&credentials_num" paramval:[self getNotNullString:basic.credentials_num]];
	[AKSDKHelper setParam:&param paramname:@"&emai" paramval:[self getNotNullString:basic.email]];
	[AKSDKHelper setParam:&param paramname:@"&email_visible" paramval:[self getNotNullString:basic.email_visible]];
	[AKSDKHelper setParam:&param paramname:@"&lang" paramval:[self getNotNullString:basic.lang]];
	[AKSDKHelper setParam:&param paramname:@"&description" paramval:[self getNotNullString:basic.description]];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_POST_ACCOUNT_PROFILE_BASIC_UPDATE additionParam:param requestFormat:self.unifiedFormat httpMethod:@"POST" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->postAccountProfileBasicUpdate(*((BasicInfo *)[basic getCore]), (UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) postAccountProfileEduUpdate:(AKEducationInfo *)edu  pTask:(AKUserTaskInfo *) pTask {

    
	NSString * param;
    
	[AKSDKHelper setParam:&param paramname:@"&id" paramval:[self getNotNullString:edu.ID]];
	[AKSDKHelper setParam:&param paramname:@"&type" paramval:[self getNotNullString:edu.type]];
	[AKSDKHelper setParam:&param paramname:@"&school" paramval:[self getNotNullString:edu.school]];
	[AKSDKHelper setParam:&param paramname:@"&department" paramval:[self getNotNullString:edu.department]];
	[AKSDKHelper setParam:&param paramname:@"&year" paramval:[self getNotNullString:edu.year]];
	[AKSDKHelper setParam:&param paramname:@"&visible" paramval:[self getNotNullString:edu.visible]];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_POST_ACCOUNT_PROFILE_EDU_UPDATE additionParam:param requestFormat:self.unifiedFormat httpMethod:@"POST" pTask:pTask];
    
	return [self startRequest:request];
}

    //return _weiboMethod->cpp->postAccountProfileEduUpdate(*((EducationInfo *)[edu getCore]),(UserTaskInfo *)[pTask getCore]);}

-(AKWeiboResultCode) postAccountProfileEduDestroy:(NSString *)aID  pTask:(AKUserTaskInfo *) pTask {

    
	if (!aID)
	{
		return AKWRC_USERID_NULL;
	}
    
	NSString * param;
	[AKSDKHelper setParam:&param paramname:@"&id" paramval:aID];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_POST_ACCOUNT_PROFILE_EDU_DESTROY additionParam:param requestFormat:self.unifiedFormat httpMethod:@"POST" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->postAccountProfileEduDestroy([aID UTF8String], (UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) postAccountProfileCarUpdate:(AKCareerInfo *) career  pTask:(AKUserTaskInfo *) pTask {
    
	NSString * param;
    
	[AKSDKHelper setParam:&param paramname:@"&id" paramval:[self getNotNullString:career.ID]];
	[AKSDKHelper setParam:&param paramname:@"&city" paramval:[self getNotNullString:career.city]];
	[AKSDKHelper setParam:&param paramname:@"&province" paramval:[self getNotNullString:career.province]];
	[AKSDKHelper setParam:&param paramname:@"&start" paramval:[self getNotNullString:career.start]];
	[AKSDKHelper setParam:&param paramname:@"&end" paramval:[self getNotNullString:career.end]];
	[AKSDKHelper setParam:&param paramname:@"&company" paramval:[self getNotNullString:career.company]];
	[AKSDKHelper setParam:&param paramname:@"&department" paramval:[self getNotNullString:career.department]];
	[AKSDKHelper setParam:&param paramname:@"&visible" paramval:[self getNotNullString:career.visible]];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_POST_ACCOUNT_PROFILE_CAR_UPDATE additionParam:param requestFormat:self.unifiedFormat httpMethod:@"POST" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->postAccountProfileCarUpdate(*((CareerInfo *)[career getCore]), (UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) postAccountProfileCarDestroy:(NSString *)aID  pTask:(AKUserTaskInfo *) pTask {

    
	if (!aID)
	{
		return AKWRC_USERID_NULL;
	}
    
	NSString * param;
	[AKSDKHelper setParam:&param paramname:@"id" paramval:aID];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_POST_ACCOUNT_PROFILE_CAR_DESTROY additionParam:param requestFormat:self.unifiedFormat httpMethod:@"POST" pTask:pTask];
    
	return [self startRequest:request];
}
    //return _weiboMethod->cpp->postAccountProfileCarDestroy([aID UTF8String], (UserTaskInfo *)[pTask getCore]);}

-(AKWeiboResultCode) postAccountAvatarUpload:(NSString *)filePath  pTask:(AKUserTaskInfo *) pTask {

    if (!filePath)
	{
		return AKWRC_FILEPATH_NULL;
	}
    
	NSString * param;
	//
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_POST_ACCOUNT_AVATAR_UPLOAD additionParam:param requestFormat:self.unifiedFormat httpMethod:@"POSTFORM" pTask:pTask];

    //TODO:FIX IT
//	ptr->mPostFileField = "image";
//	ptr->makeUploadTaskDetail([self getNotNullString:filePath]);
//    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->postAccountAvatarUpload([filePath UTF8String], (UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) postAccountUpdatePrivacy:(NSInteger) comment geo:(NSInteger)geo message:(NSInteger)message realname:(NSInteger)realname  badge:(NSInteger) badge  mobile:(NSInteger) mobile  pTask:(AKUserTaskInfo *) pTask {

    

    
    NSString * param;
    
	[AKSDKHelper setIntParam:&param paramName:@"&comment" paramval:comment];
	[AKSDKHelper setIntParam:&param paramName:@"&geo" paramval:geo];
	[AKSDKHelper setIntParam:&param paramName:@"&message" paramval:message];
	[AKSDKHelper setIntParam:&param paramName:@"&realname" paramval:realname];
	[AKSDKHelper setIntParam:&param paramName:@"&badge" paramval:badge];
	[AKSDKHelper setIntParam:&param paramName:@"&mobile" paramval:mobile];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_POST_ACCOUNT_UPDATE_PRIVACY additionParam:param requestFormat:self.unifiedFormat httpMethod:@"POST" pTask:pTask];
    
	return [self startRequest:request];
    
    
    //return _weiboMethod->cpp->postAccountUpdatePrivacy((int) comment, (int) geo, (int) message, (int) realname, (int) badge, (int) mobile, (UserTaskInfo *)[pTask getCore]);
}


#pragma mark - 收藏读取
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 收藏读取
-(AKWeiboResultCode) getFavorites:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    
	NSString * param;
    
	// Variable params
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_FAVORITES additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->getFavorites((VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);


}

-(AKWeiboResultCode) getFavoritesShow:(NSString *)aID  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    if (!aID)
	{
		return AKWRC_WEIBOID_NULL;
	}
    
	NSString * param;
    
	// Required params
	[AKSDKHelper setParam:&param paramname:@"&id" paramval:aID];
    
	// Variable params
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_FAVORITES_SHOW additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->getFavoritesShow([aID UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getFavoritesByTags:(NSString *)tid  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    //return _weiboMethod->cpp->getFavoritesByTags([tid UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);
    if (!tid)
	{
		return AKWRC_TAGID_NULL;
	}
    
	NSString * param;
    
	// Required params
	[AKSDKHelper setParam:&param paramname:@"&tid" paramval:tid];
    
	// Variable params
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_FAVORITES_BY_TAGS additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    

}

-(AKWeiboResultCode) getFavoritesTags:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    //return _weiboMethod->cpp->getFavoritesTags((VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);
    
    NSString * param;
    
	// Variable params
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_FAVORITES_TAGS additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    

}


#pragma mark - 收藏写入
// 收藏写入
-(AKWeiboResultCode) postFavoritesCreate:(NSString *)aID  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    //return _weiboMethod->cpp->postFavoritesCreate([aID UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

    if (!aID)
	{
		return AKWRC_WEIBOID_NULL;
	}
    
	NSString * param;
    
	// Required params
	[AKSDKHelper setParam:&param paramname:@"&id" paramval:aID];
    
	// Variable params
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_POST_FAVORITES_CREATE additionParam:param requestFormat:self.unifiedFormat httpMethod:@"POST" pTask:pTask];
    
	return [self startRequest:request];
    
}

-(AKWeiboResultCode) postFavoritesDestroy:(NSString *)aID  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    //return _weiboMethod->cpp->postFavoritesDestroy([aID UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

    
	if (!aID)
	{
		return AKWRC_WEIBOID_NULL;
	}
    
	NSString * param;
    
	// Required params
	[AKSDKHelper setParam:&param paramname:@"&id" paramval:aID];
    
	// Variable params
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_POST_FAVORITES_DESTROY additionParam:param requestFormat:self.unifiedFormat httpMethod:@"POST" pTask:pTask];
    
	return [self startRequest:request];
    
}

-(AKWeiboResultCode) postFavoritesDestroyBatch:(NSString *)aIDs  pTask:(AKUserTaskInfo *) pTask{

    //return _weiboMethod->cpp->postFavoritesDestroyBatch([aIDs UTF8String],(UserTaskInfo *)[pTask getCore]);
    if (!aIDs)
	{
		return AKWRC_WEIBOID_NULL;
	}
    
	NSString * param;
    
	// Required params
	[AKSDKHelper setParam:&param paramname:@"&ids" paramval:aIDs];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_POST_FAVORITES_DESTROY_BATCH additionParam:param requestFormat:self.unifiedFormat httpMethod:@"POST" pTask:pTask];
    
	return [self startRequest:request];
    

}

-(AKWeiboResultCode) postFavoritesTagUpdate:(NSString *)tagId tagName:(NSString *)tagName  var:(AKVariableParams *)var  pTask:(AKUserTaskInfo *) pTask{

    //return _weiboMethod->cpp->postFavoritesTagUpdate([tagId UTF8String],[tagName UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);
    
	if (!tagId)
	{
		return AKWRC_WEIBOID_NULL;
	}
    
	NSString * param;
    
	// Required params
	[AKSDKHelper setParam:&param paramname:@"&id" paramval:tagId];
	[AKSDKHelper setParam:&param paramname:@"&tags" paramval:tagName];
    
	// Variable params
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_POST_FAVORITES_TAGS_UPDATE additionParam:param requestFormat:self.unifiedFormat httpMethod:@"POST" pTask:pTask];
    
	return [self startRequest:request];
    

}

-(AKWeiboResultCode) postFavoritesTagsUpdateBatch:(NSString *)tagId tagName:(NSString *)tagName  var:(AKVariableParams *)var  pTask:(AKUserTaskInfo *)pTask{

    
	if (!tagId)
	{
		return AKWRC_WEIBOID_NULL;
	}
    
	NSString * param;
    
	// Required params
	[AKSDKHelper setParam:&param paramname:@"&tid" paramval:tagId];
	[AKSDKHelper setParam:&param paramname:@"&tag" paramval:tagName];
    
	// Variable params
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_POST_FAVORITES_TAGS_UPDATE_BATCH additionParam:param requestFormat:self.unifiedFormat httpMethod:@"POST" pTask:pTask];
    
	return [self startRequest:request];
    //return _weiboMethod->cpp->postFavoritesTagsUpdateBatch([tagId UTF8String], [tagName UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) postFavoritesTagsDestroyBatch:(NSString *)tagId  var:(AKVariableParams *)var  pTask:(AKUserTaskInfo *)pTask{
    
    if (!tagId)
	{
		return AKWRC_WEIBOID_NULL;
	}
    
	NSString * param;
    
	// Required params
	[AKSDKHelper setParam:&param paramname:@"&tid" paramval:tagId];
    
	// Variable params
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_POST_FAVORITES_TAGS_DESTROY_BATCH additionParam:param requestFormat:self.unifiedFormat httpMethod:@"POST" pTask:pTask];
    
	return [self startRequest:request];

    //return _weiboMethod->cpp->postFavoritesTagsDestroyBatch([tagId UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}



#pragma mark - 话题读取
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 话题读取
-(AKWeiboResultCode) getTrends:(NSString *)uid  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{
    
	if (!uid)
	{
		return AKWRC_USERID_NULL;
	}
    
	NSString * param;
    
	// Required params
	[AKSDKHelper setParam:&param paramname:@"&uid" paramval:uid];
    
	// Variable params
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_TRENDS additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    //return _weiboMethod->cpp->getTrends([uid UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);}
}


-(AKWeiboResultCode) getTrendsStatuses:(NSString *)trendWords provinceId:(NSString *)provinceId  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    
	if (!trendWords)
	{
		return AKWRC_TEXT_NULL;
	}
    
	NSString * param;
    
	// Required params
	[AKSDKHelper setParam:&param paramname:@"&trend" paramval:trendWords];
	[AKSDKHelper setParam:&param paramname:@"&province" paramval:provinceId];
    
	// Variable params
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_TRENDS_STATUSES additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->getTrendsStatuses([trendWords UTF8String], [provinceId UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getTrendsHourly:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    
	NSString * param;
    
	// Variable params
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_TRENDS_HOURLY additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->getTrendsHourly((VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getTrendsDaily:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    NSString * param;
    
	// Variable params
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_TRENDS_DAILY additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->getTrendsDaily((VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getTrendsWeekly:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    NSString * param;
    
	// Variable params
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_TRENDS_WEEKLY additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->getTrendsWeekly((VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}


#pragma mark - 话题写入
// 话题写入
-(AKWeiboResultCode) postTrendsFollow:(NSString *)trendName  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{
    
    NSString * param;
    
	// Required params
	[AKSDKHelper setParam:&param paramname:@"&trend_name" paramval:trendName];
    
	// Variable params
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_POST_TRENDS_FOLLOW additionParam:param requestFormat:self.unifiedFormat httpMethod:@"POST" pTask:pTask];
    
	return [self startRequest:request];
    

    //return _weiboMethod->cpp->postTrendsFollow([trendName UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) postTrendsDestroy:(NSString *)trendId  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{
    
    
	NSString * param;
    
	// Required params
	[AKSDKHelper setParam:&param paramname:@"&trend_id" paramval:trendId];
    
	// Variable params
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_POST_TRENDS_DESTROY additionParam:param requestFormat:self.unifiedFormat httpMethod:@"POST" pTask:pTask];
    
	return [self startRequest:request];

    //return _weiboMethod->cpp->postTrendsDestroy([trendId UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}



#pragma mark - 标签读取
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 标签读取
-(AKWeiboResultCode) getTags:(NSString *)uid  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    if (!uid)
	{
		return AKWRC_USERID_NULL;
	}
    
	NSString * param;
    
	// Required params
	[AKSDKHelper setParam:&param paramname:@"&uid" paramval:uid];
    
	// Variable params
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_TAGS additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->getTags([uid UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getTagsTagsBatch:(NSString *)uids  pTask:(AKUserTaskInfo *) pTask{

    if (!uids)
	{
		return AKWRC_USERID_NULL;
	}
    
	NSString * param;
    
	// Required params
	[AKSDKHelper setParam:&param paramname:@"&uids" paramval:uids];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_TAGS_TAGS_BATCH additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->getTagsTagsBatch([uids UTF8String],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getTagsSuggestions:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{
    
    
	NSString * param;
    
	// Variable params
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_TAGS_SUGGESTIONS additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    

    //return _weiboMethod->cpp->getTagsSuggestions((VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}



#pragma mark - 标签写入
// 标签写入
-(AKWeiboResultCode) postTagsCreate:(NSString *)tags  pTask:(AKUserTaskInfo *) pTask{

    if (!tags)
	{
		return AKWRC_TEXT_NULL;
	}
    
	NSString * param;
    
	// Required params
	[AKSDKHelper setParam:&param paramname:@"&tags" paramval:tags];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_POST_TAGS_CREATE additionParam:param requestFormat:self.unifiedFormat httpMethod:@"POST" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->postTagsCreate([tags UTF8String],(UserTaskInfo *)[pTask getCore]);


}

-(AKWeiboResultCode) postTagsDestroy:(NSString *)tagId  pTask:(AKUserTaskInfo *) pTask{
    
    if (!tagId)
	{
		return AKWRC_TEXT_NULL;
	}
    
	NSString * param;
    
	// Required params
	[AKSDKHelper setParam:&param paramname:@"&tag_id" paramval:tagId];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_POST_TAGS_DESTROY additionParam:param requestFormat:self.unifiedFormat httpMethod:@"POST" pTask:pTask];
    
	return [self startRequest:request];
    
}
    //return _weiboMethod->cpp->postTagsDestroy([tagId UTF8String], (UserTaskInfo *)[pTask getCore]);}

-(AKWeiboResultCode) postTagsDestroyBatch:(NSString *)tagIds  pTask:(AKUserTaskInfo *) pTask{

    if (!tagIds)
	{
		return AKWRC_TEXT_NULL;
	}
    
	NSString * param;
    
	// Required params
	[AKSDKHelper setParam:&param paramname:@"&ids" paramval:tagIds];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_POST_TAGS_DESTROY_BATCH additionParam:param requestFormat:self.unifiedFormat httpMethod:@"POST" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->postTagsDestroyBatch([tagIds UTF8String],(UserTaskInfo *)[pTask getCore]);

}


#pragma mark - 搜索
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 搜索
-(AKWeiboResultCode) getSearchSuggestionsUsers:(NSString *)q  count:(NSInteger) count  pTask:(AKUserTaskInfo *) pTask{

    NSString * param;
    
	// Required params
	[AKSDKHelper setParam:&param paramname:@"&q" paramval:q];
	[AKSDKHelper setIntParam:&param paramName:@"&count" paramval:count];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_SEARCH_SUGGESTIONS_USERS additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->getSearchSuggestionsUsers([q UTF8String], (int)count, (UserTaskInfo *)[pTask getCore]);


}

-(AKWeiboResultCode) getSearchSuggestionsStatues:(NSString *)q  count:(NSInteger) count  pTask:(AKUserTaskInfo *) pTask{

    NSString * param;
    
	// Required params
	[AKSDKHelper setParam:&param paramname:@"&q" paramval:q];
	[AKSDKHelper setIntParam:&param paramName:@"&count" paramval:count];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_SEARCH_SUGGESTIONS_STATUSES additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->getSearchSuggestionsStatues([q UTF8String], (int)count, (UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getSearchSuggestionsSchool:(NSString *)q  count:(NSInteger) count  pTask:(AKUserTaskInfo *) pTask{

    NSString * param;
    
	// Required params
	[AKSDKHelper setParam:&param paramname:@"&q" paramval:q];
	[AKSDKHelper setIntParam:&param paramName:@"&count" paramval:count];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_SEARCH_SUGGESTIONS_SCHOOLS additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
}
    //return _weiboMethod->cpp->getSearchSuggestionsSchool([q UTF8String], (int)count, (UserTaskInfo *)[pTask getCore]);}

-(AKWeiboResultCode) getSearchSuggestionsCompanies:(NSString *)q  count:(NSInteger) count  pTask:(AKUserTaskInfo *) pTask{

    NSString * param;
    
	// Required params
	[AKSDKHelper setParam:&param paramname:@"&q" paramval:q];
	[AKSDKHelper setIntParam:&param paramName:@"&count" paramval:count];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_SEARCH_SUGGESTIONS_COMPANIES additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->getSearchSuggestionsCompanies([q UTF8String], (int)count, (UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getSearchSuggestionsApps:(NSString *)q  count:(NSInteger) count  pTask:(AKUserTaskInfo *) pTask{
    
    NSString * param;
    
	// Required params
	[AKSDKHelper setParam:&param paramname:@"&q" paramval:q];
	[AKSDKHelper setIntParam:&param paramName:@"&count" paramval:count];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_SEARCH_SUGGESTIONS_APPS additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    

    //return _weiboMethod->cpp->getSearchSuggestionsApps([q UTF8String], (int)count, (UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getSearchSuggestionsAtUsers:(NSString *)q   type:(NSInteger)type  count:(NSInteger) count  range:(NSInteger) range  pTask:(AKUserTaskInfo *) pTask{

    NSString * param;
    
	// Required params
	//char ctype[10] = { 0 };
	//snprintf(ctype, 10, "%d", type);
    
	[AKSDKHelper setParam:&param paramname:@"&type" paramval:[NSString stringWithFormat:@"%ld",(long)type]];
	[AKSDKHelper setParam:&param paramname:@"&q" paramval:q];
	[AKSDKHelper setIntParam:&param paramName:@"&count" paramval:count];
	[AKSDKHelper setIntParam:&param paramName:@"&range" paramval:range];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_SEARCH_SUGGESTIONS_AT_USERS additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->getSearchSuggestionsAtUsers([q UTF8String], (int)type, (int)count, (int)range, (UserTaskInfo *)[pTask getCore]);
}


-(AKWeiboResultCode) getSearchSuggestionsIntegrate:(NSString *)query  sort_user:(NSInteger) sort_user  sort_app:(NSInteger) sort_app sort_grp:(NSInteger) sort_grp  user_count:(NSInteger) user_count  app_count:(NSInteger) app_count  grp_count:(NSInteger) grp_count  pTask:(AKUserTaskInfo *) pTask{

    NSString * param;
    
	// Required params
    
//	SDKHelper::setParam(param, "&query", query, ParamEncodedValue);
    [AKSDKHelper setParam:&param paramname:@"&query" paramval:query];
    
	[AKSDKHelper setIntParam:&param paramName:@"&sort_user" paramval:sort_user];
	[AKSDKHelper setIntParam:&param paramName:@"&sort_app" paramval:sort_app];
	[AKSDKHelper setIntParam:&param paramName:@"&sort_grp" paramval:sort_grp];
	[AKSDKHelper setIntParam:&param paramName:@"&user_count" paramval:user_count];
	[AKSDKHelper setIntParam:&param paramName:@"&app_count" paramval:app_count];
	[AKSDKHelper setIntParam:&param paramName:@"&grp_count" paramval:grp_count];
    
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_SEARCH_SUGGESTIONS_INTEGRATE additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
}

-(AKWeiboResultCode) getSearchStatuses:(NSString *)q  filter_ori:(NSInteger) filter_ori   filter_pic:(NSInteger)filter_pic  fuid:(NSString *)fuid province:(NSInteger) province   city:(NSInteger)city  starttime:(NSString *)starttime endtime:(NSString *)endtime  count:(NSInteger) count page:(NSInteger) page  needcount:(BOOL)needcount  base_app:(NSInteger) base_app  pTask:(AKUserTaskInfo *) pTask{
                                      
                                      
	NSString * param;
    
	// Required params
	[AKSDKHelper setParam:&param paramname:@"&q" paramval:q];
	[AKSDKHelper setIntParam:&param paramName:@"&filter_ori" paramval:filter_ori];
	[AKSDKHelper setIntParam:&param paramName:@"&filter_pic" paramval:filter_pic];
	[AKSDKHelper setParam:&param paramname:@"&fuid" paramval:fuid];
	[AKSDKHelper setIntParam:&param paramName:@"&province" paramval:province];
	[AKSDKHelper setIntParam:&param paramName:@"&city" paramval:city];
	[AKSDKHelper setParam:&param paramname:@"&starttime" paramval:starttime];
	[AKSDKHelper setParam:&param paramname:@"&endtime" paramval:endtime];
	[AKSDKHelper setIntParam:&param paramName:@"&count" paramval:count];
	[AKSDKHelper setIntParam:&param paramName:@"&page" paramval:page];
	[AKSDKHelper setParam:&param paramname:@"&page" paramval:needcount ? @"true" : @""];
	[AKSDKHelper setIntParam:&param paramName:@"&base_app" paramval:base_app];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_SEARCH_STATUSES additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    //return _weiboMethod->cpp->getSearchStatuses([q UTF8String], (int) filter_ori , (int)filter_pic, [fuid UTF8String]
//      , (int) province , (int)city, [starttime UTF8String], [endtime UTF8String], (int) count
//      , (int) page, (BOOL)needcount, (int) base_app, (UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getSearchGeoStatuses:(float) longitude  latitudeconst:(float)latitudeconst  range:(NSInteger) range  time:(NSInteger) time sort_type:(NSInteger) sort_type  page:(NSInteger) page  count:(NSInteger) count  base_app:(NSInteger) base_app  pTask:(AKUserTaskInfo *) pTask{

    NSString * param;
    
	// Required params
    
	[AKSDKHelper setParam:&param paramname:@"&longitude" paramval:[NSString stringWithFormat:@"%fd",longitude]];
	[AKSDKHelper setParam:&param paramname:@"&latitudeconst" paramval:[NSString stringWithFormat:@"%fd",latitudeconst]];
	[AKSDKHelper setIntParam:&param paramName:@"&range" paramval:range];
	[AKSDKHelper setIntParam:&param paramName:@"&time" paramval:time];
	[AKSDKHelper setIntParam:&param paramName:@"&sort_type" paramval:sort_type];
	[AKSDKHelper setIntParam:&param paramName:@"&page" paramval:page];
	[AKSDKHelper setIntParam:&param paramName:@"&count" paramval:count];
	[AKSDKHelper setIntParam:&param paramName:@"&base_app" paramval:base_app];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_SEARCH_GEO_STATUSES additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->getSearchGeoStatuses((float) longitude, (float)latitudeconst, (int) range, (int) time, (int) sort_type, (int) page, (int) count, (int) base_app,(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getSearchUsers:(NSString *)q  snick:(NSInteger) snick  sdomain:(NSInteger) sdomain  sintro:(NSInteger) sintro  stag:(NSInteger) stag province:(NSInteger) province   city:(NSInteger)city  gender:(NSString *)gender  comorsch:(NSString *)comorsch   sort:(NSInteger) sort count:(NSInteger) count  page:(NSInteger) page  base_app:(NSInteger) base_app  pTask:(AKUserTaskInfo *) pTask{

    NSString * param;
    
	[AKSDKHelper setParam:&param paramname:@"&q" paramval:q];
	[AKSDKHelper setIntParam:&param paramName:@"&snick" paramval:snick];
	[AKSDKHelper setIntParam:&param paramName:@"&sdomain" paramval:sdomain];
	[AKSDKHelper setIntParam:&param paramName:@"&sintro" paramval:sintro];
	[AKSDKHelper setIntParam:&param paramName:@"&province" paramval:province];
	[AKSDKHelper setIntParam:&param paramName:@"&city" paramval:city];
	[AKSDKHelper setIntParam:&param paramName:@"&city" paramval:city];
	[AKSDKHelper setParam:&param paramname:@"&gender" paramval:gender];
	[AKSDKHelper setParam:&param paramname:@"&comorsch" paramval:comorsch];
	[AKSDKHelper setIntParam:&param paramName:@"&sort" paramval:sort];
	[AKSDKHelper setIntParam:&param paramName:@"&count" paramval:count];
	[AKSDKHelper setIntParam:&param paramName:@"&page" paramval:page];
	[AKSDKHelper setIntParam:&param paramName:@"&base_app" paramval:base_app];
    
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_SEARCH_USERS additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->getSearchUsers([q UTF8String], (int) snick, (int) sdomain, (int) sintro, (int) stag, (int) province, (int)city, [gender UTF8String], [comorsch UTF8String] , (int) sort, (int) count, (int) page, (int) base_app,(UserTaskInfo *)[pTask getCore]);

}


#pragma mark - 推荐读取
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 推荐读取
-(AKWeiboResultCode) getSuggestionsFavoritesHot:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    NSString * param;
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	//[AKSDKHelper setParam:&param paramname:@"&source" paramval:mAppKey.c_str()];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_SUGGESTIONS_FAVORITES_HOT additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->getSuggestionsFavoritesHot((VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getSuggestionsUsersHot:(NSString *)category  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{
    
    NSString * param;
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	[AKSDKHelper setParam:&param paramname:@"&category" paramval:category];
	//[AKSDKHelper setParam:&param paramname:@"&source" paramval:mAppKey.c_str()];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_SUGGESTIONS_USERS_HOT additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    

    //return _weiboMethod->cpp->getSuggestionsUsersHot([category UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getSuggestionsUsersMayInterested:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    NSString * param;
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	//[AKSDKHelper setParam:&param paramname:@"&source" paramval:mAppKey.c_str()];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_SUGGESTIONS_USERS_MAY_INTERESTED additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->getSuggestionsUsersMayInterested((VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getSuggestionsUsersByStatus:(NSString *)content   num:(NSInteger)num  url:(NSString *)url  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    NSString * param;
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	[AKSDKHelper setParam:&param paramname:@"&content" paramval:[self getNotNullString:content]];
	[AKSDKHelper setIntParam:&param paramName:@"&num" paramval:num];
	[AKSDKHelper setParam:&param paramname:@"&url" paramval:[self getNotNullString:url]];
	//[AKSDKHelper setParam:&param paramname:@"&source" paramval:mAppKey.c_str()];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_SUGGESTIONS_USERS_BY_STATUS additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->getSuggestionsUsersByStatus([content UTF8String], (int)num , [url UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}



#pragma mark - 推荐写入
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 推荐写入
-(AKWeiboResultCode) postSuggestionsUsersNotInterested:(NSString *)uid  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    if (!uid)
	{
		return AKWRC_USERID_NULL;
	}
    
	NSString * param;
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	[AKSDKHelper setParam:&param paramname:@"&uid" paramval:uid];
	//[AKSDKHelper setParam:&param paramname:@"&source" paramval:mAppKey.c_str()];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_POST_SUGGESTIONS_USERS_NOT_INTERESTED additionParam:param requestFormat:self.unifiedFormat httpMethod:@"POST" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->postSuggestionsUsersNotInterested([uid UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}


#pragma mark - 短链接口
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 短链接口
-(AKWeiboResultCode) getShortURLShorten:(NSArray *)longURLs  pTask:(AKUserTaskInfo *) pTask{
    
    if (!longURLs)
	{
		return AKWRC_INVALIDE_PARAM;
	}
    
	NSString * param;

    for(NSString * url in longURLs){
        
        [AKSDKHelper setParam:&param paramname:@"&url_short" paramval:url];
        
    }
    

	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_SHORT_URL_SHORTEN additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->getShortURLShorten([url_long UTF8String], (UserTaskInfo *)[pTask getCore]);
    
}

//-(AKWeiboResultCode) getShortURLShorten:(NSString *)url_long  pTask:(AKUserTaskInfo *) pTask{
//
//    if (!url_long)
//	{
//		return AKWRC_INVALIDE_PARAM;
//	}
//    
//	NSString * param;
//   
//    [AKSDKHelper setParam:&param paramname:@"&url_short" paramval:url_long];
//        
//
//	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_SHORT_URL_SHORTEN additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
//    
//	return [self startRequest:request];
//    
//    //return _weiboMethod->cpp->getShortURLShorten([url_long UTF8String], (UserTaskInfo *)[pTask getCore]);
//
//}


-(AKWeiboResultCode) getShortURLExpand:(NSArray *)url_shorts  pTask:(AKUserTaskInfo *) pTask{
    
    if (!url_shorts)
	{
		return AKWRC_INVALIDE_PARAM;
	}
    
    NSString * param;
    
    for(NSString * url in url_shorts){
    
        [AKSDKHelper setParam:&param paramname:@"&url_short" paramval:url];
    
    }
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_SHORT_URL_EXPAND additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    


}

//-(AKWeiboResultCode) getShortURLExpand:(NSString *)url_short  pTask:(AKUserTaskInfo *) pTask{
//
//
//    return AKWRC_OK;
//
//}

-(AKWeiboResultCode) getShortURLShareCounts:(NSString *)url_short  pTask:(AKUserTaskInfo *) pTask{

    if (!url_short)
	{
		return AKWRC_INVALIDE_PARAM;
	}
    
	NSString * param;
    [AKSDKHelper setParam:&param paramname:@"&url_short" paramval:[self getNotNullString:url_short]];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_SHORT_URL_SHARE_COUNTS additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    
    //return _weiboMethod->cpp->getShortURLShareCounts([url_short UTF8String], (UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getShortURLShareStatuses:(NSString *)url_short  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    
	if (!url_short)
	{
		return AKWRC_INVALIDE_PARAM;
	}
    
	// Required params
	NSString * param;
    [AKSDKHelper setParam:&param paramname:@"&url_short" paramval:[self getNotNullString:url_short]];
    // Variable params
	[AKSDKHelper makeVariableParams:&param length: 1024 var:var];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_SHORT_URL_SHARE_STATUSES additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->getShortURLShareStatuses([url_short UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getShortURLCommentCounts:(NSString *)url_short  pTask:(AKUserTaskInfo *) pTask{

    if (!url_short)
	{
		return AKWRC_INVALIDE_PARAM;
	}
    
	// Required params
	NSString * param;
    [AKSDKHelper setParam:&param paramname:@"&url_short" paramval:[self getNotNullString:url_short]];
    
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_SHORT_URL_COMMENT_COUNTS additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->getShortURLCommentCounts([url_short UTF8String], (UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getShortURLCommentComments:(NSString *)url_short  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{
    
    if (!url_short)
	{
		return AKWRC_INVALIDE_PARAM;
	}
    
	// Required params
	NSString * param;
    [AKSDKHelper setParam:&param paramname:@"&url_short" paramval:[self getNotNullString:url_short]];
    
	// Variable params
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_SHORT_URL_COMMENT_COMMENTS additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    

    //return _weiboMethod->cpp->getShortURLCommentComments([url_short UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getShortUrlInfo:(NSString *)shortUrlIDs  pTask:(AKUserTaskInfo *) pTask{

    if (!shortUrlIDs)
	{
		return AKWRC_INVALIDE_PARAM;
	}
    
	// Required params
	NSString * param;
    [AKSDKHelper setParam:&param paramname:@"&url_short" paramval:[self getNotNullString:shortUrlIDs]];
    
	// Request
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_SHORT_URL_INFO additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->getShortUrlInfo([shortUrlIDs UTF8String], (UserTaskInfo *)[pTask getCore]);

}



#pragma mark - 未读信息
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Unread
-(AKWeiboResultCode) getRemindUnreadCount:(NSString *)uid var:(AKVariableParams *) var pTask:(AKUserTaskInfo *) pTask{

    if (!uid)
	{
		return AKWRC_USERID_NULL;
	}
    
	NSString * param;
	[AKSDKHelper setParam:&param paramname:@"&uid" paramval:uid];
    [AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_REMIND_UNREAD_COUNT additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	//AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_REMIND_UNREAD_COUNT additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->getRemindUnreadCount([uid UTF8String], (UserTaskInfo *)[pTask getCore]);

}


-(NSString *)getSetCountTypeStringOfMessageType:(AKMessageType)messageType{
    
    /*
     follower：新粉丝数
     cmt：新评论数
     dm：新私信数
     mention_status：新提及我的微博数
     mention_cmt：新提及我的评论数
     group：微群消息数
     notice：新通知数
     invite：新邀请数
     badge：新勋章数
     photo：相册消息数
     close_friends_feeds：密友feeds未读数
     close_friends_mention_status：密友提及我的微博未读数
     close_friends_mention_cmt：密友提及我的评论未读数
     close_friends_cmt：密友评论未读数
     close_friends_attitude：密友表态未读数
     close_friends_common_cmt：密友共同评论未读数
     close_friends_invite：密友邀请未读数
     */
    switch (messageType) {
        case AKMessageTypeFollower:
            return @"follower";
            break;
            
        case AKMessageTypeComment:
            return @"cmt";
            break;
            
        case AKMessageTypeDirectMessage:
            return @"dm";
            break;
            
        case AKMessageTypeMentionStatus:
            return @"mention_status";
            break;
            
        case AKMessageTypeMentionComment:
            return @"mention_cmt";
            break;
            
        case AKMessageTypeGroup:
            return @"group";
            break;
            
        case AKMessageTypeNotice:
            return @"notice";
            break;
            
        case AKMessageTypeInvite:
            return @"invite";
            break;
            
        case AKMessageTypeBadge:
            return @"badge";
            break;
            
        case AKMessageTypePhoto:
            return @"photo";
            break;
            
        case AKMessageTypeCloseFriendsFeeds:
            return @"close_friends_feeds";
            break;
            
        case AKMessageTypeCloseFriendsMentionStatus:
            return @"close_friends_mention_status";
            break;
            
        case AKMessageTypeCloseFriendsMentionComment:
            return @"close_friends_mention_cmt";
            break;
            
        case AKMessageTypeCloseFriendsComment:
            return @"close_friends_cmt";
            break;
            
        case AKMessageTypeCloseFriendsAttitude:
            return @"close_friends_attitude";
            break;
            
        case AKMessageTypeCloseFriendsCommonComment:
            return @"close_friends_common_cmt";
            break;
            
        case AKMessageTypeCloseFriendsInvite:
            return @"close_friends_invite";
            
        default:
            return @"";
            break;
    }
    
}

-(AKWeiboResultCode) postStatusesResetCount:(AKMessageType)type  pTask:(AKUserTaskInfo *) pTask{

    NSString * param;
    [AKSDKHelper setParam:&param paramname:@"&type" paramval:[self getSetCountTypeStringOfMessageType:type]];
    
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_POST_STATUSES_RESET_COUNT additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
}


#pragma mark - 分组
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Groups
-(AKWeiboResultCode) getGroupsJoined:(NSString *)uid   page:(NSInteger)page   count:(NSInteger)count type:(NSInteger)type   filter:(NSInteger)filter   sort:(NSInteger)sort   member_limit:(NSInteger)member_limit   simplify:(NSInteger)simplify  pTask:(AKUserTaskInfo *) pTask{


    NSString * param;
	[AKSDKHelper setParam:&param paramname:@"&uid" paramval:uid];
	[AKSDKHelper setIntParam:&param paramName:@"&page" paramval:page];
	[AKSDKHelper setIntParam:&param paramName:@"&count" paramval:count];
	[AKSDKHelper setIntParam:&param paramName:@"&type" paramval:type];
	[AKSDKHelper setIntParam:&param paramName:@"&filter" paramval:filter];
	[AKSDKHelper setIntParam:&param paramName:@"&sort" paramval:sort];
	[AKSDKHelper setIntParam:&param paramName:@"&member_limit" paramval:member_limit];
	[AKSDKHelper setIntParam:&param paramName:@"&simplify" paramval:simplify];
    
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_GROUPS_JOINED additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->getGroupsJoined([uid UTF8String], (int)page, (int)count, (int)type, (int)filter, (int)sort, (int)member_limit, (int)simplify, (UserTaskInfo *)[pTask getCore]);
    

}

-(AKWeiboResultCode) getGroupsShowBatch:(NSString *)gids  pTask:(AKUserTaskInfo *) pTask{

    NSString * param;
	[AKSDKHelper setParam:&param paramname:@"&gids" paramval:gids];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_GROUPS_SHOW_BATCH additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->getGroupsShowBatch([gids UTF8String],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getGroupsGetAnnouncement:(NSString *)gid  pTask:(AKUserTaskInfo *) pTask{

    
	NSString * param;
	[AKSDKHelper setParam:&param paramname:@"&gid" paramval:gid];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_GROUPS_GET_ANNOUNCEMENT additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->getGroupsGetAnnouncement([gid UTF8String],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getGroupsAdmin:(NSString *)gid  pTask:(AKUserTaskInfo *) pTask{

    
	NSString * param;
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_GROUPS_ADMIN additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];

    
    //TODO: FIX IT
//	char finalURL[256] = { 0 };
//	sprintf(finalURL, ptr->mURL.c_str(), gid);
//	ptr->mURL = finalURL;
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->getGroupsAdmin([gid UTF8String],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getGroupsUsers:(NSString *)gid  var:(AKVariableParams*)var  pTask:(AKUserTaskInfo *) pTask{

    NSString * param;
    
	// Variable params
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_GROUPS_USERS additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
        //TODO: FIX IT
//	char finalURL[256] = { 0 };
//	sprintf(finalURL, ptr->mURL.c_str(), gid);
//	ptr->mURL = finalURL;
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->getGroupsUsers([gid UTF8String], (VariableParams *)[var getCore], (UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getGroupsSuggestionMayInterested:(NSInteger)count  pTask:(AKUserTaskInfo *) pTask{

    
    NSString * param;
	[AKSDKHelper setIntParam:&param paramName:@"&count" paramval:count];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_GROUPS_SUGGESTION_MAY_INTERESTED additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->getGroupsSuggestionMayInterested((int)count,(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getGroupsChatIsBlocked:(NSString *)gids  pTask:(AKUserTaskInfo *) pTask{

    NSString * param;
	[AKSDKHelper setParam:&param paramname:@"&gids" paramval:gids];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_GROUPS_CHAT_IS_BLOCKED additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->getGroupsChatIsBlocked([gids UTF8String],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) postGroupsChatBlock:(NSString *)gid  pTask:(AKUserTaskInfo *) pTask{

    
    NSString * param;
	[AKSDKHelper setParam:&param paramname:@"&gid" paramval:gid];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_GROUPS_CHAT_BLOCK additionParam:param requestFormat:self.unifiedFormat httpMethod:@"POST" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->postGroupsChatBlock([gid UTF8String],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) postGroupsChatUnblock:(NSString *)gid  pTask:(AKUserTaskInfo *) pTask{

    NSString * param;
	[AKSDKHelper setParam:&param paramname:@"&gid" paramval:gid];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_GROUPS_CHAT_UNBLOCK additionParam:param requestFormat:self.unifiedFormat httpMethod:@"POST" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->postGroupsChatUnblock([gid UTF8String],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getGroupsUsersJoinedStatuses:(NSString *)uid  simplify:(NSInteger)simplify var:(AKVariableParams *)var pTask:(AKUserTaskInfo *) pTask{

    NSString * param;
	[AKSDKHelper setParam:&param paramname:@"&uid" paramval:uid];
	[AKSDKHelper setIntParam:&param paramName:@"&simplify" paramval:simplify];
	[AKSDKHelper makeVariableParams:&param length: 255 var:var];
    
	AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_GROUP_USERS_JOINED_STATUSES additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    
	return [self startRequest:request];
    
    //return _weiboMethod->cpp->getGroupsUsersJoinedStatuses([uid UTF8String],(int)simplify,  (VariableParams *)[var getCore], (UserTaskInfo *)[pTask getCore]);

}


-(AKWeiboResultCode) getUsersGetTopStatus:(long)uid var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_USERS_GET_TOP_STATUS additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) postUsersSetTopStatus:(long)id var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_POST_USERS_SET_TOP_STATUS additionParam:param requestFormat:self.unifiedFormat httpMethod:@"POST" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) postUsersCancelTopStatus:(long)id var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_POST_USERS_CANCEL_TOP_STATUS additionParam:param requestFormat:self.unifiedFormat httpMethod:@"POST" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) getCommonCodeToLocation:(NSString *)codes var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_COMMON_CODE_TO_LOCATION additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) getCommonGetCity:(NSString *)province capital:(NSString *)capital language:(NSString *)language var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_COMMON_GET_CITY additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) getCommonGetProvince:(NSString *)country capital:(NSString *)capital language:(NSString *)language var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_COMMON_GET_PROVINCE additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) getCommonGetCountry:(NSString *)capital language:(NSString *)language var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_COMMON_GET_COUNTRY additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) getCommonGetTimezone:(NSString *)language var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_COMMON_GET_TIMEZONE additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) getPlacePublicTimeline:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_PLACE_PUBLIC_TIMELINE additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) getPlaceFriendsTimeline:(NSInteger)type var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_PLACE_FRIENDS_TIMELINE additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) getPlaceUserTimeline:(long)uid var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_PLACE_USER_TIMELINE additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) getPlacePoiTimeline:(NSString *)poiid var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_PLACE_POI_TIMELINE additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) getPlaceNearbyTimeline:(float)latitude longitude:(float)longitude range:(NSInteger)range starttime:(NSInteger)starttime endtime:(NSInteger)endtime offset:(NSInteger)offset var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_PLACE_NEARBY_TIMELINE additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) getPlaceStatusesShow:(long)id var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_PLACE_STATUSES_SHOW additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) getPlaceUsersShow:(long)uid var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_PLACE_USERS_SHOW additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) getPlaceUsersCheckins:(long)uid var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_PLACE_USERS_CHECKINS additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) getPlaceUsersPhotos:(long)uid var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_PLACE_USERS_PHOTOS additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) getPlaceUsersTips:(long)uid var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_PLACE_USERS_TIPS additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) getPlaceUsersTodos:(long)uid var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_PLACE_USERS_TODOS additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) getPlacePoisShow:(NSString *)poiid var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_PLACE_POIS_SHOW additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) getPlacePoisUsers:(NSString *)poiid var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_PLACE_POIS_USERS additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) getPlacePoisTips:(NSString *)poiid var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_PLACE_POIS_TIPS additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) getPlacePoisPhotos:(NSString *)poiid var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_PLACE_POIS_PHOTOS additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) getPlacePoisSearch:(NSString *)keyword city:(NSString *)city category:(NSString *)category var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_PLACE_POIS_SEARCH additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) getPlacePoisCategory:(NSInteger)pid flag:(NSInteger)flag var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_PLACE_POIS_CATEGORY additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) getPlaceNearbyPois:(float)latitude longitude:(float)longitude range:(NSInteger)range q:(NSString *)q category:(NSString *)category offset:(NSInteger)offset var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_PLACE_NEARBY_POIS additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) getPlaceNearbyUsers:(float)latitude longitude:(float)longitude range:(NSInteger)range starttime:(long)starttime endtime:(long)endtime offset:(NSInteger)offset var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_PLACE_NEARBY_USERS additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) getPlaceNearbyPhotos:(float)latitude longitude:(float)longitude range:(NSInteger)range starttime:(long)starttime endtime:(long)endtime offset:(NSInteger)offset var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_PLACE_NEARBY_PHOTOS additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) getPlaceNearbyUsersList:(float)latitude longitude:(float)longitude range:(NSInteger)range filter:(NSInteger)filter gender:(NSInteger)gender level:(NSInteger)level startbirth:(NSInteger)startbirth endbirth:(NSInteger)endbirth offset:(NSInteger)offset var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_PLACE_NEARBY_USERS_LIST additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) postPlacePoisCreate:(NSString *)title address:(NSString *)address category:(NSInteger)category lat:(float)latitude longitude:(float)longitude city:(NSString *)city province:(NSInteger)province country:(NSInteger)country phone:(NSString *)phone postcode:(NSString *)postcode extra:(NSString *)extra var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_POST_PLACE_POIS_CREATE additionParam:param requestFormat:self.unifiedFormat httpMethod:@"POST" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) postPlacePoisAddCheckin:(NSString *)poiid status:(NSString *)status pic:(NSImage *)pic isPublic:(NSInteger)isPublic var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_POST_PLACE_POIS_ADD_CHECKIN additionParam:param requestFormat:self.unifiedFormat httpMethod:@"POST" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) postPlacePoisAddPhoto:(NSString *)poiid status:(NSString *)status pic:(NSImage *)pic isPublic:(NSInteger)isPublic var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_POST_PLACE_POIS_ADD_PHOTO additionParam:param requestFormat:self.unifiedFormat httpMethod:@"POST" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) postPlacePoisAddTip:(NSString *)poiid status:(NSString *)status isPublic:(NSInteger)isPublic var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_POST_PLACE_POIS_ADD_TIP additionParam:param requestFormat:self.unifiedFormat httpMethod:@"POST" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) postPlacePoisAddTodo:(NSString *)poiid status:(NSString *)status isPublic:(NSInteger)isPublic var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_POST_PLACE_POIS_ADD_TODO additionParam:param requestFormat:self.unifiedFormat httpMethod:@"POST" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) postPlaceNearbyUsersCreate:(float)latitude longitude:(float)longitude var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_POST_PLACE_NEARBY_USERS_CREATE additionParam:param requestFormat:self.unifiedFormat httpMethod:@"POST" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) postPlaceNearbyUsersDestroy:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_POST_PLACE_NEARBY_USERS_DESTROY additionParam:param requestFormat:self.unifiedFormat httpMethod:@"POST" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) getLocationBaseGetMapImage:(NSString *)center_coordinate city:(NSString *)city coordinates:(NSString *)coordinates names:(NSString *)names offset_x:(NSString *)offset_x offset_y:(NSString *)offset_y font:(NSString *)font lines:(NSString *)lines polygons:(NSString *)polygons size:(NSString *)size format:(NSString *)format zoom:(NSString *)zoom scale:(BOOL)scale traffic:(BOOL)traffic var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_LOCATION_BASE_GET_MAP_IMAGE additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) getLocationGeoIpToGeo:(NSString *)ip var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_LOCATION_GEO_IP_TO_GEO additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) getLocationGeoAddressToGeo:(NSString *)address var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_LOCATION_GEO_ADDRESS_TO_GEO additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) getLocationGeoGeoToAddress:(NSString *)coordinate var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_LOCATION_GEO_GEO_TO_ADDRESS additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) getLocationGeoGpsToOffset:(NSString *)coordinate var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_LOCATION_GEO_GPS_TO_OFFSET additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) getLocationGeoIsDomestic:(NSString *)coordinates var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_LOCATION_GEO_IS_DOMESTIC additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) getLocationPoisSearchByLocation:(NSString *)q category:(NSString *)category city:(NSString *)city var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_LOCATION_POIS_SEARCH_BY_LOCATION additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) getLocationPoisSearchByGeo:(NSString *)q coordinate:(NSString *)coordinate cenname:(NSString *)cenname city:(NSString *)city range:(NSString *)range searchtype:(NSString *)searchtype srctype:(NSString *)srctype naviflag:(NSInteger)naviflag sr:(NSInteger)sr var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_LOCATION_POIS_SEARCH_BY_GEO additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) getLocationPoisSearchByArea:(NSString *)q category:(NSString *)category coordinates:(NSString *)coordinates city:(NSString *)city var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_LOCATION_POIS_SEARCH_BY_AREA additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) getLocationPoisShowBatch:(NSString *)srcids var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_LOCATION_POIS_SHOW_BATCH additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) postLocationPoisAdd:(NSInteger)srcid name:(NSString *)name address:(NSString *)address city_name:(NSString *)city_name category:(NSString *)category longitude:(NSString *)longitude latitude:(NSString *)latitude telephone:(NSString *)telephone pic_url:(NSString *)pic_url url:(NSString *)url tags:(NSString *)tags description:(NSString *)description intro:(NSString *)intro traffic:(NSString *)traffic var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_POST_LOCATION_POIS_ADD additionParam:param requestFormat:self.unifiedFormat httpMethod:@"POST" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) postLocationMobileGetLocation:(NSString *)json var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_POST_LOCATION_MOBILE_GET_LOCATION additionParam:param requestFormat:self.unifiedFormat httpMethod:@"POST" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) getLocationLineDriveRoute:(NSString *)begin_pid begin_coordinate:(NSString *)begin_coordinate end_pid:(NSString *)end_pid end_coordinate:(NSString *)end_coordinate type:(NSInteger)type var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_LOCATION_LINE_DRIVE_ROUTE additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) getLocationLineBusRoute:(NSString *)begin_pid begin_coordinate:(NSString *)begin_coordinate end_pid:(NSString *)end_pid end_coordinate:(NSString *)end_coordinate type:(NSInteger)type var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_LOCATION_LINE_BUS_ROUTE additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) getLocationLineBusLine:(NSString *)q city:(NSString *)city var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_LOCATION_LINE_BUS_LINE additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) getLocationLineBusStation:(NSString *)q city:(NSString *)city var:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT_GET_LOCATION_LINE_BUS_STATION additionParam:param requestFormat:self.unifiedFormat httpMethod:@"GET" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) LocationCitycode:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT__LOCATION_CITYCODE additionParam:param requestFormat:self.unifiedFormat httpMethod:@"" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) LocationCitycodeBus:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT__LOCATION_CITYCODE_BUS additionParam:param requestFormat:self.unifiedFormat httpMethod:@"" pTask:pTask];
    return [self startRequest:request];
    
}
-(AKWeiboResultCode) LocationCategory:(AKVariableParams *)var pTask:(AKUserTaskInfo *)pTask{
    NSString *param;
    [AKSDKHelper makeVariableParams:&param length:255 var:var];
    AKWeiboRequest *request = [self internalMakeWeiboRequest:AKWBOPT__LOCATION_CATEGORY additionParam:param requestFormat:self.unifiedFormat httpMethod:@"" pTask:pTask];
    return [self startRequest:request];
    
}


@end