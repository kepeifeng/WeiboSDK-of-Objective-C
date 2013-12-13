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
#import <AKVariableParams.h>
#import <AKParsingObject.h>


void testAKParsingObject(){
    
    NSString *source = @"{\"statuses\":[{\"created_at\":\"TueMay3117:46:55+08002011\",\"id\":11488058246,\"text\":\"求关注。\",\"source\":\"<ahref=\\\"http://weibo.com\\\"rel=\\\"nofollow\\\">新浪微博</a>\",\"favorited\":false,\"truncated\":false,\"in_reply_to_status_id\":\"\",\"in_reply_to_user_id\":\"\",\"in_reply_to_screen_name\":\"\",\"geo\":null,\"mid\":\"5612814510546515491\",\"reposts_count\":8,\"comments_count\":9,\"annotations\":[],\"user\":{\"id\":1404376560,\"screen_name\":\"zaku\",\"name\":\"zaku\",\"province\":\"11\",\"city\":\"5\",\"location\":\"北京朝阳区\",\"description\":\"人生五十年,乃如梦如幻；有生斯有死,壮士复何憾。\",\"url\":\"http://blog.sina.com.cn/zaku\",\"profile_image_url\":\"http://tp1.sinaimg.cn/1404376560/50/0/1\",\"domain\":\"zaku\",\"gender\":\"m\",\"followers_count\":1204,\"friends_count\":447,\"statuses_count\":2908,\"favourites_count\":0,\"created_at\":\"FriAug2800:00:00+08002009\",\"following\":false,\"allow_all_act_msg\":false,\"remark\":\"\",\"geo_enabled\":true,\"verified\":false,\"allow_all_comment\":true,\"avatar_large\":\"http://tp1.sinaimg.cn/1404376560/180/0/1\",\"verified_reason\":\"\",\"follow_me\":false,\"online_status\":0,\"bi_followers_count\":215}}],\"ad\":[{\"id\":3366614911586452,\"mark\":\"AB21321XDFJJK\"}],\"previous_cursor\":0,\"next_cursor\":11488013766,\"total_number\":81655}";
    AKParsingObject *obj = [[AKParsingObject alloc]initWithSource:source];
    
    id array = [obj getObject];
    
    NSDictionary *resultDictionary = (NSDictionary *)array;
    NSArray *statusArray = (NSArray *)[resultDictionary objectForKey:@"statuses"];
    NSDictionary *status = [statusArray objectAtIndex:0];
    //    NSDictionary *
    
    //assert(array != nil);
    
}

void testAKParsingObjectFromFile(){
    
    NSError *error;
    NSString *source =[NSString stringWithContentsOfFile:@"/Users/kent/Desktop/data(NSURLConnection).json" encoding:NSUTF8StringEncoding error:&error];
    AKParsingObject *obj = [[AKParsingObject alloc]initWithSource:source];
    
    id array = [obj getObject];
    
    NSDictionary *resultDictionary = (NSDictionary *)array;
    NSArray *statusArray = (NSArray *)[resultDictionary objectForKey:@"statuses"];
    NSDictionary *status = [statusArray objectAtIndex:0];
    //    NSDictionary *
    
    //assert(array != nil);
    
}

void getData(){

    NSURL *url = [NSURL URLWithString:@"https://api.weibo.com/2/statuses/home_timeline.json?access_token=2.0047eJnBwuHMpB596bbb5137sxwwOE"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    [[NSFileManager defaultManager] createFileAtPath:@"/Users/kent/Desktop/data.json" contents:data attributes:nil];
    

}
int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        //testAKParsingObjectFromFile();
        //getData();
        
        //NSString *source = @"{\"statuses\":\"哈哈\",\"ad\":[{\"key\":\"Yes\"}]}";

        
//        AKVariableParams *params = [[AKVariableParams alloc]init];
//      params.since_id = 123;
//        params.since_id = [@"1223423" longLongValue];
//        NSLog(@"%lld",params.since_id);
        
        
        Weibo *weibo = [[Weibo alloc]init];
        [weibo start];
        
        
        
    }
    return 0;
}

