//
//  AKID.m
//  weibosdk
//
//  Created by Kent Peifeng Ke on 13-10-17.
//
//

#import "AKID.h"
#import "IWeiboDef.hxx"

using namespace weibo;

struct AKIDOpaque{

    AKIDOpaque():cpp(){};
    ID *cpp;
    

};

@implementation AKID

- (id)init
{
    self = [super init];
    if (self) {
        idOpaque = new AKIDOpaque();
    }
    return self;
}

-(id)initWithIdType:(AKIDType)type text:(NSString *)aID key:(NSString *)aKey{

    self = [super init];
    if (self) {
        idOpaque = new AKIDOpaque();
        idOpaque->cpp->idType = (ID::IDType)type;
        idOpaque->cpp->id = std::string([aID UTF8String]);
        idOpaque->cpp->keyName = std::string([aKey UTF8String]);
        
        
    }
    return self;

}

-(void *)getCore{

    return &idOpaque->cpp;

}



@end
