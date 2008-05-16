require 'rubygems'
require 'hoe'
require './lib/einstein.rb'

# Load all tasks from /tasks.
Dir['tasks/**/*.rake'].each { |rake| load rake }

Hoe.new('einstein', Einstein::VERSION::STRING) do |p|
  p.developer 'Dray Lacy', 'dray@izea.com'
  p.description = p.summary = 'Safe arithmetic parser for Ruby apps'
  p.url = 'http://github.com/omghax/einstein'
  p.test_globs = ['test/**/test_*.rb']
  p.changes = p.paragraphs_of('History.txt', 0..1).join("\n\n")
end

GENERATED_PARSER = 'lib/einstein/parser.racc.rb'
GENERATED_LEXER = 'lib/einstein/parser.rex.rb'

file GENERATED_LEXER => 'lib/einstein/parser.rex' do |t|
  sh "rex -o #{t.name} #{t.prerequisites.first}"
end

file GENERATED_PARSER => 'lib/einstein/parser.racc' do |t|
  sh "racc -o #{t.name} #{t.prerequisites.first}"
end

task :parser => [GENERATED_LEXER, GENERATED_PARSER]

# Make sure the parser's up-to-date when we test.
Rake::Task["test"].prerequisites << :parser

# Make sure the generated parser gets included in the manifest.
Rake::Task["check_manifest"].prerequisites << :parser
