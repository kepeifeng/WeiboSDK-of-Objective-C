//
//  AKParsingHandle.m
//  weibosdk
//
//  Created by Kent Peifeng Ke on 13-10-18.
//
//

#import "AKParsingHandle.h"
#include "ParsingHandle.hxx"


struct JsonValue{
    
public:
    Json::Value * val;
    

};


struct ParsingHandleOpaque{
public:
    ParsingHandleOpaque(Json::Value* val = NULL, bool owner = false):parsingHandle(val,owner){};
    weibo::ParsingHandle parsingHandle;
};


@implementation AKParsingHandle

-(id)initWithJsonValue:(struct JsonValue *)val isOwner:(BOOL)isOwner{
    
    self = [super init];
    if(self){
    
        _cpp = new ParsingHandleOpaque(val->val, isOwner);
    
    }


}



-(void)dealloc{

    return ;
}

-(BOOL)parse:(NSString *)source{


}

-(void)resetWithJsonValue:(struct JsonValue *)val isOwner:(BOOL)isOwner{

}

-(NSString *)getErrorMessage{

}

-(NSString *)getSource{

}

-(struct JsonValue *)getValue{


}


@end
