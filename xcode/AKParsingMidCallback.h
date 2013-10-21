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
using namespace weibo;

class AKParsingMidCallback{

private:
    AKParsingObject* m_ocObject;
    
public:
    AKParsingMidCallback(AKParsingObject* ocObject);
    virtual ~AKParsingMidCallback();
    
    void enumAllSub(void* usrData);
    void enumAllSubCallback(const boost::shared_ptr<ParsingObject> object, void* usrData);
};

#endif
