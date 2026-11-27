# frozen_string_literal: true

module Llm
  # Thin interface for model calls. Plug in local inference (or an API) here later.
  class Provider
    def complete(prompt:)
      raise NotImplementedError,
            "Llm::Provider#complete is not wired yet — add local inference (or an API client) here."
    end
  end
end
