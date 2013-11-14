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
    AKParsingObjectOpaque(const char* source):parsingObject(source){};
    AKParsingObjectOpaque(boost::shared_ptr<weibo::ParsingHandle> actHandlPtr):parsingObject(actHandlPtr){};
    AKParsingObjectOpaque(weibo::ParsingObject& object):parsingObject(object){};
    weibo::ParsingObject parsingObject;
    

};

@implementation AKParsingObject{

    AKParsingMidCallback *parsignMidCallback;

}


-(id)initWithOpaque:(AKParsingObjectOpaque *)opaque{

    self = [super init];
    if(self){
    
        _cpp = opaque;
        parsignMidCallback = new AKParsingMidCallback(self);
    }
    return self;
    
}


-(id)initWithObject:(void *)object{

    self = [super init];
    if(self){
        
        _cpp = new AKParsingObjectOpaque(*(ParsingObject *)object);
        parsignMidCallback = new AKParsingMidCallback(self);
    }
    return self;


}

-(NSString *)getErrorMessage{
    
    
    return [NSString stringWithUTF8String:_cpp->parsingObject.getErrorMessage()];
    //return [NSString stringWithCString: _cpp->parsingObject.getErrorMessage() encoding:NSUTF8StringEncoding];

}

-(NSString *)getOriginString{
    
    return  [NSString stringWithUTF8String:_cpp->parsingObject.getOriginString()];
    //return [NSString stringWithCString:_cpp->parsingObject.getOriginString() encoding:NSUTF8StringEncoding];

}

-(NSString *)getKeyName{
    
    //return [NSString stringwith:_cpp->parsingObject.getKeyName() encoding:NSUTF8StringEncoding];
    return [NSString stringWithUTF8String:_cpp->parsingObject.getKeyName().c_str()];
    

}

-(NSString *)asAString{
    
    return [NSString stringWithUTF8String:_cpp->parsingObject.asAString().c_str()];

}

-(long long)asANumberic{
    
    return _cpp->parsingObject.asANumberic();

}

-(NSUInteger)getSubCounts{
    
    return _cpp->parsingObject.getSubCounts();

}

-(long long)getSubNumbericByKey:(NSString *)key{

    return _cpp->parsingObject.getSubCounts();
}

-(NSString *)getSubStringByKey:(NSString *)key{

//    std::string cppString([key cStringUsingEncoding:NSUTF8StringEncoding]);
//    std::string subString = _cpp->parsingObject.getSubStringByKey(cppString);
//    
    std::string subString =  _cpp->parsingObject.getSubStringByKey([key UTF8String]);
    
    return [NSString stringWithUTF8String:subString.c_str()];
    
    
}

-(AKParsingObject *)getSubObjectByKey:(NSString *)key{
    
    boost::shared_ptr<weibo::ParsingObject> result = _cpp->parsingObject.getSubObjectByKey([key cStringUsingEncoding:NSUTF8StringEncoding]);
    
    AKParsingObjectOpaque *newParsingObjectOpaque = new AKParsingObjectOpaque(*result.get());
    AKParsingObject *newParsingObject = [[AKParsingObject alloc]initWithOpaque:newParsingObjectOpaque];
    return newParsingObject;
    

}

-(long long)getSubNumbericByIndex:(NSInteger)index{
    
    return _cpp->parsingObject.getSubNumbericByIndex((int)index);


}


-(NSString *)getSubStringByIndex:(NSInteger)index{
    
    return [NSString stringWithUTF8String:_cpp->parsingObject.getSubStringByIndex((int)index).c_str()];

}

-(AKParsingObject *)getSubObjectByIndex:(NSInteger)index{
    
    boost::shared_ptr<weibo::ParsingObject> result = _cpp->parsingObject.getSubObjectByIndex((int)index);

    AKParsingObjectOpaque *newParsingObjectOpaque = new AKParsingObjectOpaque(*result.get());
    AKParsingObject *newParsingObject = [[AKParsingObject alloc]initWithOpaque:newParsingObjectOpaque];
    return newParsingObject;

}

-(void) enumAllSubWithUserData:(id)userData{

  //_cpp->parsingObject.enumAllSub(enumAllSubCallback, (__bridge void*)userData);
    
    //weibo::ParsingObject::EnumAllSubCall pEnumAllSubCall = AKParsingMidCallback::enumAllSubCallback;
    //parsignMidCallback->enumAllSub((__bridge void*)userData);
    //_cpp->parsingObject.enumAllSub(pEnumAllSubCall, (__bridge void*)userData);
    

}

-(void) callDelegate:(AKParsingObject *)parsingObject userData:(id)userData{


}


-(BOOL)isUseable{
    
    return _cpp->parsingObject.isUseable();
    
}

-(NSDictionary *)getDictionaryObject{
    
    NSString *originString = [self getOriginString];
    if(originString.length>0 && ![originString hasSuffix:@"}"]){
    
        NSRange jsonShouldEndAt = [originString rangeOfString:@"}" options:NSBackwardsSearch];
        originString = [originString substringToIndex:jsonShouldEndAt.location+jsonShouldEndAt.length];
    
    }
    NSData *returnedData = [originString dataUsingEncoding:NSUnicodeStringEncoding];
    //NSLog(@"%@",originString);
    //NSString *string = [self getOriginString];
    
    
    // probably check here that returnedData isn't nil; attempting
    // NSJSONSerialization with nil data raises an exception, and who
    // knows how your third-party library intends to react?
    NSDictionary *dictionary;
    
    if(NSClassFromString(@"NSJSONSerialization"))
    {
        NSError *error = nil;
        
        id object = [NSJSONSerialization
                     JSONObjectWithData:returnedData
                     options:0
                     error:&error];
        
        if(error) { /* JSON was malformed, act appropriately here */ }
        
        // the originating poster wants to deal with dictionaries;
        // assuming you do too then something like this is the first
        // validation step:
        if([object isKindOfClass:[NSDictionary class]])
        {
            dictionary =(NSDictionary *) object;
            /* proceed with results as you like; the assignment to
             an explicit NSDictionary * is artificial step to get
             compile-time checking from here on down (and better autocompletion
             when editing). You could have just made object an NSDictionary *
             in the first place but stylistically you might prefer to keep
             the question of type open until it's confirmed */
        }
        else
        {
            /* there's no guarantee that the outermost object in a JSON
             packet will be a dictionary; if we get here then it wasn't,
             so 'object' shouldn't be treated as an NSDictionary; probably
             you need to report a suitable error condition */
        }
    }
    else
    {
        // the user is using iOS 4; we'll need to use a third-party solution.
        // If you don't intend to support iOS 4 then get rid of this entire
        // conditional and just jump straight to
        // NSError *error = nil;
        // [NSJSONSerialization JSONObjectWithData:...
    }
    

    return dictionary;
//    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:20];
//    _cpp->parsingObject.enumAllSub(enumAllSubCallback, (__bridge void*)dictionary);
//    return dictionary;
}

static void enumAllSubCallback(const boost::shared_ptr<ParsingObject> object, void* usrData){
    
    NSLog(@"%@",[NSString stringWithUTF8String:object->getKeyName().c_str()]);
    
}

@end





