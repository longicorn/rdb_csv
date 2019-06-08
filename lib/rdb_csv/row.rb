module RdbCSVRow
  class Row < Array
    def unescape(escape_char, db, delimiter)
      send("unescape_#{db}").map{|v|v.to_i.to_s == v ? v.to_i : v rescue v}
    end

    def join(escape_char, db, delimiter)
      escape(escape_char, db, delimiter).to_a.join(delimiter)
    end

    private

    def unescape_default
      self
    end

    def unescape_mysql
      row = self
      if @quote
        row = row.map{|v|v.match?(/^#{@quote}.*?#{@quote}$/m) ? v[1..-2].gsub(/#{@quote}#{@quote}/o, @quote) : v}
      end
      row.map{|v|v.nil? ? nil : v.gsub(/\\\\/o, '\\')
                                  .gsub(/\\n/o, "\n")
                                  .gsub(/\\\n/o, "\n")
                                  .gsub(/\\r/o, "\r")
                                  .gsub(/\\t/o, "\t")
                                  .gsub(/\\0/o, "\0")
                                  .gsub(/\\,/o, ",")
              }
          .map{|v|v=="\\N" ? nil : v}
          .map{|v|v=="NULL" ? nil : v}
    end

    def unescape_postgresql
      self.map{|v|v.gsub(/\\0/o, "\0")}
          .map{|v|v.match?(/^".*?"$/om) ? v[1..-2].gsub(/""/, '"') : (v == '' ? nil : v)}
    end

    def escape(escape_char, db, delimiter)
      send("escape_#{db}", escape_char, delimiter)
    end

    def escape_default(escape_char, delimiter)
      self
    end

    def escape_mysql(escape_char, delimiter)
      case delimiter
      when "\t" # tsv
        self.map do |column|
          case column
          when nil
            "NULL"
          when String
            str = ""
            column.each_char do |char|
              case char
              when escape_char
                str += char*2
              when "\n"
                str += "#{escape_char}n"
              when "\t"
                str += "#{escape_char}t"
              when "\0"
                str += "#{escape_char}0"
              else
                str += char
              end
            end
            str
          else
            column
          end
        end
      when "," # csv
        self.map do |column|
          case column
          when nil
            "#{escape_char}N"
          when String
            str = ""
            column.each_char do |char|
              case char
              when escape_char
                str += char*2
              when "\n"
                str += "#{escape_char}\n"
              when "\0"
                str += "#{escape_char}0"
              when delimiter
                str += "#{escape_char}#{delimiter}"
              else
                str += char
              end
            end
            str
          else
            column
          end
        end
      end
    end

    def escape_postgresql(escape_char, delimiter)
      self.map do |v|
        if v == ''
          '""'
        elsif v.nil?
          ''
        elsif v.kind_of?(String)
          v = v.gsub(/\0/o, "#{escape_char}#{escape_char}0")
          v = v.gsub(/"/o, '""') if v.include?('"')
          v = "\"#{v}\"" if v.match?(/"|\r|\n|#{delimiter}/)
          v
        else
          v
        end
      end
    end
  end
end
