//
//  AKWeiboFactory.m
//  weibosdk
//
//  Created by Kent Peifeng Ke on 13-10-21.
//
//

#import "AKWeiboFactory.h"
#include "IWeibo.hxx"
#include "AKSDKManager.h"


@implementation AKWeiboFactory
static id<AKWeibo> _weibo;

+(id<AKWeibo>)getWeibo{

    if(!_weibo){
    
        _weibo = [[AKSDKManager alloc]init];
    
    }
    
    
    return _weibo;


}

@end
