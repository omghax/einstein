require 'config/requirements'
require 'config/hoe' # setup Hoe + all gem configuration

Dir['tasks/**/*.rake'].each { |rake| load rake }

GENERATED_PARSER = "lib/einstein/generated_parser.rb"

file GENERATED_PARSER => "lib/parser.y" do |t|
  if ENV['DEBUG']
    sh "racc -g -v -o #{t.name} #{t.prerequisites.first}"
  else
    sh "racc -o #{t.name} #{t.prerequisites.first}"
  end
end

task :parser => GENERATED_PARSER

# make sure the parser's up-to-date when we test
Rake::Task[:test].prerequisites << :parser
Rake::Task[:check_manifest].prerequisites << :parser
