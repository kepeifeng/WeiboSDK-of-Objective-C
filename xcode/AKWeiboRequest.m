//
//  AKWeiboRequest.m
//  weibosdk
//
//  Created by Kent on 13-12-6.
//
//

#import "AKWeiboRequest.h"
#import "NSString+NSString_Extended.h"

@implementation AKWeiboRequest

@synthesize taskID = _taskID;

-(void)makeUploadTaskDetail:(NSString *)file{


}

-(NSString *)taskID{

    if(!_taskID){
        _taskID = [self generateUUID];
    }
    
    return _taskID;
    
}


- (NSString *)generateUUID
{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    return (__bridge NSString *)uuidStringRef;
}
@end
