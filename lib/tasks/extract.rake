# frozen_string_literal: true

namespace :extract do
  desc "Extract events from a synthetic fixture (default: entry_001)"
  task :events, [ :fixture_id ] => :environment do |_task, args|
    fixture_id = args[:fixture_id].presence || "entry_001"
    path = Rails.root.join("spec/fixtures/evals/#{fixture_id}.yml")

    abort "Fixture not found: #{path}" unless path.exist?

    data = YAML.safe_load_file(path, permitted_classes: [ Date ], aliases: true)
    written_on = data.fetch("written_on")
    body = data.fetch("body")

    puts Extraction::Events.new.call(written_on: written_on, body: body)
  rescue NotImplementedError => e
    abort e.message
  end
end
