module RedisKeys

  def redisKey(key, *args)
    case key
      when "auth_token"
        token = args[0]
        "str_auth_token:#{token}"
      else
        ""
    end
  end


  # 获取一个redis实例
  def redis(host: "localhost", port: "6379", db: 0)
    require 'redis'
    redis = Redis.new(host: host, port: port, db: db)
  end
end