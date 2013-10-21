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

    AKWeiboMethodOpaque();
    IWeiboMethod *cpp;
    

};

@implementation AKWeiboMethod



-(UserTaskInfo *)convertUserTaskInfo:(AKUserTaskInfo *)userTaskInfo{
    
    if(!userTaskInfo){
        
        return NULL;
    }
    
    UserTaskInfo *newUserTaskInfo = new UserTaskInfo();
    const char *cpUserTaskInfo = [userTaskInfo.mTaskId UTF8String];
    strncpy(newUserTaskInfo->mTaskId, cpUserTaskInfo, 255);
    newUserTaskInfo->mUsrData = (__bridge void*)userTaskInfo.mUsrData;
    
    return newUserTaskInfo;
    
    //newUserTaskInfo->mTaskId = [userTaskInfo.mTaskId cStringUsingEncoding:NSUTF8StringEncoding];
    
}

#pragma mark - 身份验证

-(AKWeiboResultCode)oauth2:(NSString *)userName password:(NSString *)password task:(AKUserTaskInfo *)pTask{

    return _weiboMethod->cpp->oauth2([userName cStringUsingEncoding:NSUTF8StringEncoding], [password cStringUsingEncoding:NSUTF8StringEncoding], [self convertUserTaskInfo:pTask]);

}



-(AKWeiboResultCode)oauth2Code:(NSString *)userName password:(NSString *)password  pTask:(AKUserTaskInfo*) pTask{



}

-(AKWeiboResultCode)endSession{}


#pragma mark - 微博读取
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 微博读取
-(AKWeiboResultCode) getStatusesPublicTimeline:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getStatusesFriendTimeline:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getStatusesHomeTimeline:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getStatusesUserTimeline:(AKID *)usrId  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getStatusesTimelineBatch:(AKID *)usrId  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getStatusesRepostTimeline:(NSString *)id  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getStatusesRepostByMe:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getStatusesMentions:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getStatusesShow:(NSString *)id  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getStatusesShowBatch:(NSString *)inputIDs  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getStatusesQueryMID:(NSString *) weiboId    type:(NSInteger)type  is_batch:(NSInteger) is_batch  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getStatusesQueryID:(NSString *) mId    type:(NSInteger)type  is_batch:(NSInteger) is_batch  inbox:(NSInteger) inbox  isBase62:(NSInteger) isBase62  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getStatusesRepostDaily:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getStatusesRepostWeekly:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getStatusesHotCommmentsDaily:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getStatusesHotCommmentsWeekly:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}


#pragma mark - 微博写入
// 微博写入
-(AKWeiboResultCode) postStatusesRepost:(NSString *) weiboId   statusText:(NSString *)statusText isComment:(NSInteger)isComment  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) postStatusesDestroy:(NSString *) weiboId   var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) postStatusesUpdate:(NSString *)statusText  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) postStatusesUploadUrlText:(NSString *)statusText  picInfo:(NSString *)picInfo  isPicUrl:(BOOL)isPicUrl  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) postStatusesUpload:(NSString *)statusText  filePath:(NSString *)filePath  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}

#pragma mark - 评论读取
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 评论读取
-(AKWeiboResultCode) getCommentsShow:(NSString *) weiboId   var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getCommentsByMe:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getCommentsToMe:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getCommentsTimeline:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getCommentsMentions:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}


#pragma mark - 评论写入
// 评论写入
-(AKWeiboResultCode) getCommentsShowBatch:(NSString *)commentIds  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) postCommentsCreate:(NSString *)postId comment:(NSString *)comment   commentOri:(NSInteger)commentOri var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) postCommentsDestroy:(NSString *)postId  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) postCommentsDestroyBatch:(NSString *)postId  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) postCommentsReply:(NSString *) commentId comment:(NSString *)comment weiboId:(NSString *)weiboId
                        withoutMention:(NSInteger)withoutMention   commentOri:(NSInteger)commentOri  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}


#pragma mark - 私信读取
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 私信读取
-(AKWeiboResultCode) getDirectMessages:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getDirectMessagesSent:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getDirectMessagesUserList:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getDirectMessagesCoversation:(AKID  *)usrId  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getDirectMessagesShowBatch:(NSString *)id  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getDirectMessagesIsCapable:(NSString *)uid  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}


#pragma mark - 私信写入
// 私信写入
-(AKWeiboResultCode) postDirectMessagesNew:(NSString *)text uid:(AKID *) uid fields:(NSString *)fields
                                   weiboId:(NSString *) weiboId  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) postDirectMessagesDestory:(NSString *)id  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) postDirectMessagesDestoryBatch:(NSString *)ids uid:(NSString *)uid  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}



#pragma mark - 用户读取
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 用户读取
-(AKWeiboResultCode) getUsersShow:(AKID *)usrId extend:(NSString *)extend var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getUsersDomainShow:(NSString *) domain  extend:(NSString *)extend  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getUsersShowBatch:(AKID *)usrId extend:(NSString *)extend  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}


#pragma mark - 关注读取
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 关注读取
-(AKWeiboResultCode) getFriendshipsFriends:(AKID *)usrId   order:(NSInteger)order/**/  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask {}
-(AKWeiboResultCode) getFriendshipsInCommon:(NSString *) id suid:(NSString *)suid  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask {}
-(AKWeiboResultCode) getFriendshipsBilateral:(NSString *)uid  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask {}
-(AKWeiboResultCode) getFriendshipsBilateralIDs:(NSString *)uid  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask {}
-(AKWeiboResultCode) getFriendshipsFriendIDs:(AKID *)usrId  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask {}
-(AKWeiboResultCode) getFriendshipsFriendRemarkBatch:(NSString *)uids  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask {}

#pragma mark - 粉丝读取
// 粉丝读取
-(AKWeiboResultCode) getFriendshipsFriendsFollowers:(AKID *)usrId  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getFriendshipsFriendsFollowersIDs:(AKID *)usrId  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask {}
-(AKWeiboResultCode) getFriendshipsFriendsFollowersActive:(AKID *)usrIDs  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask {}


#pragma mark - 关系链读取
// 关系链读取
-(AKWeiboResultCode) getFriendshipsFriendsChainFollowers:(NSString *)uid  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask {}


#pragma mark - 关系状态
// 关系状态
-(AKWeiboResultCode) getFriendshipShow:(AKID *)sourceId targetId:(AKID *)targetId  pTask:(AKUserTaskInfo *) pTask {}


#pragma mark - 关系写入
// 关系写入
-(AKWeiboResultCode) postFriendshipsCreate:(AKID *)usrId   skipCheck:(NSInteger)skipCheck  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask {}
-(AKWeiboResultCode) postFriendshipsCreateBatch:(NSString *)uids  pTask:(AKUserTaskInfo *) pTask {}
-(AKWeiboResultCode) postFriendshipsDestroy:(AKID *)usrId  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask {}
-(AKWeiboResultCode) postFriendshipsFollowersDestroy:(NSString *)uid  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask {}
-(AKWeiboResultCode) postFriendshipsRemarkUpdate:(NSString *) uid remark:(NSString *)remark  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask {}



#pragma mark - 帐号读取
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 帐号读取
-(AKWeiboResultCode) getAccountProfileBasic:(NSString *) uid   pTask:(AKUserTaskInfo *) pTask {}
-(AKWeiboResultCode) getAccountProfileEducation:(NSString *)uid  pTask:(AKUserTaskInfo *) pTask {}
-(AKWeiboResultCode) getAccountProfileEducationBatch:(NSString *)uids  pTask:(AKUserTaskInfo *) pTask {}
-(AKWeiboResultCode) getAccountProfileCareer:(NSString *)uid  pTask:(AKUserTaskInfo *) pTask {}
-(AKWeiboResultCode) getAccountProfileCareerBatch:(NSString *)uids  pTask:(AKUserTaskInfo *) pTask {}
-(AKWeiboResultCode) getAccountGetPrivacy:(AKUserTaskInfo *) pTask {}
-(AKWeiboResultCode) getAccountProfileSchoolList:(NSInteger) province  city:(NSInteger) city  area:(NSInteger) area  type:(NSInteger) type
                                         capital:(NSString *)capital keyword:(NSString *)keyword  counts:(NSInteger) counts  pTask:(AKUserTaskInfo *) pTask {}
-(AKWeiboResultCode) getAccountRateLimitStatus:(AKUserTaskInfo *) pTask {}
-(AKWeiboResultCode) getAccountGetUID:(AKUserTaskInfo *) pTask {}



#pragma mark - 帐号写入
// 帐号写入
-(AKWeiboResultCode) postAccountProfileBasicUpdate:(AKBasicInfo*)basic  pTask:(AKUserTaskInfo *) pTask {}
-(AKWeiboResultCode) postAccountProfileEduUpdate:(AKEducationInfo *)edu  pTask:(AKUserTaskInfo *) pTask {}
-(AKWeiboResultCode) postAccountProfileEduDestroy:(NSString *)id  pTask:(AKUserTaskInfo *) pTask {}
-(AKWeiboResultCode) postAccountProfileCarUpdate:(AKCareerInfo *) career  pTask:(AKUserTaskInfo *) pTask {}
-(AKWeiboResultCode) postAccountProfileCarDestroy:(NSString *)id  pTask:(AKUserTaskInfo *) pTask {}
-(AKWeiboResultCode) postAccountAvatarUpload:(NSString *)filePath  pTask:(AKUserTaskInfo *) pTask {}
-(AKWeiboResultCode) postAccountUpdatePrivacy:(NSInteger) comment  geo:(NSInteger) geo  message:(NSInteger) message
                                     realname:(NSInteger) realname  badge:(NSInteger) badge  mobile:(NSInteger) mobile  pTask:(AKUserTaskInfo *) pTask {}


#pragma mark - 收藏读取
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 收藏读取
-(AKWeiboResultCode) getFavorites:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getFavoritesShow:(NSString *)id  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getFavoritesByTags:(NSString *)tid  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getFavoritesTags:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}


#pragma mark - 收藏写入
// 收藏写入
-(AKWeiboResultCode) postFavoritesCreate:(NSString *)id  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) postFavoritesDestroy:(NSString *)id  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) postFavoritesDestroyBatch:(NSString *)ids  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) postFavoritesTagUpdate:(NSString *)tagId tagName:(NSString *)tagName  var:(AKVariableParams *)var  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) postFavoritesTagsUpdateBatch:(NSString *)tagId tagName:(NSString *)tagName  var:(AKVariableParams *)var  pTask:(AKUserTaskInfo *)pTask{}
-(AKWeiboResultCode) postFavoritesTagsDestroyBatch:(NSString *)tagId  var:(AKVariableParams *)var  pTask:(AKUserTaskInfo *)pTask{}



#pragma mark - 话题读取
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 话题读取
-(AKWeiboResultCode) getTrends:(NSString *)uid  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getTrendsStatuses:(NSString *)trendWords provinceId:(NSString *)provinceId  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getTrendsHourly:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getTrendsDaily:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getTrendsWeekly:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}


#pragma mark - 话题写入
// 话题写入
-(AKWeiboResultCode) postTrendsFollow:(NSString *)trendName  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) postTrendsDestroy:(NSString *)trendId  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}



#pragma mark - 标签读取
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 标签读取
-(AKWeiboResultCode) getTags:(NSString *)uid  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getTagsTagsBatch:(NSString *)uids  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getTagsSuggestions:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}



#pragma mark - 标签写入
// 标签写入
-(AKWeiboResultCode) postTagsCreate:(NSString *)tags  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) postTagsDestroy:(NSString *)tagId  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) postTagsDestroyBatch:(NSString *)tagIds  pTask:(AKUserTaskInfo *) pTask{}


#pragma mark - 搜索
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 搜索
-(AKWeiboResultCode) getSearchSuggestionsUsers:(NSString *)q  count:(NSInteger) count  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getSearchSuggestionsStatues:(NSString *)q  count:(NSInteger) count  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getSearchSuggestionsSchool:(NSString *)q  count:(NSInteger) count  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getSearchSuggestionsCompanies:(NSString *)q  count:(NSInteger) count  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getSearchSuggestionsApps:(NSString *)q  count:(NSInteger) count  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getSearchSuggestionsAtUsers:(NSString *)q   type:(NSInteger)type  count:(NSInteger) count  range:(NSInteger) range  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getSearchSuggestionsIntegrate:(NSString *)query  sort_user:(NSInteger) sort_user  sort_app:(NSInteger) sort_app
                                          sort_grp:(NSInteger) sort_grp  user_count:(NSInteger) user_count  app_count:(NSInteger) app_count  grp_count:(NSInteger) grp_count  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getSearchStatuses:(NSString *)q  filter_ori:(NSInteger) filter_ori   filter_pic:(NSInteger)filter_pic  fuid:(NSString *)fuid
                              province:(NSInteger) province   city:(NSInteger)city  starttime:(NSString *)starttime endtime:(NSString *)endtime  count:(NSInteger) count
                                  page:(NSInteger) page  needcount:(BOOL)needcount  base_app:(NSInteger) base_app  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getSearchGeoStatuses:(float) longitude  latitudeconst:(float)latitudeconst  range:(NSInteger) range  time:(NSInteger) time
                                sort_type:(NSInteger) sort_type  page:(NSInteger) page  count:(NSInteger) count  base_app:(NSInteger) base_app  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getSearchUsers:(NSString *)q  snick:(NSInteger) snick  sdomain:(NSInteger) sdomain  sintro:(NSInteger) sintro  stag:(NSInteger) stag
                           province:(NSInteger) province   city:(NSInteger)city  gender:(NSString *)gender  comorsch:(NSString *)comorsch   sort:(NSInteger) sort
                              count:(NSInteger) count  page:(NSInteger) page  base_app:(NSInteger) base_app  pTask:(AKUserTaskInfo *) pTask{}


#pragma mark - 推荐读取
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 推荐读取
-(AKWeiboResultCode) getSuggestionsFavoritesHot:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getSuggestionsUsersHot:(NSString *)category  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getSuggestionsUsersMayInterested:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getSuggestionsUsersByStatus:(NSString *)content   num:(NSInteger)num  url:(NSString *)url  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}



#pragma mark - 推荐写入
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 推荐写入
-(AKWeiboResultCode) postSuggestionsUsersNotInterested:(NSString *)uid  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}


#pragma mark - 短链接口
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 短链接口
-(AKWeiboResultCode) getShortURLShorten:(NSString *)url_long  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getShortURLExpand:(NSString *)url_short  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getShortURLShareCounts:(NSString *)url_short  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getShortURLShareStatuses:(NSString *)url_short  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getShortURLCommentCounts:(NSString *)url_short  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getShortURLCommentComments:(NSString *)url_short  var:(AKVariableParams *) var  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getShortUrlInfo:(NSString *)shortUrlIDs  pTask:(AKUserTaskInfo *) pTask{}



#pragma mark - 未读信息
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Unread
-(AKWeiboResultCode) getRemindUnreadCount:(NSString *)uid  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) postStatusesResetCount:(NSInteger)type  pTask:(AKUserTaskInfo *) pTask{}


#pragma mark - 分组
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Groups
-(AKWeiboResultCode) getGroupsJoined:(NSString *)uid   page:(NSInteger)page   count:(NSInteger)count
                                type:(NSInteger)type   filter:(NSInteger)filter   sort:(NSInteger)sort   member_limit:(NSInteger)member_limit   simplify:(NSInteger)simplify  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getGroupsShowBatch:(NSString *)gids  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getGroupsGetAnnouncement:(NSString *)gid  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getGroupsAdmin:(NSString *)gid  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getGroupsUsers:(NSString *)gid  var:(AKVariableParams*)var  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getGroupsSuggestionMayInterested:(NSInteger)count  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getGroupsChatIsBlocked:(NSString *)gids  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) postGroupsChatBlock:(NSString *)gid  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) postGroupsChatUnblock:(NSString *)gid  pTask:(AKUserTaskInfo *) pTask{}
-(AKWeiboResultCode) getGroupsUsersJoinedStatuses:(NSString *)uid  simplify:(NSInteger)simplify var:(AKVariableParams *)var pTask:(AKUserTaskInfo *) pTask{}




@end