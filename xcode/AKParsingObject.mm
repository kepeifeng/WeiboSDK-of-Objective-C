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
    std::string subString =  _cpp->parsingObject.getSubStringByKey([key cStringUsingEncoding:NSUTF8StringEncoding]);
    
    return [NSString stringWithUTF8String:subString.c_str()];
    
    
}

-(AKParsingObject *)getSubObjectByKey:(NSString *)key{
    
    boost::shared_ptr<weibo::ParsingObject> result = _cpp->parsingObject.getSubObjectByKey([key cStringUsingEncoding:NSUTF8StringEncoding]);
    
    AKParsingObjectOpaque *newParsingObjectOpaque = new AKParsingObjectOpaque(*result.get());
    AKParsingObject *newParsingObject = [[AKParsingObject alloc]initWithOpaque:newParsingObjectOpaque];
    return newParsingObject;
    

}

-(long long)getSubNumbericByIndex:(NSInteger)index{
    
    return _cpp->parsingObject.getSubNumbericByIndex(index);


}


-(NSString *)getSubStringByIndex:(NSInteger)index{
    
    return [NSString stringWithUTF8String:_cpp->parsingObject.getSubStringByIndex(index).c_str()];

}

-(AKParsingObject *)getSubObjectByIndex:(NSInteger)index{
    
    boost::shared_ptr<weibo::ParsingObject> result = _cpp->parsingObject.getSubObjectByIndex(index);

    AKParsingObjectOpaque *newParsingObjectOpaque = new AKParsingObjectOpaque(*result.get());
    AKParsingObject *newParsingObject = [[AKParsingObject alloc]initWithOpaque:newParsingObjectOpaque];
    return newParsingObject;

}

-(void) enumAllSubWithUserData:(id)userData{

  //_cpp->parsingObject.enumAllSub(enumAllSubCallback, (__bridge void*)userData);
    
    //weibo::ParsingObject::EnumAllSubCall pEnumAllSubCall = AKParsingMidCallback::enumAllSubCallback;
    parsignMidCallback->enumAllSub((__bridge void*)userData);
    //_cpp->parsingObject.enumAllSub(pEnumAllSubCall, (__bridge void*)userData);
    

}

-(void) callDelegate:(AKParsingObject *)parsingObject userData:(id)userData{


}


-(BOOL)isUseable{
    
    return _cpp->parsingObject.isUseable();
    
}

@end

void enumAllSubCallback2(const boost::shared_ptr<ParsingObject> object, void* usrData){

    
}


AKParsingMidCallback::AKParsingMidCallback(AKParsingObject* ocObject):m_ocObject(ocObject){}

AKParsingMidCallback::~AKParsingMidCallback(){}

void AKParsingMidCallback::enumAllSub(void *userData){

//    ParsingObject::EnumAllSubCall pEnumAllSubCall = &AKParsingMidCallback::enumAllSubCallback;

    ParsingObject::EnumAllSubCall pEnumAllSubCall = enumAllSubCallback2;
    
    
    
    

}

void AKParsingMidCallback::enumAllSubCallback(const boost::shared_ptr<ParsingObject> object, void* usrData){

    AKParsingObjectOpaque *newParsingObjectOpaque = new AKParsingObjectOpaque(*object.get());
    AKParsingObject *newParsingObject = [[AKParsingObject alloc]initWithOpaque:newParsingObjectOpaque];
    if([m_ocObject delegate]){
    
        [m_ocObject.delegate enumAllSubCall:newParsingObject userData:(__bridge id)usrData];
        
    
    }
    
    

}

