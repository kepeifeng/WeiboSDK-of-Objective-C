//***********************************************
//粉丝服务（查看指南）
//***********************************************

/**
 *  接收用户私信、关注、取消关注、@等消息接口
 *
 *  [读取接口 ]messages/receive
 *  @see http://open.weibo.com/wiki/2/messages/receive
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  向用户回复私信消息接口
 *
 *  [写入接口 ]messages/reply
 *  @see http://open.weibo.com/wiki/2/messages/reply
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  根据粉丝设置的提醒条件进行私信提醒消息接口
 *
 *  [写入接口 ]messages/send
 *  @see http://open.weibo.com/wiki/2/messages/send
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  向订阅用户发送私信消息接口
 *
 *  [写入接口 ]messages/post
 *  @see http://open.weibo.com/wiki/%E8%AE%A2%E9%98%85%E5%8F%91%E9%80%81
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

//***********************************************
//邀请（查看指南）
//***********************************************

/**
 *  向互粉好友发送私信邀请、送礼物消息接口
 *
 *  [写入接口 ]messages/invite
 *  @see http://open.weibo.com/wiki/2/messages/invite
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

//***********************************************
//微博
//***********************************************







/**
 *  获取当前登录用户及其所关注用户的最新微博的ID
 *
 *  [读取接口 ]statuses/friends_timeline/ids
 *  @see http://open.weibo.com/wiki/2/statuses/friends_timeline/ids
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */



/**
 *  获取用户发布的微博的ID
 *
 *  [读取接口 ]statuses/user_timeline/ids
 *  @see http://open.weibo.com/wiki/2/statuses/user_timeline/ids
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */




/**
 *  获取一条原创微博的最新转发微博的ID
 *
 *  [读取接口 ]statuses/repost_timeline/ids
 *  @see http://open.weibo.com/wiki/2/statuses/repost_timeline/ids
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */



/**
 *  获取@当前用户的最新微博的ID
 *
 *  [读取接口 ]statuses/mentions/ids
 *  @see http://open.weibo.com/wiki/2/statuses/mentions/ids
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  获取双向关注用户的最新微博
 *
 *  [读取接口 ]statuses/bilateral_timeline
 *  @see http://open.weibo.com/wiki/2/statuses/bilateral_timeline
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */






/**
 *  批量获取指定微博的转发数评论数
 *
 *  [读取接口 ]statuses/count
 *  @see http://open.weibo.com/wiki/2/statuses/count
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  获取当前登录用户关注的人发给其的定向微博
 *
 *  [读取接口 ]statuses/to_me
 *  @see http://open.weibo.com/wiki/2/statuses/to_me
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  获取当前登录用户关注的人发给其的定向微博ID列表
 *
 *  [读取接口 ]statuses/to_me/ids
 *  @see http://open.weibo.com/wiki/2/statuses/to_me/ids
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  根据ID跳转到单条微博页
 *
 *  [读取接口 ]statuses/go
 *  @see http://open.weibo.com/wiki/2/statuses/go
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  获取官方表情
 *
 *  [读取接口 ]emotions
 *  @see http://open.weibo.com/wiki/2/emotions
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */











/**
 *  屏蔽某条微博
 *
 *  [写入接口 ]statuses/filter/create
 *  @see http://open.weibo.com/wiki/2/statuses/filter/create
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  屏蔽某个@我的微博及后续由其转发引起的@提及
 *
 *  [写入接口 ]statuses/mentions/shield
 *  @see http://open.weibo.com/wiki/2/statuses/mentions/shield
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

//***********************************************
//评论
//***********************************************




















//***********************************************
//用户
//***********************************************




/**
 *  批量获取用户的粉丝数、关注数、微博数
 *
 *  [读取接口 ]users/counts
 *  @see http://open.weibo.com/wiki/2/users/counts
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

//***********************************************
//置顶微博
//***********************************************

/**
 *  获取用户主页置顶微博
 *
 *  [读取接口 ]users/get_top_status
 *  @see http://open.weibo.com/wiki/2/users/get_top_status
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  设置用户主页置顶微博
 *
 *  [写入接口 ]users/set_top_status
 *  @see http://open.weibo.com/wiki/2/users/set_top_status
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  取消用户主页置顶微博
 *
 *  [写入接口 ]users/cancel_top_status
 *  @see http://open.weibo.com/wiki/2/users/cancel_top_status
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

//***********************************************
//关系
//***********************************************



























//***********************************************
//好友分组
//***********************************************








//***********************************************
//账号
//***********************************************







/**
 *  获取用户的联系邮箱
 *
 *  [读取接口 ]account/profile/email
 *  @see http://open.weibo.com/wiki/2/account/profile/email
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */




//***********************************************
//收藏
//***********************************************



/**
 *  获取当前用户的收藏列表的ID
 *
 *  [读取接口 ]favorites/ids
 *  @see http://open.weibo.com/wiki/2/favorites/ids
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */







/**
 *  获取当前用户某个标签下的收藏列表的ID
 *
 *  [读取接口 ]favorites/by_tags/ids
 *  @see http://open.weibo.com/wiki/2/favorites/by_tags/ids
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */
















//***********************************************
//微博标签
//***********************************************



/**
 *  批量获取微博标签
 *
 *  [读取接口 ]statuses/tags/show_batch
 *  @see http://open.weibo.com/wiki/2/statuses/tags/show_batch
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  获取用户某个标签的微博ID列表
 *
 *  [读取接口 ]statuses/tag_timeline/ids
 *  @see http://open.weibo.com/wiki/2/statuses/tag_timeline/ids
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  获取用户的微博标签列表
 *
 *  [读取接口 ]statuses/tags
 *  @see http://open.weibo.com/wiki/2/statuses/tags
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。
 
 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */



/**
 *  更新标签
 *
 *  [写入接口 ]statuses/tags/update
 *  @see http://open.weibo.com/wiki/2/statuses/tags/update
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  更新某个微博的标签
 *
 *  [写入接口 ]statuses/update_tags
 *  @see http://open.weibo.com/wiki/2/statuses/update_tags
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  创建标签
 *
 *  [写入接口 ]statuses/tags/create
 *  @see http://open.weibo.com/wiki/2/statuses/tags/create
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。
 
 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  删除标签
 *
 *  [写入接口 ]statuses/tags/destroy
 *  @see http://open.weibo.com/wiki/2/statuses/tags/destroy
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。
 
 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */
//***********************************************
//用户标签
//***********************************************













//***********************************************
//注册
//***********************************************

/**
 *  验证昵称是否可用
 *
 *  [读取接口 ]register/verify_nickname
 *  @see http://open.weibo.com/wiki/2/register/verify_nickname
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

//***********************************************
//搜索
//***********************************************











/**
 *  搜索某一话题下的微博
 *
 *  [搜索话题接口 ]search/topics
 *  @see http://open.weibo.com/wiki/2/search/topics
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */








/**
 *  主Feed微博按兴趣推荐排序
 *
 *  [读取接口 ]suggestions/statuses/reorder
 *  @see http://open.weibo.com/wiki/2/suggestions/statuses/reorder
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  主Feed微博按兴趣推荐排序的微博ID
 *
 *  [读取接口 ]suggestions/statuses/reorder/ids
 *  @see http://open.weibo.com/wiki/2/suggestions/statuses/reorder/ids
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */






















//***********************************************
//通知
//***********************************************

/**
 *  给一个或多个用户发送一条新的状态通知
 *
 *  [发送接口 ]notification/send
 *  @see http://open.weibo.com/wiki/2/notification/send
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

//***********************************************
//公共服务
//***********************************************

/**
 *  通过地址编码获取地址名称
 *
 *  [读取接口 ]common/code_to_location
 *  @see http://open.weibo.com/wiki/2/common/code_to_location
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  获取城市列表
 *
 *  [读取接口 ]common/get_city
 *  @see http://open.weibo.com/wiki/2/common/get_city
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  获取省份列表
 *
 *  [读取接口 ]common/get_province
 *  @see http://open.weibo.com/wiki/2/common/get_province
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  获取国家列表
 *
 *  [读取接口 ]common/get_country
 *  @see http://open.weibo.com/wiki/2/common/get_country
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  获取时区配置表
 *
 *  [读取接口 ]common/get_timezone
 *  @see http://open.weibo.com/wiki/2/common/get_timezone
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

//***********************************************
//位置服务（开发指南）
//***********************************************

/**
 *  获取公共的位置动态
 *
 *  [动态读取接口 ]place/public_timeline
 *  @see http://open.weibo.com/wiki/2/place/public_timeline
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  获取用户好友的位置动态
 *
 *  [动态读取接口 ]place/friends_timeline
 *  @see http://open.weibo.com/wiki/2/place/friends_timeline
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  获取某个用户的位置动态
 *
 *  [动态读取接口 ]place/user_timeline
 *  @see http://open.weibo.com/wiki/2/place/user_timeline
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  获取某个位置地点的动态
 *
 *  [动态读取接口 ]place/poi_timeline
 *  @see http://open.weibo.com/wiki/2/place/poi_timeline
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  获取某个位置周边的动态
 *
 *  [动态读取接口 ]place/nearby_timeline
 *  @see http://open.weibo.com/wiki/2/place/nearby_timeline
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  获取动态的详情
 *
 *  [动态读取接口 ]place/statuses/show
 *  @see http://open.weibo.com/wiki/2/place/statuses/show
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  获取LBS位置服务内的用户信息
 *
 *  [用户读取接口 ]place/users/show
 *  @see http://open.weibo.com/wiki/2/place/users/show
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  获取用户签到过的地点列表
 *
 *  [用户读取接口 ]place/users/checkins
 *  @see http://open.weibo.com/wiki/2/place/users/checkins
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  获取用户的照片列表
 *
 *  [用户读取接口 ]place/users/photos
 *  @see http://open.weibo.com/wiki/2/place/users/photos
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  获取用户的点评列表
 *
 *  [用户读取接口 ]place/users/tips
 *  @see http://open.weibo.com/wiki/2/place/users/tips
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  获取用户的todo列表
 *
 *  [用户读取接口 ]place/users/todos
 *  @see http://open.weibo.com/wiki/2/place/users/todos
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  获取地点详情
 *
 *  [地点读取接口 ]place/pois/show
 *  @see http://open.weibo.com/wiki/2/place/pois/show
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  获取在某个地点签到的人的列表
 *
 *  [地点读取接口 ]place/pois/users
 *  @see http://open.weibo.com/wiki/2/place/pois/users
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  获取地点点评列表
 *
 *  [地点读取接口 ]place/pois/tips
 *  @see http://open.weibo.com/wiki/2/place/pois/tips
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  获取地点照片列表
 *
 *  [地点读取接口 ]place/pois/photos
 *  @see http://open.weibo.com/wiki/2/place/pois/photos
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  按省市查询地点
 *
 *  [地点读取接口 ]place/pois/search
 *  @see http://open.weibo.com/wiki/2/place/pois/search
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  获取地点分类
 *
 *  [地点读取接口 ]place/pois/category
 *  @see http://open.weibo.com/wiki/2/place/pois/category
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  获取附近地点
 *
 *  [附近读取接口 ]place/nearby/pois
 *  @see http://open.weibo.com/wiki/2/place/nearby/pois
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  获取附近发位置微博的人
 *
 *  [附近读取接口 ]place/nearby/users
 *  @see http://open.weibo.com/wiki/2/place/nearby/users
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  获取附近照片
 *
 *  [附近读取接口 ]place/nearby/photos
 *  @see http://open.weibo.com/wiki/2/place/nearby/photos
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  获取附近的人
 *
 *  [附近读取接口 ]place/nearby_users/list
 *  @see http://open.weibo.com/wiki/2/place/nearby_users/list
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  添加地点
 *
 *  [地点写入接口 ]place/pois/create
 *  @see http://open.weibo.com/wiki/2/place/pois/create
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  签到
 *
 *  [地点写入接口 ]place/pois/add_checkin
 *  @see http://open.weibo.com/wiki/2/place/pois/add_checkin
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  添加照片
 *
 *  [地点写入接口 ]place/pois/add_photo
 *  @see http://open.weibo.com/wiki/2/place/pois/add_photo
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  添加点评
 *
 *  [地点写入接口 ]place/pois/add_tip
 *  @see http://open.weibo.com/wiki/2/place/pois/add_tip
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  添加todo
 *
 *  [地点写入接口 ]place/pois/add_todo
 *  @see http://open.weibo.com/wiki/2/place/pois/add_todo
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  用户添加自己的位置
 *
 *  [附近写入接口 ]place/nearby_users/create
 *  @see http://open.weibo.com/wiki/2/place/nearby_users/create
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  用户删除自己的位置
 *
 *  [附近写入接口 ]place/nearby_users/destroy
 *  @see http://open.weibo.com/wiki/2/place/nearby_users/destroy
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

//***********************************************
//地理信息
//***********************************************

/**
 *  生成一张静态的地图图片
 *
 *  [基础位置读取接口 ]location/base/get_map_image
 *  @see http://open.weibo.com/wiki/2/location/base/get_map_image
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  根据IP地址返回地理信息坐标
 *
 *  [坐标转换接口 ]location/geo/ip_to_geo
 *  @see http://open.weibo.com/wiki/2/location/geo/ip_to_geo
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  根据实际地址返回地理信息坐标
 *
 *  [坐标转换接口 ]location/geo/address_to_geo
 *  @see http://open.weibo.com/wiki/2/location/geo/address_to_geo
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  根据地理信息坐标返回实际地址
 *
 *  [坐标转换接口 ]location/geo/geo_to_address
 *  @see http://open.weibo.com/wiki/2/location/geo/geo_to_address
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  根据GPS坐标获取偏移后的坐标
 *
 *  [坐标转换接口 ]location/geo/gps_to_offset
 *  @see http://open.weibo.com/wiki/2/location/geo/gps_to_offset
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  判断地理信息坐标是否是国内坐标
 *
 *  [坐标转换接口 ]location/geo/is_domestic
 *  @see http://open.weibo.com/wiki/2/location/geo/is_domestic
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  根据关键词按地址位置获取POI点的信息
 *
 *  [POI数据搜索接口 ]location/pois/search/by_location
 *  @see http://open.weibo.com/wiki/2/location/pois/search/by_location
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  根据关键词按坐标点范围获取POI点的信息
 *
 *  [POI数据搜索接口 ]location/pois/search/by_geo
 *  @see http://open.weibo.com/wiki/2/location/pois/search/by_geo
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  根据关键词按矩形区域获取POI点的信息
 *
 *  [POI数据搜索接口 ]location/pois/search/by_area
 *  @see http://open.weibo.com/wiki/2/location/pois/search/by_area
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  批量获取POI点的信息
 *
 *  [POI数据读写接口 ]location/pois/show_batch
 *  @see http://open.weibo.com/wiki/2/location/pois/show_batch
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  提交一个新增的POI点信息
 *
 *  [POI数据读写接口 ]location/pois/add
 *  @see http://open.weibo.com/wiki/2/location/pois/add
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  根据移动基站WIFI等数据获取当前位置信息
 *
 *  [移动服务读取接口 ]location/mobile/get_location
 *  @see http://open.weibo.com/wiki/2/location/mobile/get_location
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  根据起点与终点数据查询自驾车路线信息
 *
 *  [交通路线读取接口 ]location/line/drive_route
 *  @see http://open.weibo.com/wiki/2/location/line/drive_route
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  根据起点与终点数据查询公交乘坐路线信息
 *
 *  [交通路线读取接口 ]location/line/bus_route
 *  @see http://open.weibo.com/wiki/2/location/line/bus_route
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  根据关键词查询公交线路信息
 *
 *  [交通路线读取接口 ]location/line/bus_line
 *  @see http://open.weibo.com/wiki/2/location/line/bus_line
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  根据关键词查询公交站点信息
 *
 *  [交通路线读取接口 ]location/line/bus_station
 *  @see http://open.weibo.com/wiki/2/location/line/bus_station
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  城市代码对应表
 *
 *  [地理信息字段说明 ]location/citycode
 *  @see http://open.weibo.com/wiki/Location/citycode
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  公交城市代码表
 *
 *  [地理信息字段说明 ]location/citycode_bus
 *  @see http://open.weibo.com/wiki/Location/citycode_bus
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  分类代码对应表
 *
 *  [地理信息字段说明 ]location/category
 *  @see http://open.weibo.com/wiki/Location/category
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  地理位置信息接口错误代码及解释
 *  
 *  [地理信息字段说明 ]location/error2
 *  @see http://open.weibo.com/wiki/Location/error2
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

//***********************************************
//OAuth2（开发指南）
//***********************************************

/**
 *  请求用户授权Token
 *  
 *  [请求授权 ]oauth2/authorize
 *  @see http://open.weibo.com/wiki/Oauth2/authorize
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  获取授权过的Access Token
 *  
 *  [获取授权 ]oauth2/access_token
 *  @see http://open.weibo.com/wiki/OAuth2/access_token
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  查询用户access_token的授权相关信息
 *  
 *  [授权查询 ]oauth2/get_token_info
 *  @see http://open.weibo.com/wiki/Oauth2/get_token_info
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  OAuth1.0的Access Token更换至OAuth2.0的Access Token
 *  
 *  [替换授权 ]oauth2/get_oauth2_token
 *  @see http://open.weibo.com/wiki/index.php?title=Oauth2/get_oauth2_token&action=edit&redlink=1
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

/**
 *  授权回收接口，帮助开发者主动取消用户的授权
 *  
 *  [授权回收 ]OAuth2/revokeoauth2
 *  @see http://open.weibo.com/wiki/Oauth2/revokeoauth2
 *  @param var   附加参数，用于过滤内容，可以为详见「AKVariableParams」。
 *  @param pTask 用户任务信息，此Object将会在Callback中一同返回。详见「AKUserTaskInfo」。

 *  @return 执行结果的代码，详见「AKWeiboResultCode」。
 */

