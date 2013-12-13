//
//  AKSDKHelper.h
//  weibosdk
//
//  Created by Kent on 13-12-6.
//
//

#import <Foundation/Foundation.h>
#import "AKWeiboDef.h"
#import "AKWeiboMethod.h"
#import "AKWeiboRequest.h"
#import "AKID.h"
#import "AKVariableParams.h"

typedef NS_ENUM(NSUInteger, AKHostType){

    AKHostTypeEHT_V3,
    AKHostTypeEHT_V4
    

};

@interface AKTagMethodURLElement : NSObject

-(id)initWithOption:(AKMethodAction)option URL:(NSString *)url;
-(id)initWithOption:(AKMethodAction)option URL:(NSString *)url hostType:(AKHostType)hostType;

@property AKMethodAction option;
@property NSString *url;
@property AKHostType hostType;

@end

@interface AKSDKHelper : NSObject

+(NSArray *)getMethodURLElement;
+(NSString *)getMethodBaseURL:(AKHostType)hostType;
+(NSString *) getMethodURLFromOption:(NSUInteger)methodOption;
//+(NSInteger)convertEngineErrorToSDKError:(NSInteger) code;

/** Param setting function */

+(void) setParam:(NSString **) param paramname:(NSString *)paramname paramval:(NSString *)paramval;
+(void) setParam:(NSString **) param paramname:(NSString *)paramname paramval:(NSString *)paramval paramformat:(NSInteger)paramformat;

+(void) setIntParam:(NSString **)param paramName:(NSString *)paramName paramval:(long long)paramval;
+(void) setIntParam:(NSString **)param paramName:(NSString *)paramName paramval:(long long)paramval forceAdd:(BOOL)forceAdd;

/** Split string */
//+(void) split(std::vector<NSString *>& outVector, const char* string, const char splite);

+(AKWeiboRequest *)makeRequest:(NSUInteger)methodOption addtionParam:(NSString *)addtionParam reqformat:(AKWeiboRequestFormat)reqformat httpMethod:(NSString *)httpMethod appkey:(NSString *)appkey accessToken:(NSString *)accessToken pTask:(AKUserTaskInfo*) pTask;

+(void) makeRequestURL:(NSString **)outURL outParam:(NSString **)outParam baseURL:(NSString *)baseURL isPost:(BOOL)isPost appkey:(NSString *)appKey accessToken:(NSString *)accessToken;

+(void) makeIDParams:(NSString **)outParam length:(NSInteger)length userID:(AKID *)userID;

+(void) makeVariableParams:(NSString **)outParam length:(NSInteger)length  var:(AKVariableParams*)var;
@end
