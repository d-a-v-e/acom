# frozen_string_literal: true

module Extraction
  # Builds the extract-events prompt and calls the LLM provider.
  # Returns the raw response string — no parse or schema check yet.
  class Events
    PROMPT_PATH = Rails.root.join("config/prompts/extract_events.md")

    def initialize(provider: Llm::Provider.new)
      @provider = provider
    end

    def call(written_on:, body:)
      prompt = render_prompt(written_on: written_on, body: body)
      @provider.complete(prompt: prompt)
    end

    private

    def render_prompt(written_on:, body:)
      PROMPT_PATH.read
        .gsub("{{written_on}}", written_on.to_s)
        .gsub("{{body}}", body.to_s)
    end
  end
end
