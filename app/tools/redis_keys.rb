module RedisKeys

  def redisKey(key, *args)
    case key
      when :auth_token #(key, token)
        token = args[0]
        "str_auth_token:#{token}"
      when :channel #(key, channelID)
        channelID = args[0]
        "hash_channel:#{channelID}"
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