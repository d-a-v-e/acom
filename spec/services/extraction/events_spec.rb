# frozen_string_literal: true

require "rails_helper"

RSpec.describe Extraction::Events do
  describe "#call" do
    it "interpolates the prompt and returns the provider response" do
      provider = instance_double(Llm::Provider)
      written_on = "2026-11-27"
      body = "Went to the pub."

      expect(provider).to receive(:complete) do |prompt:|
        expect(prompt).to include(written_on)
        expect(prompt).to include(body)
        expect(prompt).not_to include("{{written_on}}")
        expect(prompt).not_to include("{{body}}")
        '{"events":[]}'
      end

      result = described_class.new(provider: provider).call(written_on: written_on, body: body)

      expect(result).to eq('{"events":[]}')
    end
  end
end
