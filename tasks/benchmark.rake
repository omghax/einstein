task :benchmark => :parser do
  require 'benchmark'
  runs = (ENV['RUNS'] || 10_000).to_i

  puts "Benchmarking #{runs} run(s)"
  Benchmark.bm(23) do |b|
    b.report('1') { runs.times { Einstein.evaluate('1') } }
    b.report('2 + 5') { runs.times { Einstein.evaluate('2 + 5') } }
    b.report('x * y') { runs.times { Einstein.evaluate('x * y', :x => 1, :y => 2) } }
    b.report('(x ** 2) / 8 - (y << z)') { runs.times { Einstein.evaluate('(x ** 2) / 8 - (y << z)', :x => 4, :y => 2, :z => 2) } }
  end
end
