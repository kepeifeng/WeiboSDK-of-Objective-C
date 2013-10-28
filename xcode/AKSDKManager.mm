//
//  AKSDKManager.m
//  weibosdk
//
//  Created by Kent Peifeng Ke on 13-10-21.
//
//

#import "AKSDKManager.h"
#include "SDKManager.hxx"
#include "AKParsingMidCallback.h"

using namespace weibo;



//void OnDelegateComplated(unsigned int methodOption, const char* httpHeader, ParsingObject* result, const UserTaskInfo* pTask){
//
//    
//}

struct AKSDKManagerOpaque{

public:
    AKSDKManagerOpaque():cpp(){};
    AKSDKManagerOpaque(boost::shared_ptr<IWeibo> sdkManager){cpp = sdkManager;};
    boost::shared_ptr<IWeibo> cpp;



};


@implementation AKSDKManager

@synthesize delegate = _delegate;

-(id)init{

    self = [super init];
    if(self){
    
        _sdkManagerOpaque = new AKSDKManagerOpaque(WeiboFactory::getWeibo());
        
        _weiboMethod = [[AKWeiboMethod alloc]initWithObject:_sdkManagerOpaque->cpp->getMethod()];
        
        _sdkManagerOpaque->cpp->OnDelegateComplated = &AKParsingMidCallback::OnDelegateComplated;
        _sdkManagerOpaque->cpp->OnDelegateErrored = &AKParsingMidCallback::OnDelegateErrored;
        _sdkManagerOpaque->cpp->OnDelegateWillRelease = &AKParsingMidCallback::OnDelegateWillRelease;
    }
    
    return self;

}

-(id<AKWeiboMethodProtocol>)getMethod{
    
    if(!_weiboMethod){
        _weiboMethod = [[AKWeiboMethod alloc]initWithObject:_sdkManagerOpaque->cpp->getMethod()];
        
    }
    
    return _weiboMethod;

}

- (id<AKWeiboDelegate>)delegate{

    return _delegate;
    
}

-(void)setDelegate:(id<AKWeiboDelegate>)delegate{

    _delegate = delegate;
    AKParsingMidCallback::weibo = self;
    AKParsingMidCallback::weiboDelegate = delegate;

}



-(void)getOption:(AKWeiboOption)option, ...{

}


#pragma mark - Options Setters and Getters

-(void)setConsumer:(NSString *)key secret:(NSString *)secret{

    _sdkManagerOpaque->cpp->setOption(weibo::WOPT_CONSUMER,[key UTF8String],[secret UTF8String]);

}

-(void)setProxy:(AKWeiboProxyType)proxyType server:(NSString *)server port:(NSInteger)port username:(NSString *)username password:(NSString *)password{

    _sdkManagerOpaque->cpp->setOption(weibo::WOPT_PROXY,(int)proxyType, [server UTF8String], (int)port, [username UTF8String], [password UTF8String]);

}

-(void)setResponseFormat:(AKWeiboRequestFormat)format{

    _sdkManagerOpaque->cpp->setOption(weibo::WOPT_RESPONSE_FORMAT, (weibo::eWeiboRequestFormat)format);

}

-(void)setAccessToken:(NSString *)token{

    _sdkManagerOpaque->cpp->setOption(weibo::WOPT_ACCESS_TOKEN, [token UTF8String]);


}

-(void)setLogFile:(NSString *)filepath{

    _sdkManagerOpaque->cpp->setOption(weibo::WOPT_LOG_FILE, [filepath UTF8String]);

}

#pragma mark - Public Methods

-(NSInteger)startUp{
    
    return _sdkManagerOpaque->cpp->startup();

}

-(NSInteger)shutDown{
    
    return _sdkManagerOpaque->cpp->shutdown();

}

-(void)stopAll{

    _sdkManagerOpaque->cpp->stopAll();

}

@end


AKParsingMidCallback::AKParsingMidCallback(AKParsingObject* ocObject):m_ocObject(ocObject){}

AKParsingMidCallback::~AKParsingMidCallback(){}

id<AKWeiboDelegate> AKParsingMidCallback::weiboDelegate;
id<AKWeibo> AKParsingMidCallback::weibo;

void AKParsingMidCallback::OnDelegateComplated(unsigned int methodOption, const char *httpHeader, weibo::ParsingObject *result, const weibo::UserTaskInfo *pTask){

    if(!weiboDelegate){
        return;
    }
    
    [weiboDelegate OnDelegateComplated:weibo methodOption:(NSUInteger)methodOption httpHeader:[NSString stringWithUTF8String:httpHeader] result:[[AKParsingObject alloc]initWithObject:result] pTask:[[AKUserTaskInfo alloc] initWithObject:(void *)pTask]];
    
}

void AKParsingMidCallback::OnDelegateErrored(unsigned int methodOption, const int errCode, const int subErrCode, ParsingObject* result, const UserTaskInfo* pTask){
    
    if(!weiboDelegate){
        return;
    }
    
    [weiboDelegate OnDelegateErrored:weibo methodOption:(NSUInteger)methodOption errCode:(NSInteger)errCode subErrCode:(NSInteger)subErrCode result:[[AKParsingObject alloc]initWithObject:result] pTask:[[AKUserTaskInfo alloc] initWithObject:(void *)pTask]];
}

void AKParsingMidCallback::OnDelegateWillRelease(unsigned int methodOption, const UserTaskInfo* pTask){

    if(!weiboDelegate){
        return;
    }
    
    [weiboDelegate OnDelegateWillRelease:weibo methodOption:(NSUInteger)methodOption  pTask:[[AKUserTaskInfo alloc] initWithObject:(void *)pTask]];

}


