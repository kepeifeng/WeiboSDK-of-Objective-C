//
//  AKSDKHelper.m
//  weibosdk
//
//  Created by Kent on 13-12-6.
//
//

#import "AKSDKHelper.h"
#import "NSString+NSString_Extended.h"

@implementation AKTagMethodURLElement
-(id)initWithOption:(AKMethodAction)option URL:(NSString *)url{
    self = [super init];
    if(self){
        self.option = option;
        self.url = url;
        self.hostType = AKHostTypeEHT_V4;
    
    }
    return self;

}

-(id)initWithOption:(AKMethodAction)option URL:(NSString *)url hostType:(AKHostType)hostType{

    self = [super init];
    if(self){
        self.option = option;
        self.url = url;
        self.hostType = hostType;
        
    }
    return self;

}
@end

@implementation AKSDKHelper

static NSArray* _methodURLElement;

+(NSArray *)getMethodURLElement{

    if(_methodURLElement)
        return _methodURLElement;
    
    _methodURLElement = [[NSArray alloc]initWithObjects:[[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_NONE URL:@""],
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_STATUSES_PUBLIC_TIMELINE URL:@"/statuses/public_timeline" hostType:AKHostTypeEHT_V4], //获取最新更新的公共微博消息
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_STATUSES_FRIENDS_TIMELINE URL:@"/statuses/friends_timeline" hostType:AKHostTypeEHT_V4], //获取当前用户所关注用户的最新微博信息 (别名: statuses/home_timeline)
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_STATUSES_HOME_TIMELINE URL:@"/statuses/home_timeline" hostType:AKHostTypeEHT_V4], //获取当前登录用户及其所关注用户的最新微博消息
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_STATUSES_USER_TIMELINE URL:@"/statuses/user_timeline" hostType:AKHostTypeEHT_V4], //获取用户发布的微博信息列表
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_STATUSES_TIMELINE_BATCH URL:@"/statuses/timeline_batch" hostType:AKHostTypeEHT_V4], //批量获得指定的某一批用户的timeline
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_STATUSES_REPOST_TIMELINE URL:@"/statuses/repost_timeline" hostType:AKHostTypeEHT_V4], //返回一条微博的最新n条转发微博信息
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_STATUSES_REPOST_BYME URL:@"/statuses/repost_by_me" hostType:AKHostTypeEHT_V4], //返回用户转发的最新n条微博信息
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_STATUSES_MENTIONS URL:@"/statuses/mentions" hostType:AKHostTypeEHT_V4],//获取@当前用户的微博列表
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_STATUSES_SHOW URL:@"/statuses/show" hostType:AKHostTypeEHT_V4],//根据ID获取单条微博信息
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_STATUSES_SHOW_BATCH URL:@"/statuses/show_batch" hostType:AKHostTypeEHT_V4],//批量获取微博信息
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_STATUSES_QUERYMID URL:@"/statuses/querymid" hostType:AKHostTypeEHT_V4],//通过id获取mid
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_STATUSES_QUERYID URL:@"/statuses/queryid" hostType:AKHostTypeEHT_V4],//通过mid获取id
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_STATUSES_REPOST_DAILY URL:@"/statuses/hot/repost_daily" hostType:AKHostTypeEHT_V4],//按天返回热门转发榜
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_STATUSES_REPOST_WEEKLY URL:@"/statuses/hot/repost_weekly" hostType:AKHostTypeEHT_V4],//按周返回热门转发榜
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_STATUSES_HOT_COMMENTS_DAILY URL:@"/statuses/hot/comments_daily" hostType:AKHostTypeEHT_V4],//按天返回热门评论榜
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_STATUSES_HOT_COMMENTS_WEEKLY URL:@"/statuses/hot/comments_weekly" hostType:AKHostTypeEHT_V4],//按周返回热门评论榜
    
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_POST_STATUSES_REPOST URL:@"/statuses/repost" hostType:AKHostTypeEHT_V4],//转发一条微博信息
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_POST_STATUSES_DESTROY URL:@"/statuses/destroy" hostType:AKHostTypeEHT_V4],//删除微博评论信息
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_POST_STATUSES_UPDATE URL:@"/statuses/update" hostType:AKHostTypeEHT_V4],//发布一条微博信息
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_POST_STATUSES_UPLOAD_URL_TEXT URL:@"/statuses/upload_url_text" hostType:AKHostTypeEHT_V4],//发布一条微博，同时指定上传的图片或图片url
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_POST_STATUSES_UPLOAD URL:@ "/statuses/upload"],//发布一条微博，上传图片并发布一条微博信息
    
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_COMMENTS_SHOW URL:@"/comments/show" hostType:AKHostTypeEHT_V4], //获取某条微博的评论列表
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_COMMENTS_BYME URL:@"/comments/by_me" hostType:AKHostTypeEHT_V4], //我发出的评论列表
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_COMMENTS_TOME URL:@"/comments/to_me" hostType:AKHostTypeEHT_V4], //我收到的评论列表
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_COMMENTS_TIMELINE URL:@"/comments/timeline" hostType:AKHostTypeEHT_V4], //获取当前用户发送及收到的评论列表
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_COMMENTS_MENTIONS URL:@"/comments/mentions" hostType:AKHostTypeEHT_V4], //@到我的评论
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_COMMENTS_SHOWBATCH URL:@"/comments/show_batch" hostType:AKHostTypeEHT_V4], //@批量获取评论内容
    
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_POST_COMMENTS_CREATE URL:@"/comments/create" hostType:AKHostTypeEHT_V4], //评论一条微博
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_POST_COMMENTS_DESTROY URL:@"/comments/destroy" hostType:AKHostTypeEHT_V4], //删除一条评论
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_POST_COMMENTS_DESTROY_BATCH URL:@"/comments/destroy_batch" hostType:AKHostTypeEHT_V4], //批量删除评论
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_POST_COMMENTS_REPLY URL:@"/comments/reply" hostType:AKHostTypeEHT_V4], //回复一条评论
    
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_DIRECTMESSAGES URL:@"/direct_messages" hostType:AKHostTypeEHT_V4], //获取当前用户最新私信列表
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_DIRECTMESSAGES_SENT URL:@"/direct_messages/sent" hostType:AKHostTypeEHT_V4], //获取当前用户发送的最新私信列表
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_DIRECTMESSAGES_USER_LIST URL:@"/direct_messages/user_list" hostType:AKHostTypeEHT_V4], //获取私信往来用户列表
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_DIRECTMESSAGES_CONVERSATION URL:@"/direct_messages/conversation" hostType:AKHostTypeEHT_V4], //获取与指定用户的往来私信列表
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_DIRECTMESSAGES_SHOW_BATCH URL:@"/direct_messages/show_batch" hostType:AKHostTypeEHT_V4], //批量获取私信内容
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_DIRECTMESSAGES_IS_CAPABLE URL:@"/direct_messages/is_capable" hostType:AKHostTypeEHT_V4], //判断是否可以给对方发私信
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_POST_DIRECTMESSAGES_NEW URL:@"/direct_messages/new" hostType:AKHostTypeEHT_V4], //发送一条私信
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_POST_DIRECTMESSAGES_DESTORY URL:@"/direct_messages/destroy" hostType:AKHostTypeEHT_V4], //删除一条私信
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_POST_DIRECTMESSAGES_DESTORY_BATCH URL:@"/direct_messages/destroy_batch" hostType:AKHostTypeEHT_V4],	//批量删除私信
    
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_USERS_SHOW URL:@"/users/show" hostType:AKHostTypeEHT_V4], //获取用户资料
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_USERS_DOMAIN_SHOW URL:@"/users/domain_show" hostType:AKHostTypeEHT_V4], //通过个性域名获取用户信息
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_USERS_SHOW_BATCH URL:@"/users/show_batch" hostType:AKHostTypeEHT_V4], //批量获取用户信息
    
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_ACCOUNT_PROFILE_BASIC URL:@"/account/profile/basic" hostType:AKHostTypeEHT_V4], //获取用户基本信息
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_ACCOUNT_PROFILE_EDUCATION URL:@"/account/profile/education" hostType:AKHostTypeEHT_V4], //获取教育信息
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_ACCOUNT_PROFILE_EDUCATION_BATCH URL:@"/account/profile/education_batch" hostType:AKHostTypeEHT_V4], //批量获取教育信息
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_ACCOUNT_PROFILE_CAREER URL:@"/account/profile/career" hostType:AKHostTypeEHT_V4], //获取职业信息
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_ACCOUNT_PROFILE_CAREER_BATCH URL:@"/account/profile/career_batch" hostType:AKHostTypeEHT_V4], //批量获取职业信息
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_ACCOUNT_GET_PRIVACY URL:@"/account/get_privacy" hostType:AKHostTypeEHT_V4], //获取隐私设置信息
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_ACCOUNT_PROFILE_SCHOOL_LIST URL:@"/account/profile/school_list" hostType:AKHostTypeEHT_V4], //获取所有学校列表
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_ACCOUNT_RATE_LIMIT_STATUS URL:@"/account/rate_limit_status" hostType:AKHostTypeEHT_V4], //获取当前用户API访问频率限制
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_ACCOUNT_GET_UID URL:@"/account/get_uid" hostType:AKHostTypeEHT_V4], //OAuth授权之后获取用户UID（作用相当于旧版接口的account/verify_credentials）
    
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_POST_ACCOUNT_PROFILE_BASIC_UPDATE URL:@"/account/profile/basic_update" hostType:AKHostTypeEHT_V4], // 更新用户基本信息
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_POST_ACCOUNT_PROFILE_EDU_UPDATE URL:@"/account/profile/edu_update" hostType:AKHostTypeEHT_V4], // 更新用户教育信息
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_POST_ACCOUNT_PROFILE_EDU_DESTROY URL:@"/account/profile/edu_destroy" hostType:AKHostTypeEHT_V4], // 删除用户教育信息
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_POST_ACCOUNT_PROFILE_CAR_UPDATE URL:@"/account/profile/car_update" hostType:AKHostTypeEHT_V4], // 更新用户职业信息
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_POST_ACCOUNT_PROFILE_CAR_DESTROY URL:@"/account/profile/car_destroy" hostType:AKHostTypeEHT_V4], // 删除用户职业信息
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_POST_ACCOUNT_AVATAR_UPLOAD URL:@"/account/avatar/upload" hostType:AKHostTypeEHT_V4], // 上传头像
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_POST_ACCOUNT_UPDATE_PRIVACY URL:@"/account/update_privacy" hostType:AKHostTypeEHT_V4], // 更新隐私设置
    
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_FRIENDSHIPS_FRIENDS URL:@"/friendships/friends" hostType:AKHostTypeEHT_V4], //获取用户的关注列表
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_FRIENDSHIPS_IN_COMMON URL:@"/friendships/friends/in_common" hostType:AKHostTypeEHT_V4], //获取共同关注人列表接口
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_FRIENDSHIPS_BILATERAL URL:@"/friendships/friends/bilateral" hostType:AKHostTypeEHT_V4], //获取双向关注列表
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_FRIENDSHIPS_BILATERAL_IDS URL:@"/friendships/friends/bilateral/ids" hostType:AKHostTypeEHT_V4], //获取双向关注ID列表
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_FRIENDSHIPS_FRIENDS_IDS URL:@"/friendships/friends/ids" hostType:AKHostTypeEHT_V4], //获取用户关注对象uid列表
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_FRIENDSHIPS_FRIENDS_REMARK_BATCH URL:@"/friendships/friends/remark_batch"],	//批量获取备注
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_FRIENDSHIPS_FRIENDS_FOLLOWERS URL:@"/friendships/followers" hostType:AKHostTypeEHT_V4], //获取用户粉丝列表及每个粉丝的最新一条微博
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_FRIENDSHIPS_FRIENDS_FOLLOWERS_IDS URL:@"/friendships/followers/ids" hostType:AKHostTypeEHT_V4], //获取用户粉丝对象uid列表
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_FRIENDSHIPS_FRIENDS_FOLLOWERS_ACTIVE URL:@"/friendships/followers/active" hostType:AKHostTypeEHT_V4],		//获取用户优质粉丝列表关系链
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_FRIENDSHIPS_CHAIN_FOLLOWERS URL:@"/friendships/friends_chain/followers" hostType:AKHostTypeEHT_V4], //获取我的关注人中关注了指定用户的分组
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_FRIENDSHIPS_SHOW URL:@"/friendships/show" hostType:AKHostTypeEHT_V4], //获取两个用户关系的详细情况
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_POST_FRIENDSHIPS_CREATE URL:@"/friendships/create" hostType:AKHostTypeEHT_V4], //关注某用户
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_POST_FRIENDSHIPS_CREATE_BATCH URL:@"/friendships/create_batch" hostType:AKHostTypeEHT_V4], //批量关注用户
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_POST_FRIENDSHIPS_DESTROY URL:@"/friendships/destroy" hostType:AKHostTypeEHT_V4], //取消关注某用户
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_POST_FRIENDSHIPS_FOLLOWERS_DESTORY URL:@"/friendships/followers/destroy"], //移除粉丝
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_POST_FRIENDSHIPS_REMARK_UPDATE URL:@"/friendships/remark/update" hostType:AKHostTypeEHT_V4], //更新关注人备注
    
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_FAVORITES URL:@"/favorites" hostType:AKHostTypeEHT_V4], //获取当前登录用户的收藏列表
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_FAVORITES_SHOW URL:@"/favorites/show" hostType:AKHostTypeEHT_V4], //获取单条收藏信息
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_FAVORITES_BY_TAGS URL:@"/favorites/by_tags" hostType:AKHostTypeEHT_V4], //获取当前用户某个标签下的收藏列表
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_FAVORITES_TAGS URL:@"/favorites/tags" hostType:AKHostTypeEHT_V4], //当前登录用户的收藏标签列表
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_POST_FAVORITES_CREATE URL:@"/favorites/create" hostType:AKHostTypeEHT_V4], //添加收藏
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_POST_FAVORITES_DESTROY URL:@"/favorites/destroy" hostType:AKHostTypeEHT_V4], //删除收藏
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_POST_FAVORITES_DESTROY_BATCH URL:@"/favorites/destroy_batch" hostType:AKHostTypeEHT_V4], //批量删除收藏
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_POST_FAVORITES_TAGS_UPDATE URL:@"/favorites/tags/update" hostType:AKHostTypeEHT_V4], //更新收藏标签
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_POST_FAVORITES_TAGS_UPDATE_BATCH URL:@"/favorites/tags/update_batch" hostType:AKHostTypeEHT_V4], //更新当前用户所有收藏下的指定标签
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_POST_FAVORITES_TAGS_DESTROY_BATCH URL:@"/favorites/tags/destroy_batch" hostType:AKHostTypeEHT_V4], //删除当前用户所有收藏下的指定标签
    
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_TRENDS URL:@"/trends" hostType:AKHostTypeEHT_V4], //获取某人话题
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_TRENDS_STATUSES URL:@"/trends/statuses" hostType:AKHostTypeEHT_V4], //获取某一话题下的微博
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_TRENDS_HOURLY URL:@"/trends/hourly" hostType:AKHostTypeEHT_V4], //返回最近一小时内的热门话题
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_TRENDS_DAILY URL:@"/trends/daily" hostType:AKHostTypeEHT_V4], //返回最近一天内的热门话题
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_TRENDS_WEEKLY URL:@"/trends/weekly" hostType:AKHostTypeEHT_V4], //返回最近一周内的热门话题
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_POST_TRENDS_FOLLOW URL:@"/trends/follow" hostType:AKHostTypeEHT_V4], //关注某话题
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_POST_TRENDS_DESTROY URL:@"/trends/destroy" hostType:AKHostTypeEHT_V4], //取消关注的某一个话题
    
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_TAGS URL:@"/tags" hostType:AKHostTypeEHT_V4], //返回指定用户的标签列表
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_TAGS_TAGS_BATCH URL:@"/tags/tags_batch" hostType:AKHostTypeEHT_V4], //批量获取用户标签
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_TAGS_SUGGESTIONS URL:@"/tags/suggestions" hostType:AKHostTypeEHT_V4], //返回系统推荐的标签列表
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_POST_TAGS_CREATE URL:@"/tags/create" hostType:AKHostTypeEHT_V4], //添加用户标签
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_POST_TAGS_DESTROY URL:@"/tags/destroy" hostType:AKHostTypeEHT_V4], //删除用户标签
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_POST_TAGS_DESTROY_BATCH URL:@"/tags/destroy_batch" hostType:AKHostTypeEHT_V4], //批量删除用户标签
    
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_SEARCH_SUGGESTIONS_USERS URL:@"/search/suggestions/users" hostType:AKHostTypeEHT_V4], //搜用户搜索建议
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_SEARCH_SUGGESTIONS_STATUSES URL:@"/search/suggestions/statuses" hostType:AKHostTypeEHT_V4], //搜微博搜索建议
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_SEARCH_SUGGESTIONS_SCHOOLS URL:@"/search/suggestions/schools" hostType:AKHostTypeEHT_V4], //搜学校搜索建议
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_SEARCH_SUGGESTIONS_COMPANIES URL:@"/search/suggestions/companies" hostType:AKHostTypeEHT_V4], //搜公司搜索建议
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_SEARCH_SUGGESTIONS_APPS URL:@ "/search/suggestions/apps"],//搜应用搜索建议
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_SEARCH_SUGGESTIONS_AT_USERS URL:@"/search/suggestions/at_users" hostType:AKHostTypeEHT_V4], //@联想搜索
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_SEARCH_SUGGESTIONS_INTEGRATE URL:@"/search/suggestions/integrate" hostType:AKHostTypeEHT_V4], //综合联想搜索
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_SEARCH_STATUSES URL:@"/search/statuses" hostType:AKHostTypeEHT_V4], //微博搜索
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_SEARCH_GEO_STATUSES URL:@"/search/geo/statuses" hostType:AKHostTypeEHT_V4], //搜索指定范围内的微博
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_SEARCH_USERS URL:@"/search/users" hostType:AKHostTypeEHT_V4], //搜索用户
    
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_SUGGESTIONS_FAVORITES_HOT URL:@"/suggestions/favorites/hot" hostType:AKHostTypeEHT_V4], //热门收藏
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_SUGGESTIONS_USERS_HOT URL:@"/suggestions/users/hot" hostType:AKHostTypeEHT_V4], //获取系统推荐用户
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_SUGGESTIONS_USERS_MAY_INTERESTED URL:@"/suggestions/users/may_interested" hostType:AKHostTypeEHT_V4], //获取用户可能感兴趣的人
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_POST_SUGGESTIONS_USERS_NOT_INTERESTED URL:@"/suggestions/users/not_interested" hostType:AKHostTypeEHT_V4], //不感兴趣的人
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_SUGGESTIONS_USERS_BY_STATUS URL:@"/suggestions/users/by_status" hostType:AKHostTypeEHT_V4], //根据微博内容推荐用户
    
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_SHORT_URL_SHORTEN URL:@"/short_url/shorten" hostType:AKHostTypeEHT_V3], //将一个或多个长链接转换成短链接
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_SHORT_URL_EXPAND URL:@"/short_url/expand" hostType:AKHostTypeEHT_V3], //将一个或多个短链接还原成原始的长链接
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_SHORT_URL_SHARE_COUNTS URL:@"/short_url/share/counts" hostType:AKHostTypeEHT_V3], //取得一个短链接在微博上的微博分享数（包含原创和转发的微博）
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_SHORT_URL_SHARE_STATUSES URL:@"/short_url/share/statuses" hostType:AKHostTypeEHT_V3], //取得包含指定单个短链接的最新微博内容
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_SHORT_URL_COMMENT_COUNTS URL:@"/short_url/comment/counts" hostType:AKHostTypeEHT_V3], //取得一个短链接在微博上的微博评论数
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_SHORT_URL_COMMENT_COMMENTS URL:@"/short_url/comment/comments" hostType:AKHostTypeEHT_V3], //取得包含指定单个短链接的最新微博评论内容
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_SHORT_URL_INFO URL:@"/short_url/batch_info" hostType:AKHostTypeEHT_V3],
    
    // Unread
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_REMIND_UNREAD_COUNT URL:@"/remind/unread_count" hostType:AKHostTypeEHT_V4], //获取某个用户的各种消息未读数
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_POST_STATUSES_RESET_COUNT URL:@"/statuses/reset_count" hostType:AKHostTypeEHT_V3], //type: 1.comments, 2. @me, 3.Direct Message 4. follower
    
    // Groups
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_GROUPS_JOINED URL:@"/groups/joined" hostType:AKHostTypeEHT_V4],
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_GROUPS_SHOW_BATCH URL:@"/groups/show_batch" hostType:AKHostTypeEHT_V4],
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_GROUPS_GET_ANNOUNCEMENT URL:@"/groups/get_announcement" hostType:AKHostTypeEHT_V4],
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_GROUPS_ADMIN URL:@"/groups/%s/admin" hostType:AKHostTypeEHT_V3],
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_GROUPS_USERS URL:@"/groups/%s/users" hostType:AKHostTypeEHT_V3],
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_GROUPS_SUGGESTION_MAY_INTERESTED URL:@"/groups/suggestions/may_interested" hostType:AKHostTypeEHT_V3],
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_GROUPS_CHAT_BLOCK URL:@"/groups/chat/block" hostType:AKHostTypeEHT_V4],
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_GROUPS_CHAT_UNBLOCK URL:@"/groups/chat/unblock" hostType:AKHostTypeEHT_V4],
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_GROUPS_CHAT_IS_BLOCKED URL:@"/groups/chat/is_blocked" hostType:AKHostTypeEHT_V4],
    [[AKTagMethodURLElement alloc]initWithOption:AKWBOPT_GET_GROUP_USERS_JOINED_STATUSES URL:@"/groups/statuses/joined_timeline" hostType:AKHostTypeEHT_V4], nil];
    

    return _methodURLElement;


}


+(NSString *)getMethodBaseURL:(AKHostType)hostType{

    switch (hostType) {
        case AKHostTypeEHT_V3:
            return @"https://api.t.sina.com.cn";
            break;
        case AKHostTypeEHT_V4:
            return @"https://api.weibo.com/2";
            break;
            
        default:
            break;
    }
    return nil;

}


+(NSString *)getMethodURLFromOption:(NSUInteger)methodOption{

    NSArray *methodURLElementArray = [AKSDKHelper getMethodURLElement];
    AKTagMethodURLElement *methoURLElement;
    for(int i=0; i<methodURLElementArray.count; i++){
    
        AKTagMethodURLElement *tmpElement = [methodURLElementArray objectAtIndex:i];
        if (tmpElement.option == methodOption) {
            methoURLElement = tmpElement;
            break;
        }
    
    }
    NSString *baseURL = [AKSDKHelper getMethodBaseURL:methoURLElement.hostType];
    baseURL = [baseURL stringByAppendingString:methoURLElement.url];
    
    return baseURL;

}


+(void) setParam:(NSString **) param paramname:(NSString *)paramname paramval:(NSString *)paramval{

    [AKSDKHelper setParam:param paramname:paramname paramval:paramval paramformat:0];


}

/** Param setting function */
+(void) setParam:(NSString **) param paramname:(NSString *)paramname paramval:(NSString *)paramval paramformat:(NSInteger)paramformat{

    

    if(!paramval){
        return;
    }
    
    *param = [NSString stringWithFormat:@"%@%@=%@",(*param)?*param:@"",paramname,[paramval urlEncode]];

}

+(void) setIntParam:(NSString **)param paramName:(NSString *)paramName paramval:(long long)paramval{

    [AKSDKHelper setIntParam:param paramName:paramName paramval:paramval forceAdd:NO];
}

+(void) setIntParam:(NSString **)param paramName:(NSString *)paramName paramval:(long long)paramval forceAdd:(BOOL)forceAdd{

    if(!forceAdd && paramval<=0){
        return;
    }
    return [AKSDKHelper setParam:param paramname:paramName paramval:[NSString stringWithFormat:@"%lld",paramval] paramformat:0];


}

/** Split string */
//+(void) split(std::vector<NSString *>& outVector, const char* string, const char splite);

+(AKWeiboRequest *)makeRequest:(NSUInteger)methodOption addtionParam:(NSString *)addtionParam reqformat:(AKWeiboRequestFormat)reqformat httpMethod:(NSString *)httpMethod appkey:(NSString *)appkey accessToken:(NSString *)accessToken pTask:(AKUserTaskInfo*) pTask{

    //    request.
    
    NSString *baseURL = [AKSDKHelper getMethodURLFromOption:methodOption];
    if(reqformat == WRF_JSON){
        baseURL = [baseURL stringByAppendingString:@".json"];
        
    }
    else if(reqformat == WRF_XML){
        baseURL = [baseURL stringByAppendingString:@".xml"];
    }
    
    if(addtionParam && addtionParam.length>0){
    
        if([baseURL rangeOfString:@"?"].location == NSNotFound){
        
            //如果addtionParam>1,既是说additionParam是以&开头的，因此添加时要把开头的&去掉
            baseURL = [NSString stringWithFormat:@"%@?%@",baseURL,addtionParam.length>1?[addtionParam substringFromIndex:1]:addtionParam];
        }
        else{
            
            baseURL = [baseURL stringByAppendingString:addtionParam];
        }
    
    }


    NSString *requestURL;
    NSString *postArgument;
    [AKSDKHelper makeRequestURL:&requestURL outParam:&postArgument baseURL:baseURL isPost:![httpMethod isEqualToString:@"GET"] appkey:appkey accessToken:accessToken];
    
    AKWeiboRequest *request = [[AKWeiboRequest alloc]initWithURL:[NSURL URLWithString:requestURL]];
    //request.HTTPMethod = httpMethod;
    request.option = methodOption;
    request.HTTPMethod = httpMethod;
    request.HTTPBody = [postArgument dataUsingEncoding:NSUTF8StringEncoding];
    request.postArgument = postArgument;
//    request.accessToken = 
    if(pTask){
       request.taskInfo = [pTask copy];
    }
    
    return request;
    

}

+(void) makeRequestURL:(NSString **)outURL outParam:(NSString **)outParam baseURL:(NSString *)baseURL isPost:(BOOL)isPost appkey:(NSString *)appKey accessToken:(NSString *)accessToken{
    
    if(isPost){
    
        NSRange urlParamSpliterLocation = [baseURL rangeOfString:@"?"];
        if(urlParamSpliterLocation.location !=NSNotFound){
        
            *outURL = [baseURL substringWithRange:NSMakeRange(0, urlParamSpliterLocation.location)];
            *outParam = [baseURL substringFromIndex:urlParamSpliterLocation.location+urlParamSpliterLocation.length];
            
        }
        if([*outParam rangeOfString:@"access_token="].location == NSNotFound){
        
            *outParam = [NSString stringWithFormat:@"%@%@%@",*outParam, @"&access_token=", accessToken];
        }
        
        
    }
    else{
    
        *outURL = baseURL;
        if([*outURL rangeOfString:@"?"].location == NSNotFound){
            *outURL = [NSString stringWithFormat:@"%@%@%@",*outURL,@"?source=",appKey];
        
        }
        else{
            *outURL = [NSString stringWithFormat:@"%@%@%@",*outURL,@"&source=",appKey];
        
        }
        
        if([*outURL rangeOfString:@"access_token="].location == NSNotFound){
        
            *outURL = [NSString stringWithFormat:@"%@%@%@",*outURL, @"&access_token=",accessToken];
        }
        
    
    }


}

+(void) makeIDParams:(NSString **)outParam length:(NSInteger)length userID:(AKID *)userID{
    
    if(!userID){
        return;
        
    }
    if(!userID.keyName || [userID.keyName isEqualToString:@""]){
        if(userID.idType == AKIDTypeID){
        
            [AKSDKHelper setParam:outParam paramname:@"&uid" paramval:userID.ID paramformat:0];
        }else if (userID.idType == AKIDTypeScreenname){
            [AKSDKHelper setParam:outParam paramname:@"&screen_name" paramval:userID.ID paramformat:0];
        
        }
    
    }else{
        
        [AKSDKHelper setParam:outParam paramname:[NSString stringWithFormat:@"&%@",userID.keyName] paramval:userID.ID paramformat:1];
    
    }


}

+(void) makeVariableParams:(NSString **)outParam length:(NSInteger)length  var:(AKVariableParams*)var{
    
    if(!var)
    {
        return;
        
    }
    
    //SDKHelper::setIntParam(outParam, "&since_id", var->since_id);
    [AKSDKHelper setIntParam:outParam paramName:@"&since_id" paramval:var.since_id forceAdd:NO];
    
    [AKSDKHelper setIntParam:outParam paramName:@"&max_id" paramval:var.max_id forceAdd:NO];
	[AKSDKHelper setIntParam:outParam paramName:@"&count" paramval:var.count forceAdd:NO];
	[AKSDKHelper setIntParam:outParam paramName:@"&page" paramval:var.page forceAdd:NO];
	[AKSDKHelper setIntParam:outParam paramName:@"&base_app" paramval:var.base_app forceAdd:NO];
	[AKSDKHelper setIntParam:outParam paramName:@"&feature" paramval:var.feature forceAdd:NO];
	[AKSDKHelper setIntParam:outParam paramName:@"&is_encoded" paramval:var.is_encoded forceAdd:NO];
	[AKSDKHelper setIntParam:outParam paramName:@"&cursor" paramval:var.cursor forceAdd:NO];
    
	// variable for statuses
    [AKSDKHelper setParam:outParam paramname:@"&simplify" paramval:var.simplify];
    [AKSDKHelper setParam:outParam paramname:@"&access_token" paramval:var.accessToken];
    
	[AKSDKHelper setIntParam:outParam paramName:@"&filter_by_source" paramval:var.filter_by_source forceAdd:NO];
	[AKSDKHelper setIntParam:outParam paramName:@"&filter_by_type" paramval:var.filter_by_type forceAdd:NO];
	[AKSDKHelper setIntParam:outParam paramName:@"&filter_by_author" paramval:var.filter_by_author forceAdd:NO];
	[AKSDKHelper setIntParam:outParam paramName:@"&trim_user" paramval:var.trim_user forceAdd:NO];
	[AKSDKHelper setIntParam:outParam paramName:@"&trim_status" paramval:var.trim_status forceAdd:NO];
    


}


@end
