require "../src/calm"
require "../src/db/migration/*"
require "../src/db/migrations/*"
require "../src/settings/settings"
# require "../src/conf/settings"
require "../src/cli/commands/*"
# require "../src/cli/commands/db/*"

# require "../src/db/orm/base"
require "../src/i18n/*"
# require "../src/http/middleware"

# Calm::Commands::Db.new(OptionParser.parse(args: ["db", "migrate"]) { }, Dir.current).run_migrations

require "spec"

# Spec.around_each do |spec|
#  DB.open Calm.settings.database_url do |db|
#    # TODO: schema
#    db.query "DO $$ DECLARE r RECORD; BEGIN FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = current_schema() AND tablename <> 'calmconfig') LOOP EXECUTE 'TRUNCATE TABLE ' || quote_ident(r.tablename) || ' CASCADE'; END LOOP; END $$;" do
#      spec.run
#    end
#  end
# end
