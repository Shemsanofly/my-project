class RequestLogger
  def initialize(app)
    @app = app
  end

  def call(env)
    started_at = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    status, headers, response = @app.call(env)
    ended_at = Process.clock_gettime(Process::CLOCK_MONOTONIC)

    Rails.logger.info({
      method: env["REQUEST_METHOD"],
      path: env["PATH_INFO"],
      status: status,
      duration_ms: ((ended_at - started_at) * 1000).round(2)
    }.to_json)

    [status, headers, response]
  end
end
