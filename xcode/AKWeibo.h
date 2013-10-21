//
//  AKWeibo.h
//  weibosdk
//
//  Created by Kent Peifeng Ke on 13-10-18.
//
//

#import <Foundation/Foundation.h>
#import "AKWeiboDef.h"
#import "AKWeiboMethod.h"
#import "AKParsingObject.h"

@protocol weiboDelegate;

@protocol AKWeibo

-(NSInteger) startUp;
-(NSInteger) shutDown;
-(void)stopAll;
-(void)getOption:(AKWeiboOption)option,...;
-(void)setOption:(AKWeiboOption)option,...;
-(id<AKWeiboMethodProtocol>)getMethod;


@end

@protocol AKWeiboDelegate

-(void)OnDelegateComplated:(id<AKWeibo>)weibo methodOption:(NSUInteger)methodOption httpHeader:(NSString *)httpHeader result:(AKParsingObject *)result pTask:(AKUserTaskInfo *)pTask;

-(void)OnDelegateErrored:(id<AKWeibo>)weibo methodOption:(NSUInteger)methodOption errCode:(NSInteger)errCode subErrCode:(NSInteger)subErrCode result:(AKParsingObject *)result pTask:(AKUserTaskInfo *)pTask;

-(void)OnDelegateWillRelease:(id<AKWeibo>)weibo methodOption:(NSUInteger)methodOption pTask:(AKUserTaskInfo *)pTask;

@end


