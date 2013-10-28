//
//  AKParsingMidCallback.h
//  weibosdk
//
//  Created by Kent Peifeng Ke on 13-10-19.
//
//

#ifndef weibosdk_AKParsingMidCallback_h
#define weibosdk_AKParsingMidCallback_h

#include "ParsingObject.hxx"
#include "AKParsingObject.h"
#include "IWeiboDef.hxx"
#include "AKWeibo.h"

using namespace weibo;

class AKParsingMidCallback{

private:
    AKParsingObject* m_ocObject;
    
public:
    AKParsingMidCallback(AKParsingObject* ocObject);
    AKParsingMidCallback(id<AKWeibo>);
    virtual ~AKParsingMidCallback();
    
    void enumAllSub(void* usrData);
    void enumAllSubCallback(const boost::shared_ptr<ParsingObject> object, void* usrData);
    
    static void OnDelegateComplated(unsigned int methodOption, const char* httpHeader, ParsingObject* result, const UserTaskInfo* pTask);
    static void OnDelegateErrored(unsigned int methodOption, const int errCode, const int subErrCode, ParsingObject* result, const UserTaskInfo* pTask);
    static void OnDelegateWillRelease(unsigned int methodOption, const UserTaskInfo* pTask);
    
    static id<AKWeiboDelegate> weiboDelegate;
    static id<AKWeibo> weibo;
};



#endif
