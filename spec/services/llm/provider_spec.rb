# frozen_string_literal: true

require "rails_helper"

RSpec.describe Llm::Provider do
  describe "#complete" do
    it "POSTs to /api/generate and returns the response text" do
      provider = described_class.new
      allow(provider).to receive(:post_json) do |uri, payload|
        expect(uri.to_s).to eq("http://127.0.0.1:11434/api/generate")
        expect(payload).to eq(model: "qwen2.5:14b", prompt: "hello", stream: false)
        [ 200, { "response" => '{"events":[]}', "done" => true }.to_json ]
      end

      expect(provider.complete(prompt: "hello")).to eq('{"events":[]}')
    end

    it "raises when the server is unreachable" do
      provider = described_class.new
      allow(provider).to receive(:post_json).and_raise(Errno::ECONNREFUSED.new("Connection refused"))

      expect {
        provider.complete(prompt: "hello")
      }.to raise_error(Llm::Provider::Error, /unreachable/)
    end

    it "raises on a non-success HTTP status" do
      provider = described_class.new
      allow(provider).to receive(:post_json).and_return([ 500, "boom" ])

      expect {
        provider.complete(prompt: "hello")
      }.to raise_error(Llm::Provider::Error, /failed \(500\)/)
    end
  end
end
