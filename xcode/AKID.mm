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

    AKIDOpaque(){cpp = new weibo::ID(weibo::ID::IDT_ID,NULL,NULL);};
    //AKIDOpaque(ID::IDType type, const char *text, const char* key = NULL):cpp(){};
    
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
        switch (type) {
            case AKIDTypeID:
                idOpaque->cpp->idType = weibo::ID::IDT_ID;
                break;
            case AKIDTypeScreenname:
                idOpaque->cpp->idType = weibo::ID::IDT_SCREENNAME;
            default:
                break;
        }
      
        
//        idOpaque->cpp->idType = static_cast<ID::IDType>(0);
        idOpaque->cpp->id = std::string([aID UTF8String]);
        idOpaque->cpp->keyName = aKey?std::string([aKey UTF8String]):"";
        
        
    }
    return self;

}

-(void *)getCore{

    return idOpaque->cpp;

}



@end
