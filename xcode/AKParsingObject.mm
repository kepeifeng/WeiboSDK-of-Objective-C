//
//  AKParsingObject.m
//  weibosdk
//
//  Created by Kent Peifeng Ke on 13-10-18.
//
//

#import "AKParsingObject.h"
#include "ParsingObject.hxx"
#include "ParsingHandle.hxx"
#include "AKParsingMidCallback.h"
#include <string.h>

using namespace weibo;

struct AKParsingObjectOpaque{

public:
    AKParsingObjectOpaque(const char* source){parsingObject = new ParsingObject(source);};
    AKParsingObjectOpaque(boost::shared_ptr<weibo::ParsingHandle> actHandlPtr){parsingObject = new ParsingObject(actHandlPtr);};
    AKParsingObjectOpaque(weibo::ParsingObject& object){parsingObject = new ParsingObject(object);};
    weibo::ParsingObject *parsingObject;
    

};

@implementation AKParsingObject{

    AKParsingMidCallback *parsingMidCallback;
    NSDictionary *_dictionary;

}
@synthesize originData = _originData;

-(id)initWithData:(NSData *)data{

    self = [super init];
    if(self){
        self.originData = data;
        
    }
    return self;
}


-(id)initWithOpaque:(AKParsingObjectOpaque *)opaque{

    self = [super init];
    if(self){
    
        _cpp = opaque;
        parsingMidCallback = new AKParsingMidCallback(self);
    }
    return self;
    
}


-(id)initWithObject:(void *)object{

    self = [super init];
    if(self){
        
        _cpp = new AKParsingObjectOpaque(*(ParsingObject *)object);
        parsingMidCallback = new AKParsingMidCallback(self);
    }
    return self;


}

-(id)initWithSource:(NSString *)source{

    self = [super init];
    if(self){
    
        _cpp = new AKParsingObjectOpaque([source UTF8String]);
        parsingMidCallback = new AKParsingMidCallback(self);
    
    }
    return self;
}

-(NSString *)getErrorMessage{
    
    
    return [NSString stringWithUTF8String:_cpp->parsingObject->getErrorMessage()];
    //return [NSString stringWithCString: _cpp->parsingObject->getErrorMessage() encoding:NSUTF8StringEncoding];

}

-(NSString *)getOriginString{
    
    NSString *source = [NSString stringWithUTF8String:_cpp->parsingObject->getOriginString()];
    source = [self stringByRemovingControlCharacters:source];
    if(source.length>0 && ![source hasSuffix:@"}"]){
        
        NSRange jsonShouldEndAt = [source rangeOfString:@"}" options:NSBackwardsSearch];
        source = [source substringToIndex:jsonShouldEndAt.location+jsonShouldEndAt.length];
        
    }
    
    return source;
    //return [NSString stringWithCString:_cpp->parsingObject->getOriginString() encoding:NSUTF8StringEncoding];

}

- (NSString *)stringByRemovingControlCharacters: (NSString *)inputString
{
    NSCharacterSet *controlChars = [NSCharacterSet controlCharacterSet];
    NSRange range = [inputString rangeOfCharacterFromSet:controlChars];
    if (range.location != NSNotFound) {
        NSMutableString *mutableString = [NSMutableString stringWithString:inputString];
        while (range.location != NSNotFound) {
            [mutableString deleteCharactersInRange:range];
            range = [mutableString rangeOfCharacterFromSet:controlChars];
        }
        return mutableString;
    }
    return inputString;
}

-(NSArray *)getKeyName{
    
    //return [NSString stringwith:_cpp->parsingObject->getKeyName() encoding:NSUTF8StringEncoding];
    //return [NSString stringWithUTF8String:_cpp->parsingObject->getKeyName().c_str()];
    return [_dictionary allKeys];
    

}
//
//-(NSString *)asAString{
//    
//    return [NSString stringWithUTF8String:_cpp->parsingObject->asAString().c_str()];
//
//}
//
//-(long long)asANumberic{
//    
//    return _cpp->parsingObject->asANumberic();
//
//}

-(NSUInteger)getSubCounts{
    
    return [_dictionary count];
    //return _cpp->parsingObject->getSubCounts();

}

-(NSNumber *)getSubNumbericByKey:(NSString *)key{

    return (NSNumber *)[_dictionary objectForKey:key];
    //return _cpp->parsingObject->getSubCounts();
}

-(NSString *)getSubStringByKey:(NSString *)key{

    
    return (NSString *)[_dictionary objectForKey:key];
    //std::string subString =  _cpp->parsingObject->getSubStringByKey([key UTF8String]);
    
    //return [NSString stringWithUTF8String:subString.c_str()];
    
    
}

-(id)getSubObjectByKey:(NSString *)key{

    return [_dictionary objectForKey:key];
    //
//    boost::shared_ptr<weibo::ParsingObject> result = _cpp->parsingObject->getSubObjectByKey([key cStringUsingEncoding:NSUTF8StringEncoding]);
//    
//    AKParsingObjectOpaque *newParsingObjectOpaque = new AKParsingObjectOpaque(*result.get());
//    AKParsingObject *newParsingObject = [[AKParsingObject alloc]initWithOpaque:newParsingObjectOpaque];
//    return newParsingObject;
    

}

-(long long)getSubNumbericByIndex:(NSInteger)index{
    
    return _cpp->parsingObject->getSubNumbericByIndex((int)index);


}


-(NSString *)getSubStringByIndex:(NSInteger)index{
    
    return [NSString stringWithUTF8String:_cpp->parsingObject->getSubStringByIndex((int)index).c_str()];

}

-(AKParsingObject *)getSubObjectByIndex:(NSInteger)index{
    
    boost::shared_ptr<weibo::ParsingObject> result = _cpp->parsingObject->getSubObjectByIndex((int)index);

    AKParsingObjectOpaque *newParsingObjectOpaque = new AKParsingObjectOpaque(*result.get());
    AKParsingObject *newParsingObject = [[AKParsingObject alloc]initWithOpaque:newParsingObjectOpaque];
    return newParsingObject;

}

-(NSData *)originData{

    return _originData;
}

-(void)setOriginData:(NSData *)originData{

    _originData = originData;
//    NSObject *object = (NSObject *)[self getObject];
//    if([object isKindOfClass:[NSDictionary class]]){
//        
//        _dictionary = (NSDictionary *)object;
//        
//    }
    

}

-(void) enumAllSubWithUserData:(id)userData{

  //_cpp->parsingObject->enumAllSub(enumAllSubCallback, (__bridge void*)userData);
    
    //weibo::ParsingObject::EnumAllSubCall pEnumAllSubCall = AKParsingMidCallback::enumAllSubCallback;
    //parsingMidCallback->enumAllSub((__bridge void*)userData);
    //_cpp->parsingObject->enumAllSub(pEnumAllSubCall, (__bridge void*)userData);
    

}

-(void) callDelegate:(AKParsingObject *)parsingObject userData:(id)userData{


}


-(BOOL)isUseable{
    
    return (_originData != nil);
    //return _cpp->parsingObject->isUseable();
    
}

-(id)getObject{
    
    NSData *data;
    
    data = self.originData;
//    
//    if(self.originData){
//        
//        data = self.originData;
//        
//    }
//    else{
//        
//        NSString *originString = [self getOriginString];
//        if(originString.length>0 && ![originString hasSuffix:@"}"]){
//            
//            NSRange jsonShouldEndAt = [originString rangeOfString:@"}" options:NSBackwardsSearch];
//            originString = [originString substringToIndex:jsonShouldEndAt.location+jsonShouldEndAt.length];
//            
//        }
//        data = [originString dataUsingEncoding:NSUnicodeStringEncoding];
//    }
    
    // probably check here that returnedData isn't nil; attempting
    // NSJSONSerialization with nil data raises an exception, and who
    // knows how your third-party library intends to react?
    
    
    if(NSClassFromString(@"NSJSONSerialization"))
    {
        NSError *error = nil;
        
        id object = [NSJSONSerialization
                     JSONObjectWithData:data
                     options:0
                     error:&error];
        
        
        if(error) { /* JSON was malformed, act appropriately here */ }
        
        // the originating poster wants to deal with dictionaries;
        // assuming you do too then something like this is the first
        // validation step:
        
        return object;
    }
    else
    {
        // the user is using iOS 4; we'll need to use a third-party solution.
        // If you don't intend to support iOS 4 then get rid of this entire
        // conditional and just jump straight to
        // NSError *error = nil;
        // [NSJSONSerialization JSONObjectWithData:...
    }
    
    
    return nil;
    //    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:20];
    //    _cpp->parsingObject->enumAllSub(enumAllSubCallback, (__bridge void*)dictionary);
    //    return dictionary;


}

@end





