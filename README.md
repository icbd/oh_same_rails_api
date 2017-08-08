# Oh-Same API powered by Rails 5.1.2


## 全局状态码

failed code | description
---|---
0| 成功
2| 身份验证失败
3| 参数错误

## Redis 结构

key | value | description | type
---|---|---
"str#auth_token:#{token}"| 用户ID | 验证login_token是否有效 | string