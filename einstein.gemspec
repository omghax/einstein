Gem::Specification.new do |s|
  s.name = %q{einstein}
  s.version = "0.2.0"

  s.specification_version = 2 if s.respond_to? :specification_version=

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Dray Lacy"]
  s.date = %q{2008-05-15}
  s.description = %q{Safe arithmetic parser for Ruby apps}
  s.email = ["dray@izea.com"]
  s.extra_rdoc_files = ["History.txt", "License.txt", "Manifest.txt", "README.txt", "website/index.txt"]
  s.files = ["History.txt", "License.txt", "Manifest.txt", "README.txt", "Rakefile", "config/hoe.rb", "config/requirements.rb", "einstein.gemspec", "lib/einstein.rb", "lib/einstein/einstein.racc", "lib/einstein/einstein.racc.rb", "lib/einstein/einstein.rex", "lib/einstein/einstein.rex.rb", "lib/einstein/evaluator.rb", "lib/einstein/expression.rb", "lib/einstein/pretty_printer.rb", "lib/einstein/processor.rb", "lib/einstein/version.rb", "script/destroy", "script/generate", "script/txt2html", "setup.rb", "tasks/benchmark.rake", "tasks/deployment.rake", "tasks/environment.rake", "tasks/website.rake", "test/helper.rb", "test/test_einstein.rb", "test/test_evaluator.rb", "test/test_parser.rb", "test/test_pretty_printer.rb", "website/index.html", "website/index.txt", "website/javascripts/rounded_corners_lite.inc.js", "website/stylesheets/screen.css", "website/template.rhtml"]
  s.has_rdoc = true
  s.homepage = %q{http://einstein.rubyforge.org}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{einstein}
  s.rubygems_version = %q{1.1.1}
  s.summary = %q{Safe arithmetic parser for Ruby apps}
  s.test_files = ["test/test_einstein.rb", "test/test_evaluator.rb", "test/test_parser.rb", "test/test_pretty_printer.rb"]
end
