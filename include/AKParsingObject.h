//
//  AKParsingObject.h
//  weibosdk
//
//  Created by Kent Peifeng Ke on 13-10-18.
//
//

#import <Foundation/Foundation.h>
#import "AKParsingHandle.h"

@protocol AKParsingObjectDelegate;

struct AKParsingObjectOpaque;
@interface AKParsingObject : NSObject{

    //AKParsingHandle *mParasingHandle;
    struct AKParsingObjectOpaque *_cpp;
    
}

//
//-(id)initWithSource:(NSString *)source;
//-(id)initWithHandler:(AKParsingHandle *) actHandlePtr;
//-(id)initWithParsingObject:(AKParsingObject *)object;

-(id)initWithOpaque:(struct AKParsingObjectOpaque *)opaque;
-(id)initWithData:(NSData *)data;
-(id)initWithObject:(void *)object;
-(id)initWithSource:(NSString *)source;

//-(void)dealloc;

//-(NSString *)getErrorMessage;
//-(NSString *)getOriginString;

//-(NSString *)getKeyName;
//-(NSString *)asAString;
//-(long long)asANumberic;

//-(NSUInteger)getSubCounts;

//-(NSNumber *)getSubNumbericByKey:(NSString *)key;
//-(NSString *)getSubStringByKey:(NSString *)key;
//-(AKParsingObject *)getSubObjectByKey:(NSString *)key;

//-(long long)getSubNumbericByIndex:(NSInteger)index;
//-(NSString *)getSubStringByIndex:(NSInteger)index;
//-(id)getSubObjectByIndex:(NSInteger)index;

//-(void) enumAllSubWithUserData:(id)userData;
//-(NSDictionary *)getDictionaryObject;


/**
 *  Return a Serialized JSON object. The return object can be a NSArray or a NSDictionary
 *
 *  @return Can be a NSArray or a NSDictionary.
 */
-(id)getObject;

@property NSData *originData;
@property NSString *accessToken;

@property id<AKParsingObjectDelegate> delegate;
@property (readonly, nonatomic) BOOL isUseable;



@end


@protocol AKParsingObjectDelegate


-(void)enumAllSubCall:(AKParsingObject *)parsingObject userData:(id)userData;

@end