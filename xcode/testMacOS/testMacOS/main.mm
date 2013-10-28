//
//  main.m
//  testMacOS
//
//  Created by Kent Peifeng Ke on 13-10-24.
//  Copyright (c) 2013年 Kent Peifeng Ke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AKWeiboFactory.h>
#import "Weibo.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        

        Weibo *weibo = [[Weibo alloc]init];
        [weibo start];
        
        
    }
    return 0;
}

