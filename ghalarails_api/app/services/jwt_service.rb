class JwtService
  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, secret)
  end

  def self.decode(token)
    decoded = JWT.decode(token, secret)[0]
    HashWithIndifferentAccess.new(decoded)
  end

  def self.secret
    ENV.fetch("JWT_SECRET")
  end
end
