module RdbCSVReader
  class Reader
    def initialize(fp, db, delimiter, escape="\\", linefeed="\n", quote='"')
      @fp = fp
      @db = db
      @delimiter = delimiter
      @escape = escape # 1 char
      @linefeed = linefeed
      @quote = quote
    end

    def each_line
      str = ''
      row = []
      quote_num = 0

      each_char do |char|
        if quote_num > 0
          if str[-1] == @quote && char == @quote
            quote_num -= 1
          elsif str[-1] != @quote && char == @quote
            quote_num -= 1
          elsif char == @quote
            quote_num += 1
          end
          str += char
        else
          if char == @delimiter
            row << str
            str = ''
          elsif char == @linefeed
            row << str
            yield RdbCSV::CSV::Row.new(row)
            row = []
            str = ''
          else
            quote_num += 1 if (str.size == 0 || str[0] == @quote) && char == @quote
            str += char
          end
        end
      end
    end

    private

    def each_char
      str = ''
      @fp.each_char do |char|
        if str[-1] == @escape
          str += char
          yield str
          str = ''
          next
        end

        str += char

        if str[@linefeed.size-1..-1] == @linefeed
          yield str
          str = ''
          next
        end

        if str[-1] != @escape
          yield str
          str = ''
        end
      end

      yield str unless str.empty?
    end
  end
end
