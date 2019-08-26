require 'csv'
require 'rdb_csv/reader'
require 'rdb_csv/row'

class RdbCSV
  class CSV
    include RdbCSVReader
    include RdbCSVRow

    def initialize(f, mode, options)
      @f = f
      @mode = options[:mode]
      @db = options[:db]
      @delimiter = options[:delimiter] || "\t"
      @escape = "\\"
      @linefeed = "\n"
      quote = options[:quote] || '"'

      # quote option is valid only mysql
      @quote = options[:db] == :mysql ? quote : '"'
    end

    def each
      raise IOError if @mode == 'w'

      reader = Reader.new(@f, @db, @delimiter, escape: @escape, linefeed: @linefeed, quote: @quote)

      reader.each_line do |row|
        yield row.unescape(@escape, @db, @delimiter)
      end
    end

    WRITE_BUFFER_SIZE = 1000

    def <<(array)
      raise IOError if @mode == 'r'

      @lines ||= []

      row = Row.new(array)
      line = row.join(@escape, @db, @delimiter)
      @lines << line + @linefeed
      buffer_write if @lines.size >= WRITE_BUFFER_SIZE
    end

    def buffer_write
      return if @lines.nil? || @lines.size.zero?

      @f.write(@lines.join)
      @lines = []
    end
  end

  def self.open(file, mode = 'r', options)
    db = options[:db] || :default
    delimiter = options[:delimiter] || "\t"
    quote = options[:delimiter] || '"'

    case mode
    when 'r'
      if db == :default
        ::CSV.open(file, mode, col_sep: delimiter) do |csv|
          yield csv
        end
      else
        File.open(file) do |f|
          csv = CSV.new(f, mode, db: db, delimiter: delimiter, quote: quote)
          yield csv
        end
      end
    when 'w'
      if db == :default
        ::CSV.open(file, mode, col_sep: delimiter) do |csv|
          yield csv
        end
      else
        File.open(file, 'w') do |f|
          csv = CSV.new(f, mode, db: db, delimiter: delimiter, quote: quote)
          yield csv

          csv.buffer_write
        end
      end
    end
  end

  def self.foreach(file, options)
    open(file, options) do |csv|
      csv.each do |row|
        yield row
      end
    end
  end

  def self.parse(str, options)
    db = options[:db] || :default
    delimiter = options[:delimiter] || "\t"
    quote = options[:delimiter] || '"'

    if options.key?(:db)
      reader = CSV.new(str, 'r', db: db, delimiter: delimiter, quote: quote)
    else
      reader = ::CSV.parse(str, col_sep: delimiter)
    end

    rows = []
    reader.each do |row|
      if block_given?
        yield row
      else
        rows << row
      end
    end

    return rows unless block_given?
  end

  def self.parse_line(line, options)
    ary = nil
    parse(line, options).each{|row| ary = row; break}
    return ary
  end
end
