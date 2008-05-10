task :benchmark => :parser do
  require 'benchmark'
  runs = (ENV['RUNS'] || 10_000).to_i

  puts "Benchmarking #{runs} run(s) of Einstein.parse"
  Benchmark.bm(23) do |b|
    b.report('1') { runs.times { Einstein.parse('1') } }
    b.report('2 + 5') { runs.times { Einstein.parse('2 + 5') } }
    b.report('x * y') { runs.times { Einstein.parse('x * y') } }
    b.report('(x ** 2) / 8 - (y << z)') { runs.times { Einstein.parse('(x ** 2) / 8 - (y << z)') } }
  end

  puts "Benchmarking #{runs} run(s) of Einstein.evaluate"
  Benchmark.bm(23) do |b|
    b.report('1') { runs.times { Einstein.evaluate('1') } }
    b.report('2 + 5') { runs.times { Einstein.evaluate('2 + 5') } }
    b.report('x * y') { runs.times { Einstein.evaluate('x * y', :x => 1, :y => 2) } }
    b.report('(x ** 2) / 8 - (y << z)') { runs.times { Einstein.evaluate('(x ** 2) / 8 - (y << z)', :x => 4, :y => 2, :z => 2) } }
  end

  puts "Benchmarking #{runs} run(s) of evaluate on a pre-parsed expression"
  Benchmark.bm(23) do |b|
    b.report('1') { e = Einstein.parse('1'); runs.times { e.evaluate } }
    b.report('2 + 5') { e = Einstein.parse('2 + 5'); runs.times { e.evaluate } }
    b.report('x * y') { e = Einstein.parse('x * y'); runs.times { e.evaluate(:x => 1, :y => 2) } }
    b.report('(x ** 2) / 8 - (y << z)') { e = Einstein.parse('(x ** 2) / 8 - (y << z)'); runs.times { e.evaluate(:x => 4, :y => 2, :z => 2) } }
  end
end
