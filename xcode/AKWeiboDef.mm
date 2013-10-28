//
//  AKWeiboDef.m
//  weibosdk
//
//  Created by Kent Peifeng Ke on 13-10-17.
//
//

#import "AKWeiboDef.h"
#import "IWeiboDef.hxx"

using namespace weibo;

@implementation AKWeiboDef

@end

#pragma mark - Wrapper for UserTaskInfo
struct AKUserTaskInfoOpaque{

    AKUserTaskInfoOpaque():cpp(){};
    AKUserTaskInfoOpaque(UserTaskInfo *userTaskInfo){cpp = userTaskInfo;};
    UserTaskInfo *cpp;
    
};

@implementation AKUserTaskInfo

- (id)init
{
    self = [super init];
    if (self) {
        userTaskInfoOpaque = new AKUserTaskInfoOpaque();
    }
    return self;
}

-(id)initWithObject:(void *)object{

    self = [super init];
    if (self) {
        userTaskInfoOpaque = new AKUserTaskInfoOpaque((UserTaskInfo *)object);
    }
    return self;

}


-(void *)getCore{

    return &userTaskInfoOpaque->cpp;

}
@end

#pragma mark - Wrapper for BasicInfoOpaque
struct AKBasicInfoOpaque{
    
    AKBasicInfoOpaque():cpp(){};
    BasicInfo *cpp;
    
};

@implementation AKBasicInfo

- (id)init
{
    self = [super init];
    if (self) {
        basicInfoOpaque = new AKBasicInfoOpaque();
    }
    return self;
}

-(void *)getCore{

    return &basicInfoOpaque->cpp;

}

//===========================================================
//  ID
//===========================================================
- (NSString *)ID
{
    return [NSString stringWithCString:basicInfoOpaque->cpp->id.c_str() encoding:NSUTF8StringEncoding];
}
- (void)setID:(NSString *)ID
{
    basicInfoOpaque->cpp->id = std::string([ID UTF8String]);
}
//===========================================================
//  name
//===========================================================
- (NSString *)name
{
    return [NSString stringWithCString:basicInfoOpaque->cpp->name.c_str() encoding:NSUTF8StringEncoding];
}
- (void)setName:(NSString *)name
{
    basicInfoOpaque->cpp->name = std::string([name UTF8String]);
}
//===========================================================
//  screen_name
//===========================================================
- (NSString *)screen_name
{
    return [NSString stringWithCString:basicInfoOpaque->cpp->screen_name.c_str() encoding:NSUTF8StringEncoding];
}
- (void)setScreen_name:(NSString *)screen_name
{
    basicInfoOpaque->cpp->screen_name = std::string([screen_name UTF8String]);
}
//===========================================================
//  city
//===========================================================
- (NSString *)city
{
    return [NSString stringWithCString:basicInfoOpaque->cpp->city.c_str() encoding:NSUTF8StringEncoding];
}
- (void)setCity:(NSString *)city
{
    basicInfoOpaque->cpp->city = std::string([city UTF8String]);
}
//===========================================================
//  province
//===========================================================
- (NSString *)province
{
    return [NSString stringWithCString:basicInfoOpaque->cpp->province.c_str() encoding:NSUTF8StringEncoding];
}
- (void)setProvince:(NSString *)province
{
    basicInfoOpaque->cpp->province = std::string([province UTF8String]);
}
//===========================================================
//  location
//===========================================================
- (NSString *)location
{
    return [NSString stringWithCString:basicInfoOpaque->cpp->location.c_str() encoding:NSUTF8StringEncoding];
}
- (void)setLocation:(NSString *)location
{
    basicInfoOpaque->cpp->location = std::string([location UTF8String]);
}
//===========================================================
//  created_at
//===========================================================
- (NSString *)created_at
{
    return [NSString stringWithCString:basicInfoOpaque->cpp->created_at.c_str() encoding:NSUTF8StringEncoding];
}
- (void)setCreated_at:(NSString *)created_at
{
    basicInfoOpaque->cpp->created_at = std::string([created_at UTF8String]);
}
//===========================================================
//  description
//===========================================================
- (NSString *)description
{
    return [NSString stringWithCString:basicInfoOpaque->cpp->description.c_str() encoding:NSUTF8StringEncoding];
}
- (void)setDescription:(NSString *)description
{
    basicInfoOpaque->cpp->description = std::string([description UTF8String]);
}
//===========================================================
//  domain
//===========================================================
- (NSString *)domain
{
    return [NSString stringWithCString:basicInfoOpaque->cpp->domain.c_str() encoding:NSUTF8StringEncoding];
}
- (void)setDomain:(NSString *)domain
{
    basicInfoOpaque->cpp->domain = std::string([domain UTF8String]);
}
//===========================================================
//  gender
//===========================================================
- (NSString *)gender
{
    return [NSString stringWithCString:basicInfoOpaque->cpp->gender.c_str() encoding:NSUTF8StringEncoding];
}
- (void)setGender:(NSString *)gender
{
    basicInfoOpaque->cpp->gender = std::string([gender UTF8String]);
}
//===========================================================
//  credentials_num
//===========================================================
- (NSString *)credentials_num
{
    return [NSString stringWithCString:basicInfoOpaque->cpp->credentials_num.c_str() encoding:NSUTF8StringEncoding];
}
- (void)setCredentials_num:(NSString *)credentials_num
{
    basicInfoOpaque->cpp->credentials_num = std::string([credentials_num UTF8String]);
}
//===========================================================
//  credentials_type
//===========================================================
- (NSString *)credentials_type
{
    return [NSString stringWithCString:basicInfoOpaque->cpp->credentials_type.c_str() encoding:NSUTF8StringEncoding];
}
- (void)setCredentials_type:(NSString *)credentials_type
{
    basicInfoOpaque->cpp->credentials_type = std::string([credentials_type UTF8String]);
}
//===========================================================
//  lang
//===========================================================
- (NSString *)lang
{
    return [NSString stringWithCString:basicInfoOpaque->cpp->lang.c_str() encoding:NSUTF8StringEncoding];
}
- (void)setLang:(NSString *)lang
{
    basicInfoOpaque->cpp->lang = std::string([lang UTF8String]);
}
//===========================================================
//  profile_image_url
//===========================================================
- (NSString *)profile_image_url
{
    return [NSString stringWithCString:basicInfoOpaque->cpp->profile_image_url.c_str() encoding:NSUTF8StringEncoding];
}
- (void)setProfile_image_url:(NSString *)profile_image_url
{
    basicInfoOpaque->cpp->profile_image_url = std::string([profile_image_url UTF8String]);
}
//===========================================================
//  birthday
//===========================================================
- (NSString *)birthday
{
    return [NSString stringWithCString:basicInfoOpaque->cpp->birthday.c_str() encoding:NSUTF8StringEncoding];
}
- (void)setBirthday:(NSString *)birthday
{
    basicInfoOpaque->cpp->birthday = std::string([birthday UTF8String]);
}
//===========================================================
//  birthday_visible
//===========================================================
- (NSString *)birthday_visible
{
    return [NSString stringWithCString:basicInfoOpaque->cpp->birthday_visible.c_str() encoding:NSUTF8StringEncoding];
}
- (void)setBirthday_visible:(NSString *)birthday_visible
{
    basicInfoOpaque->cpp->birthday_visible = std::string([birthday_visible UTF8String]);
}
//===========================================================
//  email
//===========================================================
- (NSString *)email
{
    return [NSString stringWithCString:basicInfoOpaque->cpp->email.c_str() encoding:NSUTF8StringEncoding];
}
- (void)setEmail:(NSString *)email
{
    basicInfoOpaque->cpp->email = std::string([email UTF8String]);
}
//===========================================================
//  email_visible
//===========================================================
- (NSString *)email_visible
{
    return [NSString stringWithCString:basicInfoOpaque->cpp->email_visible.c_str() encoding:NSUTF8StringEncoding];
}
- (void)setEmail_visible:(NSString *)email_visible
{
    basicInfoOpaque->cpp->email_visible = std::string([email_visible UTF8String]);
}
//===========================================================
//  msn
//===========================================================
- (NSString *)msn
{
    return [NSString stringWithCString:basicInfoOpaque->cpp->msn.c_str() encoding:NSUTF8StringEncoding];
}
- (void)setMsn:(NSString *)msn
{
    basicInfoOpaque->cpp->msn = std::string([msn UTF8String]);
}
//===========================================================
//  msn_visible
//===========================================================
- (NSString *)msn_visible
{
    return [NSString stringWithCString:basicInfoOpaque->cpp->msn_visible.c_str() encoding:NSUTF8StringEncoding];
}
- (void)setMsn_visible:(NSString *)msn_visible
{
    basicInfoOpaque->cpp->msn_visible = std::string([msn_visible UTF8String]);
}
//===========================================================
//  qq
//===========================================================
- (NSString *)qq
{
    return [NSString stringWithCString:basicInfoOpaque->cpp->qq.c_str() encoding:NSUTF8StringEncoding];
}
- (void)setQq:(NSString *)qq
{
    basicInfoOpaque->cpp->qq = std::string([qq UTF8String]);
}
//===========================================================
//  qq_visible
//===========================================================
- (NSString *)qq_visible
{
    return [NSString stringWithCString:basicInfoOpaque->cpp->qq_visible.c_str() encoding:NSUTF8StringEncoding];
}
- (void)setQq_visible:(NSString *)qq_visible
{
   basicInfoOpaque->cpp->qq_visible = std::string([qq_visible UTF8String]);
}
//===========================================================
//  real_name
//===========================================================
- (NSString *)real_name
{
    return [NSString stringWithCString:basicInfoOpaque->cpp->real_name.c_str() encoding:NSUTF8StringEncoding];
}
- (void)setReal_name:(NSString *)real_name
{
    basicInfoOpaque->cpp->real_name = std::string([real_name UTF8String]);
}
//===========================================================
//  real_name_visible
//===========================================================
- (NSString *)real_name_visible
{
    return [NSString stringWithCString:basicInfoOpaque->cpp->real_name_visible.c_str() encoding:NSUTF8StringEncoding];
}
- (void)setReal_name_visible:(NSString *)real_name_visible
{
    basicInfoOpaque->cpp->real_name_visible = std::string([real_name_visible UTF8String]);
}
//===========================================================
//  url_string
//===========================================================
- (NSString *)url_string
{
    return [NSString stringWithCString:basicInfoOpaque->cpp->url_string.c_str() encoding:NSUTF8StringEncoding];
}
- (void)setUrl_string:(NSString *)url_string
{
    basicInfoOpaque->cpp->url_string = std::string([url_string UTF8String]);
}
//===========================================================
//  url_visible
//===========================================================
- (NSString *)url_visible
{
    return [NSString stringWithCString:basicInfoOpaque->cpp->url_visible.c_str() encoding:NSUTF8StringEncoding];
}
- (void)setUrl_visible:(NSString *)url_visible
{
    basicInfoOpaque->cpp->url_visible = std::string([url_visible UTF8String]);
}


@end







#pragma mark - Wrapper for EducationInfo
struct AKEducationInfoOpaque{
    
    AKEducationInfoOpaque():cpp(){};
    EducationInfo *cpp;

};

@implementation AKEducationInfo


- (id)init
{
    self = [super init];
    if (self) {
        educationInfoOpaque = new AKEducationInfoOpaque();
    }
    return self;
}

-(void *)getCore{

    return &educationInfoOpaque->cpp;

}

//===========================================================
//  ID
//===========================================================
- (NSString *)ID
{
    return [NSString stringWithCString:educationInfoOpaque->cpp->id.c_str() encoding:NSUTF8StringEncoding];
}
- (void)setID:(NSString *)ID
{
    educationInfoOpaque->cpp->id = std::string([ID UTF8String]);;
}

//===========================================================
//  type
//===========================================================
- (NSString *)type
{
    return [NSString stringWithCString:educationInfoOpaque->cpp->type.c_str() encoding:NSUTF8StringEncoding];
}
- (void)setType:(NSString *)type
{
    educationInfoOpaque->cpp->type = std::string([type UTF8String]);;
}

//===========================================================
//  school
//===========================================================
- (NSString *)school
{
    return [NSString stringWithCString:educationInfoOpaque->cpp->school.c_str() encoding:NSUTF8StringEncoding];
}
- (void)setSchool:(NSString *)school
{
    educationInfoOpaque->cpp->school = std::string([school UTF8String]);;
}

//===========================================================
//  department
//===========================================================
- (NSString *)department
{
    return [NSString stringWithCString:educationInfoOpaque->cpp->department.c_str() encoding:NSUTF8StringEncoding];
}
- (void)setDepartment:(NSString *)department
{
    educationInfoOpaque->cpp->department = std::string([department UTF8String]);;
}

//===========================================================
//  year
//===========================================================
- (NSString *)year
{
    return [NSString stringWithCString:educationInfoOpaque->cpp->year.c_str() encoding:NSUTF8StringEncoding];
}
- (void)setYear:(NSString *)year
{
    educationInfoOpaque->cpp->year = std::string([year UTF8String]);;
}

//===========================================================
//  visible
//===========================================================
- (NSString *)visible
{
    return [NSString stringWithCString:educationInfoOpaque->cpp->visible.c_str() encoding:NSUTF8StringEncoding];
}
- (void)setVisible:(NSString *)visible
{
    educationInfoOpaque->cpp->visible = std::string([visible UTF8String]);;
}



@end


#pragma mark - Wrapper for CareerInfo
struct AKCareerInfoOpaque{

    AKCareerInfoOpaque():cpp(){};
    CareerInfo *cpp;

};

@implementation AKCareerInfo


- (id)init
{
    self = [super init];
    if (self) {
        careerInfoOpaque = new AKCareerInfoOpaque();
    }
    return self;
}

-(void *)getCore{

    return &careerInfoOpaque->cpp;

}

//===========================================================
//  ID
//===========================================================
- (NSString *)ID
{
    return [NSString stringWithCString:careerInfoOpaque->cpp->id.c_str() encoding:NSUTF8StringEncoding];
}
- (void)setID:(NSString *)ID
{
    careerInfoOpaque->cpp->id = std::string([ID UTF8String]);;
}

//===========================================================
//  city
//===========================================================
- (NSString *)city
{
    return [NSString stringWithCString:careerInfoOpaque->cpp->city.c_str() encoding:NSUTF8StringEncoding];
}
- (void)setCity:(NSString *)city
{
    careerInfoOpaque->cpp->city = std::string([city UTF8String]);;
}

//===========================================================
//  province
//===========================================================
- (NSString *)province
{
    return [NSString stringWithCString:careerInfoOpaque->cpp->province.c_str() encoding:NSUTF8StringEncoding];
}
- (void)setProvince:(NSString *)province
{
    careerInfoOpaque->cpp->province = std::string([province UTF8String]);;
}

//===========================================================
//  start
//===========================================================
- (NSString *)start
{
    return [NSString stringWithCString:careerInfoOpaque->cpp->start.c_str() encoding:NSUTF8StringEncoding];
}
- (void)setStart:(NSString *)start
{
    careerInfoOpaque->cpp->start = std::string([start UTF8String]);;
}

//===========================================================
//  end
//===========================================================
- (NSString *)end
{
    return [NSString stringWithCString:careerInfoOpaque->cpp->end.c_str() encoding:NSUTF8StringEncoding];
}
- (void)setEnd:(NSString *)end
{
    careerInfoOpaque->cpp->end = std::string([end UTF8String]);;
}

//===========================================================
//  company
//===========================================================
- (NSString *)company
{
    return [NSString stringWithCString:careerInfoOpaque->cpp->company.c_str() encoding:NSUTF8StringEncoding];
}
- (void)setCompany:(NSString *)company
{
    careerInfoOpaque->cpp->company = std::string([company UTF8String]);;
}

//===========================================================
//  department
//===========================================================
- (NSString *)department
{
    return [NSString stringWithCString:careerInfoOpaque->cpp->department.c_str() encoding:NSUTF8StringEncoding];
}
- (void)setDepartment:(NSString *)department
{
    careerInfoOpaque->cpp->department = std::string([department UTF8String]);;
}

//===========================================================
//  visible
//===========================================================
- (NSString *)visible
{
    return [NSString stringWithCString:careerInfoOpaque->cpp->visible.c_str() encoding:NSUTF8StringEncoding];
}
- (void)setVisible:(NSString *)visible
{
    careerInfoOpaque->cpp->visible = std::string([visible UTF8String]);;
}



@end


