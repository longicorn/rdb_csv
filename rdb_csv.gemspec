lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rdb_csv/version"

Gem::Specification.new do |spec|
  spec.name          = "rdb_csv"
  spec.version       = RdbCSV::VERSION
  spec.authors       = ["longicorn"]
  spec.email         = ["longicorn.c@gmail.com"]

  spec.summary       = %q{RDB dumped csv/tsv can be read and write.}
  spec.description   = %q{Rdbcsv supoorts mainly MySQL and PostgreSQL within reasonable range.}
  spec.homepage      = "https://github.com/longicorn/rdb_csv"
  spec.license       = 'MIT'

  spec.require_paths = ["lib"]
  spec.files         = `git ls-files`.split($/)

  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rake"
end
