require 'fileutils'

RSpec.describe "RdbCSV:MySQL" do
  before do
    FileUtils.mkdir_p("tmp")
  end

  after do
    FileUtils.rm_rf("tmp")
  end

  let(:check_rows) {[[1, "abcdefg", "ABCDEFG", 1, 1, "2018-12-12 02:26:06", "2018-12-12 02:26:06", "2018-12-12 02:26:06"],
                     [2, "abcdefg", "あいうえお", 1, 1, "2018-12-12 02:26:06", "2018-12-12 02:26:06", "2018-12-12 02:26:06"],
                     [3, "abc\n\rdefg", "ABC\u0000DEFG", 0, 0, "2018-12-12 02:26:06", "2018-12-12 02:26:06", "2018-12-12 02:26:06"],
                     [4, "abc\tdefg", "ABC,DEFG", nil, -1, "2018-12-12 02:26:06", "2018-12-12 02:26:06", "2018-12-12 02:26:06"],
                     [5, "abc\\defg", "ABC\"DEFG", nil, -1, "2018-12-12 02:26:06", "2018-12-12 02:26:06", "2018-12-12 02:26:06"],
                     [6, "'abcdefg", "ABC'DEFG", nil, -1, "2018-12-12 02:26:06", "2018-12-12 02:26:06", "2018-12-12 02:26:06"],
                     [7, nil, "", nil, nil, "2018-12-12 02:26:06", "2018-12-12 02:26:06", "2018-12-12 02:26:06"]
                    ]}

  describe "MySQL data, non-encoding" do
    describe "Read csv" do
      it "open" do
        read_rows = []
        path = "spec/fixtures/mysql.csv"

        RdbCSV.open(path, db: :mysql, delimiter: ",") do |csv|
          csv.each do |row|
            read_rows << row
          end
        end

        expect(read_rows).to eq check_rows
      end

      it "foreach" do
        read_rows = []
        path = "spec/fixtures/mysql.csv"

        RdbCSV.foreach(path, db: :mysql, delimiter: ",") do |row|
          read_rows << row
        end

        expect(read_rows).to eq check_rows
      end
    end

    describe "Read tsv" do
      it "open" do
        read_rows = []
        path = "spec/fixtures/mysql.tsv"

        RdbCSV.open(path, db: :mysql, delimiter: "\t") do |tsv|
          tsv.each do |row|
            read_rows << row
          end
        end

        expect(read_rows).to eq check_rows
      end

      it "foreach" do
        read_rows = []
        path = "spec/fixtures/mysql.tsv"

        RdbCSV.foreach(path, db: :mysql, delimiter: "\t") do |row|
          read_rows << row
        end

        expect(read_rows).to eq check_rows
      end
    end

    it "Write csv" do
      read_rows = []
      path = "tmp/mysql.csv"

      RdbCSV.open(path, 'w', db: :mysql, delimiter: ",") do |csv|
        check_rows.each do |row|
          csv << row
        end
      end

      RdbCSV.open(path, db: :mysql, delimiter: ",") do |csv|
        csv.each do |row|
          read_rows << row
        end
      end

      expect(read_rows).to eq check_rows
    end

    it "Write tsv" do
      read_rows = []
      path = "tmp/mysql.tsv"

      RdbCSV.open(path, 'w', db: :mysql, delimiter: "\t") do |tsv|
        check_rows.each do |row|
          tsv << row
        end
      end

      RdbCSV.open(path, db: :mysql, delimiter: "\t") do |tsv|
        tsv.each do |row|
          read_rows << row
        end
      end

      expect(read_rows).to eq check_rows
    end
  end

  describe "MySQL data, encoding:UTF-8" do
    describe "Read csv" do
      it "open" do
        read_rows = []
        path = "spec/fixtures/mysql.csv"

        RdbCSV.open(path, db: :mysql, delimiter: ",", encoding: 'UTF-8') do |csv|
          csv.each do |row|
            read_rows << row
          end
        end

        expect(read_rows).to eq check_rows
      end

      it "foreach" do
        read_rows = []
        path = "spec/fixtures/mysql.csv"

        RdbCSV.foreach(path, db: :mysql, delimiter: ",", encoding: 'UTF-8') do |row|
          read_rows << row
        end

        expect(read_rows).to eq check_rows
      end
    end

    describe "Read tsv" do
      it "open" do
        read_rows = []
        path = "spec/fixtures/mysql.tsv"

        RdbCSV.open(path, db: :mysql, delimiter: "\t", encoding: 'UTF-8') do |tsv|
          tsv.each do |row|
            read_rows << row
          end
        end

        expect(read_rows).to eq check_rows
      end

      it "foreach" do
        read_rows = []
        path = "spec/fixtures/mysql.tsv"

        RdbCSV.foreach(path, db: :mysql, delimiter: "\t", encoding: 'UTF-8') do |row|
          read_rows << row
        end

        expect(read_rows).to eq check_rows
      end
    end

    it "Write csv" do
      read_rows = []
      path = "tmp/mysql.csv"

      RdbCSV.open(path, 'w', db: :mysql, delimiter: ",", encoding: 'UTF-8') do |csv|
        check_rows.each do |row|
          csv << row
        end
      end

      RdbCSV.open(path, db: :mysql, delimiter: ",", encoding: 'UTF-8') do |csv|
        csv.each do |row|
          read_rows << row
        end
      end

      expect(read_rows).to eq check_rows
    end

    it "Write tsv" do
      read_rows = []
      path = "tmp/mysql.tsv"

      RdbCSV.open(path, 'w', db: :mysql, delimiter: "\t", encoding: 'UTF-8') do |tsv|
        check_rows.each do |row|
          tsv << row
        end
      end

      RdbCSV.open(path, db: :mysql, delimiter: "\t", encoding: 'UTF-8') do |tsv|
        tsv.each do |row|
          read_rows << row
        end
      end

      expect(read_rows).to eq check_rows
    end
  end

  describe "MySQL data, encoding:EUC-JP" do
    describe "Read csv" do
      it "open" do
        read_rows = []
        path = "spec/fixtures/mysql.euc.csv"

        RdbCSV.open(path, db: :mysql, delimiter: ",", encoding: 'EUC-JP:UTF-8') do |csv|
          csv.each do |row|
            read_rows << row
          end
        end

        expect(read_rows).to eq check_rows
      end

      it "foreach" do
        read_rows = []
        path = "spec/fixtures/mysql.euc.csv"

        RdbCSV.foreach(path, db: :mysql, delimiter: ",", encoding: 'EUC-JP:UTF-8') do |row|
          read_rows << row
        end

        expect(read_rows).to eq check_rows
      end
    end

    describe "Read tsv" do
      it "open" do
        read_rows = []
        path = "spec/fixtures/mysql.euc.tsv"

        RdbCSV.open(path, db: :mysql, delimiter: "\t", encoding: 'EUC-JP:UTF-8') do |tsv|
          tsv.each do |row|
            read_rows << row
          end
        end

        expect(read_rows).to eq check_rows
      end

      it "foreach" do
        read_rows = []
        path = "spec/fixtures/mysql.euc.tsv"

        RdbCSV.foreach(path, db: :mysql, delimiter: "\t", encoding: 'EUC-JP:UTF-8') do |row|
          read_rows << row
        end

        expect(read_rows).to eq check_rows
      end
    end

    it "Write csv" do
      read_rows = []
      path = "tmp/mysql.euc.csv"

      RdbCSV.open(path, 'w', db: :mysql, delimiter: ",", encoding: 'EUC-JP') do |csv|
        check_rows.each do |row|
          csv << row
        end
      end

      RdbCSV.open(path, db: :mysql, delimiter: ",", encoding: 'EUC-JP:UTF-8') do |csv|
        csv.each do |row|
          read_rows << row
        end
      end

      expect(read_rows).to eq check_rows
    end

    it "Write tsv" do
      read_rows = []
      path = "tmp/mysql.euc.tsv"

      RdbCSV.open(path, 'w', db: :mysql, delimiter: "\t", encoding: 'EUC-JP') do |tsv|
        check_rows.each do |row|
          tsv << row
        end
      end

      RdbCSV.open(path, db: :mysql, delimiter: "\t", encoding: 'EUC-JP:UTF-8') do |tsv|
        tsv.each do |row|
          read_rows << row
        end
      end

      expect(read_rows).to eq check_rows
    end
  end
end
