# frozen_string_literal: true
namespace :ridgepole do
  SCHEMA_FILE = 'db/schemas/Schemafile'

  desc 'Execute ridgepole apply command'
  task apply: :environment do
    exec("bundle exec ridgepole -c config.yml --apply -f #{SCHEMA_FILE}")
  end

  desc 'Execute ridgepole export command'
  task export: :environment do
    exec("bundle exec ridgepole -c config.yml --export --split -o #{SCHEMA_FILE}")
  end
end
