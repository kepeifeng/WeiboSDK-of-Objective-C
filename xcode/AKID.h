//
//  AKID.h
//  weibosdk
//
//  Created by Kent Peifeng Ke on 13-10-17.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AKIDType){
    
    IDT_ID,
    IDT_SCREENNAME
    
};

@interface AKID : NSObject{

    AKIDType idType;
    NSString *id;
    NSString *key;

}


-(id)intiWithIdType:(AKIDType)type text:(NSString *) text key:(NSString *)key;

@property (readonly) BOOL isEmpty;


@end
