# Oh-Same API powered by Rails 5.1.2


## 全局状态码

failed code | description
---|---
0| 成功
2| 身份验证失败
3| 参数错误
4| 条件错误
5| 系统错误

## Redis 结构

key | value | description | type
---|---|---|---
"str_auth_token:#{token}" | 用户ID | 验证login_token是否有效 | string
"hash_channel:#{channelID}" | 频道信息 | 频道基本信息缓存 | hash


## 附件类型

channels table

频道种类说明|channel_type|attatch_type
---|---|---
图文|0|string
文字|1|string
语音|2|string
音乐|3|quote-1
电影|4|quote-1
打卡|5|sign-2
视频|6|string
投票|7|vote-3

每个帖子只能发一个附件, 任意帖子都可以加文字(content字段).

