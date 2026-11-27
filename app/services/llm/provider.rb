# frozen_string_literal: true

require "json"
require "net/http"
require "uri"

module Llm
  # Thin interface for model calls. Talks to a local Ollama (or compatible) HTTP API.
  class Provider
    Error = Class.new(StandardError)

    DEFAULT_BASE_URL = "http://127.0.0.1:11434"
    DEFAULT_MODEL = "qwen2.5:14b"

    def initialize(base_url: ENV.fetch("ACOM_LLM_BASE_URL", DEFAULT_BASE_URL),
                   model: ENV.fetch("ACOM_LLM_MODEL", DEFAULT_MODEL))
      @base_url = base_url
      @model = model
    end

    def complete(prompt:)
      uri = URI.join(@base_url.end_with?("/") ? @base_url : "#{@base_url}/", "api/generate")
      payload = { model: @model, prompt: prompt, stream: false }

      status, body = post_json(uri, payload)
      unless status.between?(200, 299)
        raise Error, "LLM request failed (#{status}): #{body.to_s.truncate(200)}"
      end

      parsed = JSON.parse(body)
      text = parsed["response"]
      raise Error, "LLM response missing 'response' field" if text.nil?

      text
    rescue Errno::ECONNREFUSED, SocketError, Timeout::Error => e
      raise Error, "LLM unreachable at #{@base_url}: #{e.message}"
    end

    private

    # Returns [status_code Integer, body String]. Stubbed in specs — no WebMock gem.
    def post_json(uri, payload)
      Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https", open_timeout: 5, read_timeout: 300) do |http|
        request = Net::HTTP::Post.new(uri)
        request["Content-Type"] = "application/json"
        request.body = JSON.generate(payload)
        response = http.request(request)
        [ response.code.to_i, response.body.to_s ]
      end
    end
  end
end
