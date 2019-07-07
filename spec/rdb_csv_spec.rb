require 'fileutils'
require 'csv'

RSpec.describe RdbCSV do
  before do
    FileUtils.mkdir_p("tmp")
  end

  after do
    FileUtils.rm_rf("tmp")
  end

  it "Check version number" do
    expect(RdbCSV::VERSION).to eq "0.1.2"
  end
end
