//
//  AKWeiboMethod.m
//  weibosdk
//
//  Created by Kent Peifeng Ke on 13-10-18.
//
//

#import "AKWeiboMethod.h"
#include "SDKMethodImpl.hxx"
#include "IWeiboDef.hxx"

using namespace weibo;

struct AKWeiboMethodOpaque{

    AKWeiboMethodOpaque(){};
    AKWeiboMethodOpaque(IWeiboMethod *object){cpp = object;};
    IWeiboMethod *cpp;
};

@implementation AKWeiboMethod

- (id)init
{
    self = [super init];
    if (self) {
        _weiboMethod = new AKWeiboMethodOpaque();
    }
    return self;
}

-(id)initWithObject:(void *)object{

    self = [super init];
    if (self) {
        _weiboMethod = new AKWeiboMethodOpaque((IWeiboMethod *)object);
    }
    return self;
    
}

-(UserTaskInfo *)convertUserTaskInfo:(AKUserTaskInfo *)userTaskInfo{
    if(!userTaskInfo){
        
        return NULL;
    }
    
    UserTaskInfo *newUserTaskInfo = new UserTaskInfo();
    const char *cpUserTaskInfo = [userTaskInfo.mTaskId UTF8String];
    strncpy(newUserTaskInfo->mTaskId, cpUserTaskInfo, 255);
    newUserTaskInfo->mUsrData = (__bridge void*)userTaskInfo.mUsrData;
    return newUserTaskInfo;
    //newUserTaskInfo->mTaskId = [userTaskInfo.mTaskId cStringUsingEncoding:NSUTF8StringEncoding];}
}

#pragma mark - 身份验证

-(AKWeiboResultCode)oauth2:(NSString *)userName password:(NSString *)password task:(AKUserTaskInfo *)pTask{

    return _weiboMethod->cpp->oauth2([userName cStringUsingEncoding:NSUTF8StringEncoding], [password cStringUsingEncoding:NSUTF8StringEncoding], (UserTaskInfo *)[pTask getCore]);

}



-(AKWeiboResultCode)oauth2Code:(NSString *)code url:(NSString *)url  pTask:(AKUserTaskInfo*) pTask{

    return _weiboMethod->cpp->oauth2Code([code UTF8String], [url UTF8String], (UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode)endSession{    return _weiboMethod->cpp->endSession();}


#pragma mark - 微博读取
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 微博读取
-(AKWeiboResultCode) getStatusesPublicTimeline:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getStatusesPublicTimeline((VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getStatusesFriendTimeline:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getStatusesFriendTimeline((VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}


-(AKWeiboResultCode) getStatusesHomeTimeline:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getStatusesHomeTimeline((VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getStatusesUserTimeline:(AKID *)usrId  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getStatusesUserTimeline(*((weibo::ID *)[usrId getCore]),(VariableParams *)[var getCore],[self convertUserTaskInfo:pTask]);

}

-(AKWeiboResultCode) getStatusesTimelineBatch:(AKID *)usrId  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getStatusesTimelineBatch((*(weibo::ID *)[usrId getCore]),(VariableParams *)[var getCore],[self convertUserTaskInfo:pTask]);
}

-(AKWeiboResultCode) getStatusesRepostTimeline:(NSString *)aID  var: (AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{
    
    return _weiboMethod->cpp->getStatusesRepostTimeline([aID UTF8String],(VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getStatusesRepostByMe:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getStatusesRepostByMe((VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getStatusesMentions:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getStatusesMentions((VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getStatusesShow:(NSString *)aID  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getStatusesShow([aID UTF8String],(VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getStatusesShowBatch:(NSString *)inputIDs  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getStatusesShowBatch([inputIDs UTF8String],(VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);
}

-(AKWeiboResultCode) getStatusesQueryMID:(NSString *) weiboId    type:(NSInteger)type  is_batch:(NSInteger) is_batch  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getStatusesQueryMID([weiboId UTF8String], (int)type, (int)is_batch, (UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getStatusesQueryID:(NSString *) mId    type:(NSInteger)type  is_batch:(NSInteger) is_batch  inbox:(NSInteger) inbox  isBase62:(NSInteger) isBase62  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getStatusesQueryID([mId UTF8String], (int)type, (int)is_batch, (int)inbox, (int)isBase62, (UserTaskInfo *)[pTask getCore]);
}

-(AKWeiboResultCode) getStatusesRepostDaily:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getStatusesRepostDaily((VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getStatusesRepostWeekly:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getStatusesRepostWeekly((VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getStatusesHotCommmentsDaily:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getStatusesHotCommmentsDaily((VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getStatusesHotCommmentsWeekly:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{
    
    return _weiboMethod->cpp->getStatusesHotCommmentsDaily((VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);
}


#pragma mark - 微博写入
// 微博写入
-(AKWeiboResultCode) postStatusesRepost:(NSString *) weiboId   statusText:(NSString *)statusText isComment:(NSInteger)isComment  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->postStatusesRepost([weiboId UTF8String], [statusText UTF8String], (int)isComment,(VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) postStatusesDestroy:(NSString *) weiboId   var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{
    
    return _weiboMethod->cpp->postStatusesDestroy([weiboId UTF8String],(VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);
}

-(AKWeiboResultCode) postStatusesUpdate:(NSString *)statusText  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{
    
    return _weiboMethod->cpp->postStatusesUpdate([statusText UTF8String],(VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);
}

-(AKWeiboResultCode) postStatusesUploadUrlText:(NSString *)statusText  picInfo:(NSString *)picInfo  isPicUrl:(BOOL)isPicUrl  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    return  _weiboMethod->cpp->postStatusesUploadUrlText([statusText UTF8String],[picInfo UTF8String], isPicUrl, (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);
}

-(AKWeiboResultCode) postStatusesUpload:(NSString *)statusText  filePath:(NSString *)filePath  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{
    return _weiboMethod->cpp->postStatusesUpload([statusText UTF8String],[filePath UTF8String],(VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

#pragma mark - 评论读取
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 评论读取
-(AKWeiboResultCode) getCommentsShow:(NSString *) weiboId   var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getCommentsShow([weiboId UTF8String],(VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getCommentsByMe:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getCommentsByMe((VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getCommentsToMe:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getCommentsToMe((VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getCommentsTimeline:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getCommentsTimeline((VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getCommentsMentions:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getCommentsMentions((VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}


#pragma mark - 评论写入
// 评论写入
-(AKWeiboResultCode) getCommentsShowBatch:(NSString *)commentIds  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getCommentsShowBatch([commentIds UTF8String],(VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) postCommentsCreate:(NSString *)postId comment:(NSString *)comment commentOri:(NSInteger)commentOri var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->postCommentsCreate([postId UTF8String],[comment UTF8String], (int)commentOri, (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) postCommentsDestroy:(NSString *)postId  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{
    
    return _weiboMethod->cpp->postCommentsDestroy([postId UTF8String],(VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);
}

-(AKWeiboResultCode) postCommentsDestroyBatch:(NSString *)postId  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->postCommentsDestroyBatch([postId UTF8String],(VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) postCommentsReply:(NSString *) commentId comment:(NSString *)comment weiboId:(NSString *)weiboId withoutMention:(NSInteger)withoutMention   commentOri:(NSInteger)commentOri  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->postCommentsReply([commentId UTF8String], [comment UTF8String], [weiboId UTF8String], (int)withoutMention, (int)commentOri, (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}


#pragma mark - 私信读取
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 私信读取
-(AKWeiboResultCode) getDirectMessages:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getDirectMessages((VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getDirectMessagesSent:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getDirectMessagesSent((VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getDirectMessagesUserList:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getDirectMessagesUserList((VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getDirectMessagesCoversation:(AKID  *)usrId  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getDirectMessagesCoversation( *((ID *)[usrId getCore]), (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getDirectMessagesShowBatch:(NSString *)aID  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getDirectMessagesShowBatch([aID UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getDirectMessagesIsCapable:(NSString *)uid  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getDirectMessagesIsCapable([uid UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);}


#pragma mark - 私信写入
// 私信写入
-(AKWeiboResultCode) postDirectMessagesNew:(NSString *)text uid:(AKID *) uid fields:(NSString *)fields
                                   weiboId:(NSString *) weiboId  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{
    
    return _weiboMethod->cpp->postDirectMessagesNew([text UTF8String], *((ID *)[uid getCore]), [fields UTF8String], [weiboId UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) postDirectMessagesDestory:(NSString *)aID  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->postDirectMessagesDestory([aID UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) postDirectMessagesDestoryBatch:(NSString *)aIDs uid:(NSString *)uid  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->postDirectMessagesDestoryBatch([aIDs UTF8String], [uid UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}



#pragma mark - 用户读取
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 用户读取
-(AKWeiboResultCode) getUsersShow:(AKID *)usrId extend:(NSString *)extend var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getUsersShow(*((ID *)[usrId getCore]), [extend UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);}

-(AKWeiboResultCode) getUsersDomainShow:(NSString *) domain  extend:(NSString *)extend  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getUsersDomainShow([domain UTF8String], [extend UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getUsersShowBatch:(AKID *)usrId extend:(NSString *)extend  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getUsersShowBatch(*((ID *)[usrId getCore]),[extend UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}


#pragma mark - 关注读取
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 关注读取
-(AKWeiboResultCode) getFriendshipsFriends:(AKID *)usrId   order:(NSInteger)order  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask {

    return _weiboMethod->cpp->getFriendshipsFriends(*((ID *)[usrId getCore]), (int)order, (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getFriendshipsInCommon:(NSString *)aID suid:(NSString *)suid  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask {

    return _weiboMethod->cpp->getFriendshipsInCommon([aID UTF8String], [suid UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getFriendshipsBilateral:(NSString *)uid  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask {

    return _weiboMethod->cpp->getFriendshipsBilateral([uid UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getFriendshipsBilateralIDs:(NSString *)uid  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask {

    return _weiboMethod->cpp->getFriendshipsBilateralIDs([uid UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getFriendshipsFriendIDs:(AKID *)usrId  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask {

    return _weiboMethod->cpp->getFriendshipsFriendIDs(*((ID *)[usrId getCore]), (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);
}

-(AKWeiboResultCode) getFriendshipsFriendRemarkBatch:(NSString *)uids  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask {

    return _weiboMethod->cpp->getFriendshipsFriendRemarkBatch([uids UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

#pragma mark - 粉丝读取
// 粉丝读取
-(AKWeiboResultCode) getFriendshipsFriendsFollowers:(AKID *)usrId  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getFriendshipsFriendsFollowers(*((ID *)[usrId getCore]),(VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getFriendshipsFriendsFollowersIDs:(AKID *)usrId  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask {

    return _weiboMethod->cpp->getFriendshipsFriendsFollowersIDs(*((ID *)[usrId getCore]), (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getFriendshipsFriendsFollowersActive:(AKID *)usrIDs  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask {

    return _weiboMethod->cpp->getFriendshipsFriendsFollowersActive(*((ID *)[usrIDs getCore]), (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}


#pragma mark - 关系链读取
// 关系链读取
-(AKWeiboResultCode) getFriendshipsFriendsChainFollowers:(NSString *)uid  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask {

    return _weiboMethod->cpp->getFriendshipsFriendsChainFollowers([uid UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}


#pragma mark - 关系状态
// 关系状态
-(AKWeiboResultCode) getFriendshipShow:(AKID *)sourceId targetId:(AKID *)targetId  pTask:(AKUserTaskInfo *) pTask {

    return _weiboMethod->cpp->getFriendshipShow(*((ID *)[sourceId getCore]), *((ID *)[targetId getCore]),(UserTaskInfo *)[pTask getCore]);

}


#pragma mark - 关系写入
// 关系写入
-(AKWeiboResultCode) postFriendshipsCreate:(AKID *)usrId   skipCheck:(NSInteger)skipCheck  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask {

    return _weiboMethod->cpp->postFriendshipsCreate(*((ID *)[usrId getCore]), (int)skipCheck, (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) postFriendshipsCreateBatch:(NSString *)uids  pTask:(AKUserTaskInfo *) pTask {

    return _weiboMethod->cpp->postFriendshipsCreateBatch([uids UTF8String],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) postFriendshipsDestroy:(AKID *)usrId  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask {

    return _weiboMethod->cpp->postFriendshipsDestroy(*((ID *)[usrId getCore]), (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) postFriendshipsFollowersDestroy:(NSString *)uid  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask {

    return _weiboMethod->cpp->postFriendshipsFollowersDestroy([uid UTF8String],  (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) postFriendshipsRemarkUpdate:(NSString *) uid remark:(NSString *)remark  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask {

    return _weiboMethod->cpp->postFriendshipsRemarkUpdate([uid UTF8String], [remark UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}



#pragma mark - 帐号读取
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 帐号读取
-(AKWeiboResultCode) getAccountProfileBasic:(NSString *) uid   pTask:(AKUserTaskInfo *) pTask {

    return _weiboMethod->cpp->getAccountProfileBasic([uid UTF8String], (UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getAccountProfileEducation:(NSString *)uid  pTask:(AKUserTaskInfo *) pTask {

    return _weiboMethod->cpp->getAccountProfileEducation([uid UTF8String], (UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getAccountProfileEducationBatch:(NSString *)uids  pTask:(AKUserTaskInfo *) pTask {

    return _weiboMethod->cpp->getAccountProfileEducationBatch([uids UTF8String],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getAccountProfileCareer:(NSString *)uid  pTask:(AKUserTaskInfo *) pTask {

    return _weiboMethod->cpp->getAccountProfileCareer([uid UTF8String], (UserTaskInfo *)[pTask getCore]);
}

-(AKWeiboResultCode) getAccountProfileCareerBatch:(NSString *)uids  pTask:(AKUserTaskInfo *) pTask {

    return _weiboMethod->cpp->getAccountProfileCareerBatch([uids UTF8String],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getAccountGetPrivacy:(AKUserTaskInfo *) pTask {

    return _weiboMethod->cpp->getAccountGetPrivacy((UserTaskInfo *)[pTask getCore]);}

-(AKWeiboResultCode) getAccountProfileSchoolList:(NSInteger) province  city:(NSInteger) city  area:(NSInteger) area  type:(NSInteger) type capital:(NSString *)capital keyword:(NSString *)keyword  counts:(NSInteger) counts  pTask:(AKUserTaskInfo *) pTask {

    return _weiboMethod->cpp->getAccountProfileSchoolList((int)province, (int)city, (int)area, (int)type, [capital UTF8String], [keyword UTF8String], (int)counts, (UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getAccountRateLimitStatus:(AKUserTaskInfo *) pTask {

    return _weiboMethod->cpp->getAccountRateLimitStatus((UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getAccountGetUID:(AKUserTaskInfo *) pTask {

    return _weiboMethod->cpp->getAccountGetUID((UserTaskInfo *)[pTask getCore]);

}



#pragma mark - 帐号写入
// 帐号写入
-(AKWeiboResultCode) postAccountProfileBasicUpdate:(AKBasicInfo*)basic  pTask:(AKUserTaskInfo *) pTask {

    return _weiboMethod->cpp->postAccountProfileBasicUpdate(*((BasicInfo *)[basic getCore]), (UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) postAccountProfileEduUpdate:(AKEducationInfo *)edu  pTask:(AKUserTaskInfo *) pTask {

    return _weiboMethod->cpp->postAccountProfileEduUpdate(*((EducationInfo *)[edu getCore]),(UserTaskInfo *)[pTask getCore]);}

-(AKWeiboResultCode) postAccountProfileEduDestroy:(NSString *)aID  pTask:(AKUserTaskInfo *) pTask {

    return _weiboMethod->cpp->postAccountProfileEduDestroy([aID UTF8String], (UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) postAccountProfileCarUpdate:(AKCareerInfo *) career  pTask:(AKUserTaskInfo *) pTask {

    return _weiboMethod->cpp->postAccountProfileCarUpdate(*((CareerInfo *)[career getCore]), (UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) postAccountProfileCarDestroy:(NSString *)aID  pTask:(AKUserTaskInfo *) pTask {

    return _weiboMethod->cpp->postAccountProfileCarDestroy([aID UTF8String], (UserTaskInfo *)[pTask getCore]);}

-(AKWeiboResultCode) postAccountAvatarUpload:(NSString *)filePath  pTask:(AKUserTaskInfo *) pTask {

    return _weiboMethod->cpp->postAccountAvatarUpload([filePath UTF8String], (UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) postAccountUpdatePrivacy:(NSInteger) comment geo:(NSInteger)geo message:(NSInteger)message realname:(NSInteger)realname  badge:(NSInteger) badge  mobile:(NSInteger) mobile  pTask:(AKUserTaskInfo *) pTask {

    return _weiboMethod->cpp->postAccountUpdatePrivacy((int) comment, (int) geo, (int) message, (int) realname, (int) badge, (int) mobile, (UserTaskInfo *)[pTask getCore]);
}


#pragma mark - 收藏读取
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 收藏读取
-(AKWeiboResultCode) getFavorites:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getFavorites((VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);


}

-(AKWeiboResultCode) getFavoritesShow:(NSString *)aID  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getFavoritesShow([aID UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getFavoritesByTags:(NSString *)tid  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getFavoritesByTags([tid UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getFavoritesTags:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getFavoritesTags((VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}


#pragma mark - 收藏写入
// 收藏写入
-(AKWeiboResultCode) postFavoritesCreate:(NSString *)aID  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->postFavoritesCreate([aID UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) postFavoritesDestroy:(NSString *)aID  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->postFavoritesDestroy([aID UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) postFavoritesDestroyBatch:(NSString *)aIDs  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->postFavoritesDestroyBatch([aIDs UTF8String],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) postFavoritesTagUpdate:(NSString *)tagId tagName:(NSString *)tagName  var:(AKVariableParams *)var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->postFavoritesTagUpdate([tagId UTF8String],[tagName UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) postFavoritesTagsUpdateBatch:(NSString *)tagId tagName:(NSString *)tagName  var:(AKVariableParams *)var  pTask:(AKUserTaskInfo *)pTask{

    return _weiboMethod->cpp->postFavoritesTagsUpdateBatch([tagId UTF8String], [tagName UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) postFavoritesTagsDestroyBatch:(NSString *)tagId  var:(AKVariableParams *)var  pTask:(AKUserTaskInfo *)pTask{

    return _weiboMethod->cpp->postFavoritesTagsDestroyBatch([tagId UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}



#pragma mark - 话题读取
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 话题读取
-(AKWeiboResultCode) getTrends:(NSString *)uid  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getTrends([uid UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);}

-(AKWeiboResultCode) getTrendsStatuses:(NSString *)trendWords provinceId:(NSString *)provinceId  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getTrendsStatuses([trendWords UTF8String], [provinceId UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getTrendsHourly:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getTrendsHourly((VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getTrendsDaily:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getTrendsDaily((VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getTrendsWeekly:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getTrendsWeekly((VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}


#pragma mark - 话题写入
// 话题写入
-(AKWeiboResultCode) postTrendsFollow:(NSString *)trendName  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->postTrendsFollow([trendName UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) postTrendsDestroy:(NSString *)trendId  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->postTrendsDestroy([trendId UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}



#pragma mark - 标签读取
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 标签读取
-(AKWeiboResultCode) getTags:(NSString *)uid  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getTags([uid UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getTagsTagsBatch:(NSString *)uids  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getTagsTagsBatch([uids UTF8String],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getTagsSuggestions:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getTagsSuggestions((VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}



#pragma mark - 标签写入
// 标签写入
-(AKWeiboResultCode) postTagsCreate:(NSString *)tags  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->postTagsCreate([tags UTF8String],(UserTaskInfo *)[pTask getCore]);


}

-(AKWeiboResultCode) postTagsDestroy:(NSString *)tagId  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->postTagsDestroy([tagId UTF8String], (UserTaskInfo *)[pTask getCore]);}

-(AKWeiboResultCode) postTagsDestroyBatch:(NSString *)tagIds  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->postTagsDestroyBatch([tagIds UTF8String],(UserTaskInfo *)[pTask getCore]);

}


#pragma mark - 搜索
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 搜索
-(AKWeiboResultCode) getSearchSuggestionsUsers:(NSString *)q  count:(NSInteger) count  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getSearchSuggestionsUsers([q UTF8String], (int)count, (UserTaskInfo *)[pTask getCore]);


}

-(AKWeiboResultCode) getSearchSuggestionsStatues:(NSString *)q  count:(NSInteger) count  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getSearchSuggestionsStatues([q UTF8String], (int)count, (UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getSearchSuggestionsSchool:(NSString *)q  count:(NSInteger) count  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getSearchSuggestionsSchool([q UTF8String], (int)count, (UserTaskInfo *)[pTask getCore]);}

-(AKWeiboResultCode) getSearchSuggestionsCompanies:(NSString *)q  count:(NSInteger) count  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getSearchSuggestionsCompanies([q UTF8String], (int)count, (UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getSearchSuggestionsApps:(NSString *)q  count:(NSInteger) count  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getSearchSuggestionsApps([q UTF8String], (int)count, (UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getSearchSuggestionsAtUsers:(NSString *)q   type:(NSInteger)type  count:(NSInteger) count  range:(NSInteger) range  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getSearchSuggestionsAtUsers([q UTF8String], (int)type, (int)count, (int)range, (UserTaskInfo *)[pTask getCore]);
}


-(AKWeiboResultCode) getSearchSuggestionsIntegrate:(NSString *)query  sort_user:(NSInteger) sort_user  sort_app:(NSInteger) sort_app
                                          sort_grp:(NSInteger) sort_grp  user_count:(NSInteger) user_count  app_count:(NSInteger) app_count  grp_count:(NSInteger) grp_count  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getSearchSuggestionsIntegrate([query UTF8String], (int) sort_user, (int) sort_app
                                                          , (int) sort_grp, (int) user_count, (int) app_count, (int) grp_count ,(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getSearchStatuses:(NSString *)q  filter_ori:(NSInteger) filter_ori   filter_pic:(NSInteger)filter_pic  fuid:(NSString *)fuid
                              province:(NSInteger) province   city:(NSInteger)city  starttime:(NSString *)starttime endtime:(NSString *)endtime  count:(NSInteger) count
                                  page:(NSInteger) page  needcount:(BOOL)needcount  base_app:(NSInteger) base_app  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getSearchStatuses([q UTF8String], (int) filter_ori , (int)filter_pic, [fuid UTF8String]
                                              , (int) province , (int)city, [starttime UTF8String], [endtime UTF8String], (int) count
                                              , (int) page, (BOOL)needcount, (int) base_app, (UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getSearchGeoStatuses:(float) longitude  latitudeconst:(float)latitudeconst  range:(NSInteger) range  time:(NSInteger) time sort_type:(NSInteger) sort_type  page:(NSInteger) page  count:(NSInteger) count  base_app:(NSInteger) base_app  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getSearchGeoStatuses((float) longitude, (float)latitudeconst, (int) range, (int) time, (int) sort_type, (int) page, (int) count, (int) base_app,(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getSearchUsers:(NSString *)q  snick:(NSInteger) snick  sdomain:(NSInteger) sdomain  sintro:(NSInteger) sintro  stag:(NSInteger) stag province:(NSInteger) province   city:(NSInteger)city  gender:(NSString *)gender  comorsch:(NSString *)comorsch   sort:(NSInteger) sort count:(NSInteger) count  page:(NSInteger) page  base_app:(NSInteger) base_app  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getSearchUsers([q UTF8String], (int) snick, (int) sdomain, (int) sintro, (int) stag, (int) province, (int)city, [gender UTF8String], [comorsch UTF8String] , (int) sort, (int) count, (int) page, (int) base_app,(UserTaskInfo *)[pTask getCore]);

}


#pragma mark - 推荐读取
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 推荐读取
-(AKWeiboResultCode) getSuggestionsFavoritesHot:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getSuggestionsFavoritesHot((VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getSuggestionsUsersHot:(NSString *)category  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getSuggestionsUsersHot([category UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getSuggestionsUsersMayInterested:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getSuggestionsUsersMayInterested((VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getSuggestionsUsersByStatus:(NSString *)content   num:(NSInteger)num  url:(NSString *)url  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getSuggestionsUsersByStatus([content UTF8String], (int)num , [url UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}



#pragma mark - 推荐写入
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 推荐写入
-(AKWeiboResultCode) postSuggestionsUsersNotInterested:(NSString *)uid  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->postSuggestionsUsersNotInterested([uid UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}


#pragma mark - 短链接口
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 短链接口
-(AKWeiboResultCode) getShortURLShorten:(NSString *)url_long  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getShortURLShorten([url_long UTF8String], (UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getShortURLExpand:(NSString *)url_short  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getShortURLExpand([url_short UTF8String], (UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getShortURLShareCounts:(NSString *)url_short  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getShortURLShareCounts([url_short UTF8String], (UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getShortURLShareStatuses:(NSString *)url_short  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getShortURLShareStatuses([url_short UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getShortURLCommentCounts:(NSString *)url_short  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getShortURLCommentCounts([url_short UTF8String], (UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getShortURLCommentComments:(NSString *)url_short  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getShortURLCommentComments([url_short UTF8String], (VariableParams *)[var getCore],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getShortUrlInfo:(NSString *)shortUrlIDs  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getShortUrlInfo([shortUrlIDs UTF8String], (UserTaskInfo *)[pTask getCore]);

}



#pragma mark - 未读信息
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Unread
-(AKWeiboResultCode) getRemindUnreadCount:(NSString *)uid  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getRemindUnreadCount([uid UTF8String], (UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) postStatusesResetCount:(NSInteger)type  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->postStatusesResetCount((int)type, (UserTaskInfo *)[pTask getCore]);

}


#pragma mark - 分组
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Groups
-(AKWeiboResultCode) getGroupsJoined:(NSString *)uid   page:(NSInteger)page   count:(NSInteger)count
                                type:(NSInteger)type   filter:(NSInteger)filter   sort:(NSInteger)sort   member_limit:(NSInteger)member_limit   simplify:(NSInteger)simplify  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getGroupsJoined([uid UTF8String], (int)page, (int)count, (int)type, (int)filter, (int)sort, (int)member_limit, (int)simplify, (UserTaskInfo *)[pTask getCore]);
    

}

-(AKWeiboResultCode) getGroupsShowBatch:(NSString *)gids  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getGroupsShowBatch([gids UTF8String],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getGroupsGetAnnouncement:(NSString *)gid  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getGroupsGetAnnouncement([gid UTF8String],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getGroupsAdmin:(NSString *)gid  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getGroupsAdmin([gid UTF8String],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getGroupsUsers:(NSString *)gid  var:(AKVariableParams*)var  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getGroupsUsers([gid UTF8String], (VariableParams *)[var getCore], (UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getGroupsSuggestionMayInterested:(NSInteger)count  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getGroupsSuggestionMayInterested((int)count,(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getGroupsChatIsBlocked:(NSString *)gids  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getGroupsChatIsBlocked([gids UTF8String],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) postGroupsChatBlock:(NSString *)gid  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->postGroupsChatBlock([gid UTF8String],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) postGroupsChatUnblock:(NSString *)gid  pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->postGroupsChatUnblock([gid UTF8String],(UserTaskInfo *)[pTask getCore]);

}

-(AKWeiboResultCode) getGroupsUsersJoinedStatuses:(NSString *)uid  simplify:(NSInteger)simplify var:(AKVariableParams *)var pTask:(AKUserTaskInfo *) pTask{

    return _weiboMethod->cpp->getGroupsUsersJoinedStatuses([uid UTF8String],(int)simplify,  (VariableParams *)[var getCore], (UserTaskInfo *)[pTask getCore]);

}




@end