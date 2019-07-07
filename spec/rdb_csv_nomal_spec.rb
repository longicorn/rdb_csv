require 'fileutils'
require 'csv'

RSpec.describe "RdbCSV:nomal" do
  before do
    FileUtils.mkdir_p("tmp")
  end

  after do
    FileUtils.rm_rf("tmp")
  end

  let(:check_rows) {[["abcdefg","hijkmnl","opqrstu","vwxyz"],
                     ["あいうえお","かきくけこ","さしすせそ","たちつてと"],
                     ["あいうえお\nかきくけこ","さしすせそ","たちつてと"]
                    ]}

  describe "normal data, non-encoding" do
    describe "Read csv" do
      it "open" do
        read_rows = []
        path = "spec/fixtures/normal.csv"

        RdbCSV.open(path, delimiter: ",") do |csv|
          csv.each do |row|
            read_rows << row
          end
        end

        expect(read_rows).to eq check_rows
      end

      it "foreach" do
        read_rows = []
        path = "spec/fixtures/normal.csv"

        RdbCSV.foreach(path, delimiter: ",") do |row|
          read_rows << row
        end

        expect(read_rows).to eq check_rows
      end
    end

    describe "Read tsv" do
      it "open" do
        read_rows = []
        path = "spec/fixtures/normal.tsv"

        RdbCSV.open(path, delimiter: "\t") do |tsv|
          tsv.each do |row|
            read_rows << row
          end
        end

        expect(read_rows).to eq check_rows
      end

      it "foreach" do
        read_rows = []
        path = "spec/fixtures/normal.tsv"

        RdbCSV.foreach(path, delimiter: "\t") do |row|
          read_rows << row
        end

        expect(read_rows).to eq check_rows
      end
    end

    it "Write csv" do
      read_rows = []
      path = "tmp/normal.csv"

      RdbCSV.open(path, 'w', delimiter: ",") do |csv|
        check_rows.each do |row|
          csv << row
        end
      end

      RdbCSV.open(path, delimiter: ",") do |csv|
        csv.each do |row|
          read_rows << row
        end
      end

      expect(read_rows).to eq check_rows
    end

    it "Write tsv" do
      read_rows = []
      path = "tmp/normal.tsv"

      RdbCSV.open(path, 'w', delimiter: "\t") do |csv|
        check_rows.each do |row|
          csv << row
        end
      end

      RdbCSV.open(path, delimiter: "\t") do |csv|
        csv.each do |row|
          read_rows << row
        end
      end

      expect(read_rows).to eq check_rows
    end
  end

  describe "normal data, encoding:UTF-8" do
    describe "Read csv" do
      it "open" do
        read_rows = []
        path = "spec/fixtures/normal.csv"

        RdbCSV.open(path, delimiter: ",", encoding: 'UTF-8') do |csv|
          csv.each do |row|
            read_rows << row
          end
        end

        expect(read_rows).to eq check_rows
      end

      it "foreach" do
        read_rows = []
        path = "spec/fixtures/normal.csv"

        RdbCSV.foreach(path, delimiter: ",", encoding: 'UTF-8') do |row|
          read_rows << row
        end

        expect(read_rows).to eq check_rows
      end
    end

    describe "Read tsv" do
      it "open" do
        read_rows = []
        path = "spec/fixtures/normal.tsv"

        RdbCSV.open(path, delimiter: "\t", encoding: 'UTF-8') do |tsv|
          tsv.each do |row|
            read_rows << row
          end
        end

        expect(read_rows).to eq check_rows
      end

      it "foreach" do
        read_rows = []
        path = "spec/fixtures/normal.tsv"

        RdbCSV.foreach(path, delimiter: "\t", encoding: 'UTF-8') do |row|
          read_rows << row
        end

        expect(read_rows).to eq check_rows
      end
    end

    it "Write csv" do
      read_rows = []
      path = "tmp/normal.csv"

      RdbCSV.open(path, 'w', delimiter: ",", encoding: 'UTF-8') do |csv|
        check_rows.each do |row|
          csv << row
        end
      end

      RdbCSV.open(path, delimiter: ",", encoding: 'UTF-8') do |csv|
        csv.each do |row|
          read_rows << row
        end
      end

      expect(read_rows).to eq check_rows
    end

    it "Write tsv" do
      read_rows = []
      path = "tmp/normal.tsv"

      RdbCSV.open(path, 'w', delimiter: "\t", encoding: 'UTF-8') do |csv|
        check_rows.each do |row|
          csv << row
        end
      end

      RdbCSV.open(path, delimiter: "\t") do |csv|
        csv.each do |row|
          read_rows << row
        end
      end

      expect(read_rows).to eq check_rows
    end
  end

  describe "normal data, encoding:EUC-JP" do
    describe "Read csv" do
      it "open" do
        read_rows = []
        path = "spec/fixtures/normal.euc.csv"

        RdbCSV.open(path, delimiter: ",", encoding: 'EUC-JP:UTF-8') do |csv|
          csv.each do |row|
            read_rows << row
          end
        end

        expect(read_rows).to eq check_rows
      end

      it "foreach" do
        read_rows = []
        path = "spec/fixtures/normal.euc.csv"

        RdbCSV.foreach(path, delimiter: ",", encoding: 'EUC-JP:UTF-8') do |row|
          read_rows << row
        end

        expect(read_rows).to eq check_rows
      end
    end

    describe "Read tsv" do
      it "open" do
        read_rows = []
        path = "spec/fixtures/normal.euc.tsv"

        RdbCSV.open(path, delimiter: "\t", encoding: 'EUC-JP:UTF-8') do |tsv|
          tsv.each do |row|
            read_rows << row
          end
        end

        expect(read_rows).to eq check_rows
      end

      it "foreach" do
        read_rows = []
        path = "spec/fixtures/normal.euc.tsv"

        RdbCSV.foreach(path, delimiter: "\t", encoding: 'EUC-JP:UTF-8') do |row|
          read_rows << row
        end

        expect(read_rows).to eq check_rows
      end
    end

    it "Write csv" do
      read_rows = []
      path = "tmp/normal.euc.csv"

      RdbCSV.open(path, 'w', delimiter: ",", encoding: 'EUC-JP:UTF-8') do |csv|
        check_rows.each do |row|
          csv << row
        end
      end

      RdbCSV.open(path, delimiter: ",", encoding: 'EUC-JP:UTF-8') do |csv|
        csv.each do |row|
          read_rows << row
        end
      end

      expect(read_rows).to eq check_rows
    end

    it "Write tsv" do
      read_rows = []
      path = "tmp/normal.euc.tsv"

      RdbCSV.open(path, 'w', delimiter: "\t", encoding: 'EUC-JP:UTF-8') do |csv|
        check_rows.each do |row|
          csv << row
        end
      end

      RdbCSV.open(path, delimiter: "\t", encoding: 'EUC-JP:UTF-8') do |csv|
        csv.each do |row|
          read_rows << row
        end
      end

      expect(read_rows).to eq check_rows
    end
  end
end
