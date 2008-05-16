Gem::Specification.new do |s|
  s.name = %q{einstein}
  s.version = "0.2.0"

  s.specification_version = 2 if s.respond_to? :specification_version=

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Dray Lacy"]
  s.date = %q{2008-05-15}
  s.description = %q{Safe arithmetic parser for Ruby apps}
  s.email = ["dray@izea.com"]
  s.extra_rdoc_files = ["Benchmarks.txt", "History.txt", "License.txt", "Manifest.txt", "README.txt"]
  s.files = ["Benchmarks.txt", "History.txt", "License.txt", "Manifest.txt", "README.txt", "Rakefile", "einstein.gemspec", "lib/einstein.rb", "lib/einstein/evaluator.rb", "lib/einstein/expression.rb", "lib/einstein/parser.racc", "lib/einstein/parser.racc.rb", "lib/einstein/parser.rex", "lib/einstein/parser.rex.rb", "lib/einstein/pretty_printer.rb", "lib/einstein/processor.rb", "lib/einstein/version.rb", "setup.rb", "tasks/benchmark.rake", "test/helper.rb", "test/test_einstein.rb", "test/test_evaluator.rb", "test/test_parser.rb", "test/test_pretty_printer.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/omghax/einstein}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{einstein}
  s.rubygems_version = %q{1.1.1}
  s.summary = %q{Safe arithmetic parser for Ruby apps}
  s.test_files = ["test/test_einstein.rb", "test/test_evaluator.rb", "test/test_parser.rb", "test/test_pretty_printer.rb"]

  s.add_dependency(%q<hoe>, [">= 1.5.1"])
end
