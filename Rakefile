require 'config/requirements'
require 'config/hoe' # setup Hoe + all gem configuration

Dir['tasks/**/*.rake'].each { |rake| load rake }

GENERATED_PARSER = 'lib/einstein/einstein.racc.rb'
GENERATED_LEXER = 'lib/einstein/einstein.rex.rb'

file GENERATED_LEXER => 'lib/einstein/einstein.rex' do |t|
  sh "rex -o #{t.name} #{t.prerequisites.first}"
end

file GENERATED_PARSER => 'lib/einstein/einstein.racc' do |t|
  sh "racc -o #{t.name} #{t.prerequisites.first}"
end

task :parser => [GENERATED_LEXER, GENERATED_PARSER]

# Make sure the parser's up-to-date when we test.
Rake::Task["test"].prerequisites << :parser

# Make sure the generated parser gets included in the manifest.
Rake::Task["check_manifest"].prerequisites << :parser
