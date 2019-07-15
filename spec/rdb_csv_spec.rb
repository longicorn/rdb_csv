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
    expect(RdbCSV::VERSION).to eq "0.2.0"
  end

  describe "normal data" do
    let(:check_rows) {[["abcdefg","hijkmnl","opqrstu","vwxyz"],
                       ["あいうえお","かきくけこ","さしすせそ","たちつてと"],
                       ["あいうえお\nかきくけこ","さしすせそ","たちつてと"]
                      ]}

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

    it "Write csv" do
      read_rows = []
      path = "tmp/normal.csv"

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

  describe "MySQL data" do
    let(:check_rows) {[[1, "abcdefg", "ABCNDEFG", 1, 1, "2018-12-12 02:26:06", "2018-12-12 02:26:06", "2018-12-12 02:26:06"],
                       [2, "abc\n\rdefg", "ABC\u0000DEFG", 0, 0, "2018-12-12 02:26:06", "2018-12-12 02:26:06", "2018-12-12 02:26:06"],
                       [3, "abc\tdefg", "ABC,DEFG", nil, -1, "2018-12-12 02:26:06", "2018-12-12 02:26:06", "2018-12-12 02:26:06"],
                       [4, "abc\\defg", "ABC\"DEFG", nil, -1, "2018-12-12 02:26:06", "2018-12-12 02:26:06", "2018-12-12 02:26:06"],
                       [5, "'abcdefg", "ABC'DEFG", nil, -1, "2018-12-12 02:26:06", "2018-12-12 02:26:06", "2018-12-12 02:26:06"],
                       [6, nil, "", nil, nil, "2018-12-12 02:26:06", "2018-12-12 02:26:06", "2018-12-12 02:26:06"]
                      ]}

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

  describe "PostgreSQL data" do
    let(:check_rows) {[["id", "text0", "text1", "flag", "point", "inserted_at", "created_at", "updated_at"],
                       [1, "abcdefg", "ABCNDEFG", "t", 1, "2018-12-18 04:18:24.181256",
                        "2018-12-18 04:18:24.18319", "2018-12-18 04:18:24.18319"],
                       [2, "abc\n\rdefg", "ABC\u0000DEFG", "f", 0,
                        "2018-12-18 04:18:24.19734", "2018-12-18 04:18:24.198651", "2018-12-18 04:18:24.198651"],
                       [3, "abc\tdefg", "ABC,DEFG", nil, -1,
                        "2018-12-18 04:18:24.202638", "2018-12-18 04:18:24.203768", "2018-12-18 04:18:24.203768"],
                       [4, "abc\\defg", "ABC\"DEFG", nil, -1,
                        "2018-12-18 04:18:24.207705", "2018-12-18 04:18:24.20904", "2018-12-18 04:18:24.20904"],
                       [5, "'abcdefg", "ABC'DEFG", nil, -1,
                        "2018-12-18 04:18:24.207705", "2018-12-18 04:18:24.20904", "2018-12-18 04:18:24.20904"],
                       [6, nil, "", nil, nil,
                        "2018-12-18 04:18:24.213643", "2018-12-18 04:18:24.215238", "2018-12-18 04:18:24.215238"]
                      ]}

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
end


