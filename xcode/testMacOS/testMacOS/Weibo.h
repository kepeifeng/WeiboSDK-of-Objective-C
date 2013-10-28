//
//  Weibo.h
//  testMacOS
//
//  Created by Kent Peifeng Ke on 13-10-24.
//  Copyright (c) 2013年 Kent Peifeng Ke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AKWeibo.h>

@interface Weibo : NSObject<AKWeiboDelegate>

-(void)start;

@end
