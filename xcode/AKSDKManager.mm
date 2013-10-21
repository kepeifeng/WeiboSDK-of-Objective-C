//
//  AKSDKManager.m
//  weibosdk
//
//  Created by Kent Peifeng Ke on 13-10-21.
//
//

#import "AKSDKManager.h"
#include "SDKManager.hxx"

using namespace weibo;

struct AKSDKManagerOpaque{

public:
    AKSDKManagerOpaque():cpp(){};
    AKSDKManagerOpaque(boost::shared_ptr<IWeibo> sdkManager){cpp = sdkManager;};
    boost::shared_ptr<IWeibo> cpp;



};


@implementation AKSDKManager

-(id)init{

    self = [super init];
    if(self){
    
        
        _sdkManagerOpaque = new AKSDKManagerOpaque(WeiboFactory::getWeibo());
    
    }
    
    return self;

}

-(id<AKWeiboMethodProtocol>)getMethod{
    
    if(!_weiboMethod){
        _weiboMethod = [[AKWeiboMethod alloc]init];
    }
    
    return _weiboMethod;

}

-(void)setOption:(AKWeiboOption)option, ...{

}

-(void)getOption:(AKWeiboOption)option, ...{

}

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
