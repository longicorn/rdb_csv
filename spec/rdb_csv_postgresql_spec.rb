require 'fileutils'

RSpec.describe "RdbCSV:MySQL" do
  before do
    FileUtils.mkdir_p("tmp")
  end

  after do
    FileUtils.rm_rf("tmp")
  end

  let(:check_rows) {[["id", "text0", "text1", "flag", "point", "inserted_at", "created_at", "updated_at"],
                     [1, "abcdefg", "ABCDEFG", "t", 1, "2018-12-18 04:18:24.181256",
                      "2018-12-18 04:18:24.18319", "2018-12-18 04:18:24.18319"],
                     [2, "abcdefg", "あいうえお", "t", 1, "2018-12-18 04:18:24.181256",
                      "2018-12-18 04:18:24.18319", "2018-12-18 04:18:24.18319"],
                     [3, "abc\n\rdefg", "ABC\u0000DEFG", "f", 0,
                      "2018-12-18 04:18:24.19734", "2018-12-18 04:18:24.198651", "2018-12-18 04:18:24.198651"],
                     [4, "abc\tdefg", "ABC,DEFG", nil, -1,
                      "2018-12-18 04:18:24.202638", "2018-12-18 04:18:24.203768", "2018-12-18 04:18:24.203768"],
                     [5, "abc\\defg", "ABC\"DEFG", nil, -1,
                      "2018-12-18 04:18:24.207705", "2018-12-18 04:18:24.20904", "2018-12-18 04:18:24.20904"],
                     [6, "'abcdefg", "ABC'DEFG", nil, -1,
                      "2018-12-18 04:18:24.207705", "2018-12-18 04:18:24.20904", "2018-12-18 04:18:24.20904"],
                     [7, nil, "", nil, nil,
                      "2018-12-18 04:18:24.213643", "2018-12-18 04:18:24.215238", "2018-12-18 04:18:24.215238"]
                    ]}

  describe "PostgreSQL data" do
    describe "Read csv" do
      it "open" do
        read_rows = []
        path = "spec/fixtures/postgresql.csv"

        RdbCSV.open(path, db: :postgresql, delimiter: ",") do |csv|
          csv.each do |row|
            read_rows << row
          end
        end

        expect(read_rows).to eq check_rows
      end

      it "foreach" do
        read_rows = []
        path = "spec/fixtures/postgresql.csv"

        RdbCSV.foreach(path, db: :postgresql, delimiter: ",") do |row|
          read_rows << row
        end

        expect(read_rows).to eq check_rows
      end
    end

    describe "Read tsv" do
      it "open" do
        read_rows = []
        path = "spec/fixtures/postgresql.tsv"
          RdbCSV.open(path, db: :postgresql, delimiter: "\t") do |tsv|
          tsv.each do |row|
            read_rows << row
          end
        end

        expect(read_rows).to eq check_rows
      end

      it "foreach" do
        read_rows = []
        path = "spec/fixtures/postgresql.tsv"
        RdbCSV.foreach(path, db: :postgresql, delimiter: "\t") do |row|
          read_rows << row
        end

        expect(read_rows).to eq check_rows
      end
    end

    it "Write csv" do
      read_rows = []
      path = "tmp/postgresql.csv"

      RdbCSV.open(path, 'w', db: :postgresql, delimiter: ",") do |csv|
        check_rows.each do |row|
          csv << row
        end
      end

      RdbCSV.open(path, db: :postgresql, delimiter: ",") do |csv|
        csv.each do |row|
          read_rows << row
        end
      end

      expect(read_rows).to eq check_rows
    end

    it "Write tsv" do
      read_rows = []
      path = "tmp/postgresql.tsv"

      RdbCSV.open(path, 'w', db: :postgresql, delimiter: ",") do |tsv|
        check_rows.each do |row|
          tsv << row
        end
      end

      RdbCSV.open(path, db: :postgresql, delimiter: ",") do |tsv|
        tsv.each do |row|
          read_rows << row
        end
      end

      expect(read_rows).to eq check_rows
    end
  end

  describe "PostgreSQL data, encoding:UTF-8" do
    describe "Read csv" do
      it "open" do
        read_rows = []
        path = "spec/fixtures/postgresql.csv"

        RdbCSV.open(path, db: :postgresql, delimiter: ",", encoding: 'UTF-8') do |csv|
          csv.each do |row|
            read_rows << row
          end
        end

        expect(read_rows).to eq check_rows
      end

      it "foreach" do
        read_rows = []
        path = "spec/fixtures/postgresql.csv"

        RdbCSV.foreach(path, db: :postgresql, delimiter: ",", encoding: 'UTF-8') do |row|
          read_rows << row
        end

        expect(read_rows).to eq check_rows
      end
    end

    describe "Read tsv" do
      it "open" do
        read_rows = []
        path = "spec/fixtures/postgresql.tsv"
          RdbCSV.open(path, db: :postgresql, delimiter: "\t", encoding: 'UTF-8') do |tsv|
          tsv.each do |row|
            read_rows << row
          end
        end

        expect(read_rows).to eq check_rows
      end

      it "foreach" do
        read_rows = []
        path = "spec/fixtures/postgresql.tsv"
        RdbCSV.foreach(path, db: :postgresql, delimiter: "\t", encoding: 'UTF-8') do |row|
          read_rows << row
        end

        expect(read_rows).to eq check_rows
      end
    end

    it "Write csv" do
      read_rows = []
      path = "tmp/postgresql.csv"

      RdbCSV.open(path, 'w', db: :postgresql, delimiter: ",", encoding: 'UTF-8') do |csv|
        check_rows.each do |row|
          csv << row
        end
      end

      RdbCSV.open(path, db: :postgresql, delimiter: ",", encoding: 'UTF-8') do |csv|
        csv.each do |row|
          read_rows << row
        end
      end

      expect(read_rows).to eq check_rows
    end

    it "Write tsv" do
      read_rows = []
      path = "tmp/postgresql.tsv"

      RdbCSV.open(path, 'w', db: :postgresql, delimiter: ",", encoding: 'UTF-8') do |tsv|
        check_rows.each do |row|
          tsv << row
        end
      end

      RdbCSV.open(path, db: :postgresql, delimiter: ",", encoding: 'UTF-8') do |tsv|
        tsv.each do |row|
          read_rows << row
        end
      end

      expect(read_rows).to eq check_rows
    end
  end

  describe "PostgreSQL data, encoding:EUC-JP" do
    describe "Read csv" do
      it "open" do
        read_rows = []
        path = "spec/fixtures/postgresql.euc.csv"

        RdbCSV.open(path, db: :postgresql, delimiter: ",", encoding: 'EUC-JP:UTF-8') do |csv|
          csv.each do |row|
            read_rows << row
          end
        end

        expect(read_rows).to eq check_rows
      end

      it "foreach" do
        read_rows = []
        path = "spec/fixtures/postgresql.euc.csv"

        RdbCSV.foreach(path, db: :postgresql, delimiter: ",", encoding: 'EUC-JP:UTF-8') do |row|
          read_rows << row
        end

        expect(read_rows).to eq check_rows
      end
    end

    describe "Read tsv" do
      it "open" do
        read_rows = []
        path = "spec/fixtures/postgresql.euc.tsv"
          RdbCSV.open(path, db: :postgresql, delimiter: "\t", encoding: 'EUC-JP:UTF-8') do |tsv|
          tsv.each do |row|
            read_rows << row
          end
        end

        expect(read_rows).to eq check_rows
      end

      it "foreach" do
        read_rows = []
        path = "spec/fixtures/postgresql.euc.tsv"
        RdbCSV.foreach(path, db: :postgresql, delimiter: "\t", encoding: 'EUC-JP:UTF-8') do |row|
          read_rows << row
        end

        expect(read_rows).to eq check_rows
      end
    end

    it "Write csv" do
      read_rows = []
      path = "tmp/postgresql.euc.csv"

      RdbCSV.open(path, 'w', db: :postgresql, delimiter: ",", encoding: 'EUC-JP') do |csv|
        check_rows.each do |row|
          csv << row
        end
      end

      RdbCSV.open(path, db: :postgresql, delimiter: ",", encoding: 'EUC-JP:UTF-8') do |csv|
        csv.each do |row|
          read_rows << row
        end
      end

      expect(read_rows).to eq check_rows
    end

    it "Write tsv" do
      read_rows = []
      path = "tmp/postgresql.euc.tsv"

      RdbCSV.open(path, 'w', db: :postgresql, delimiter: ",", encoding: 'EUC-JP') do |tsv|
        check_rows.each do |row|
          tsv << row
        end
      end

      RdbCSV.open(path, db: :postgresql, delimiter: ",", encoding: 'EUC-JP:UTF-8') do |tsv|
        tsv.each do |row|
          read_rows << row
        end
      end

      expect(read_rows).to eq check_rows
    end
  end
end
