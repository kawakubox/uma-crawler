# frozen_string_literal: true
namespace :ridgepole do
  SCHEMA_FILE = 'db/schemas/Schemafile'
  CONFIG_FILE = 'config/database.yml'

  desc 'Execute ridgepole apply command'
  task apply: :environment do
    exec("bundle exec ridgepole -c #{CONFIG_FILE} --apply -f #{SCHEMA_FILE}")
  end

  desc 'Execute ridgepole export command'
  task export: :environment do
    exec("bundle exec ridgepole -c #{CONFIG_FILE} --export --split -o #{SCHEMA_FILE}")
  end
end
