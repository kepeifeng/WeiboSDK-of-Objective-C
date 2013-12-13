//
//  AKVariableParams.m
//  weibosdk
//
//  Created by Kent Peifeng Ke on 13-10-17.
//
//

#import "AKVariableParams.h"
#import "IWeiboDef.hxx"
#import <string>

using namespace weibo;

struct AKVariableParamsOpaque {

public:
    AKVariableParamsOpaque(){cpp = new VariableParams();};
    VariableParams *cpp;
};

@implementation AKVariableParams

@synthesize simplify = _simplify;

#pragma mark - Initializor
- (id)init
{
    self = [super init];
    if (self) {
        variableParamsOpaque = new AKVariableParamsOpaque();
    }
    return self;
}


#pragma mark - Method

-(void *)getCore{

    return variableParamsOpaque->cpp;

}


#pragma mark - Property

-(long long)since_id{

    return variableParamsOpaque->cpp->since_id;

}

-(void)setSince_id:(long long)since_id{

    variableParamsOpaque->cpp->since_id = since_id;

}

-(long long)max_id{

    return variableParamsOpaque->cpp->max_id;

}

-(void)setMax_id:(long long)max_id{

    variableParamsOpaque->cpp->max_id = max_id;
    
}

-(int)count{

    return variableParamsOpaque->cpp->count;
    
}

-(void)setCount:(int)count{

    variableParamsOpaque->cpp->count = count;
    
}

-(int)page{

    
    return variableParamsOpaque->cpp->page;
    
}


-(void)setPage:(int)page{


    variableParamsOpaque->cpp->page = page;
    
}

-(int)base_app{
    
    return variableParamsOpaque->cpp->base_app;
    
}

-(void)setBase_app:(int)base_app{

    variableParamsOpaque->cpp->base_app = base_app;

}


-(int)feature{

    return variableParamsOpaque->cpp->feature;
    
}

-(void)setFeature:(int)feature{

    variableParamsOpaque->cpp->feature = feature;

}

-(int)is_encoded{

    return variableParamsOpaque->cpp->is_encoded;

}

-(void)setIs_encoded:(int)is_encoded{

    variableParamsOpaque->cpp->is_encoded = is_encoded;

}



-(int)sort{

    return variableParamsOpaque->cpp->sort;

}

-(void)setSort:(int)sort{

    variableParamsOpaque->cpp->sort = sort;

}

-(int)cursor{

    return variableParamsOpaque->cpp->cursor;
    
}

-(void)setCursor:(int)cursor{

    variableParamsOpaque->cpp->cursor = cursor;

}

//===========================================================
//  filter_by_source
//===========================================================
- (int)filter_by_source
{
    return variableParamsOpaque->cpp->filter_by_source;
}

- (void)setFilter_by_source:(int)aFilter_by_source
{
    if (variableParamsOpaque->cpp->filter_by_source != aFilter_by_source) {
        variableParamsOpaque->cpp->filter_by_source = aFilter_by_source;
    }
}
//===========================================================
//  filter_by_author
//===========================================================
- (int)filter_by_author
{
    return variableParamsOpaque->cpp->filter_by_author;
}
- (void)setFilter_by_author:(int)aFilter_by_author
{
    if (variableParamsOpaque->cpp->filter_by_author != aFilter_by_author) {
        variableParamsOpaque->cpp->filter_by_author = aFilter_by_author;
    }
}
//===========================================================
//  filter_by_type
//===========================================================
- (int)filter_by_type
{
    return variableParamsOpaque->cpp->filter_by_type;
}
- (void)setFilter_by_type:(int)aFilter_by_type
{
    if (variableParamsOpaque->cpp->filter_by_type != aFilter_by_type) {
        variableParamsOpaque->cpp->filter_by_type = aFilter_by_type;
    }
}
//===========================================================
//  trim_user
//===========================================================
- (int)trim_user
{
    return variableParamsOpaque->cpp->trim_user;
}
- (void)setTrim_user:(int)aTrim_user
{
    if (variableParamsOpaque->cpp->trim_user != aTrim_user) {
        variableParamsOpaque->cpp->trim_user = aTrim_user;
    }
}
//===========================================================
//  trim_status
//===========================================================
- (int)trim_status
{
    return variableParamsOpaque->cpp->trim_status;
}
- (void)setTrim_status:(int)aTrim_status
{
    if (variableParamsOpaque->cpp->trim_status != aTrim_status) {
        variableParamsOpaque->cpp->trim_status = aTrim_status;
    }
}
//===========================================================
//  simplify
//===========================================================
- (NSString *)simplify
{
    return _simplify;
}
- (void)setSimplify:(NSString *)aSimplify
{
    
    _simplify = aSimplify;
    
    if(aSimplify){
        variableParamsOpaque->cpp->simplify = std::string([_simplify UTF8String]);
    }
    else{
    
        variableParamsOpaque->cpp->simplify = "";
    }
    
}

@end
