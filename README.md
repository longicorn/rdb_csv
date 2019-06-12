# RdbCSV

RDB dumped csv/tsv can be read and write.

Rdbcsv supoorts mainly MySQL and PostgreSQL within reasonable range.

## Installation

```
gem install rdb_csv
```

or, add this line in your Gemfile

```
gem 'rdb_csv'
```

## Usage

`RdbCSV` is similar to the standard CSV class.

database type: argment `db`. The default is to use standard CSV class.

delimiter type: argment `delimiter` The default is to use `\t`, because the dafault delimiter for dump data is `\t`.

### MySQL

Use `INTO OUTFILE` to safely dump CSV,TSV on MySQL.

```ruby
require 'rdb_csv'

# TSV
tsv_path = "your_dump_file_path.tsv"
RdbCSV.open(tsv_path, db: :mysql, delimiter: "\t") do |tsv|
  tsv.each do |row|
    p row
  end
end

# CSV
csv_path = "your_dump_file_path.tsv"
RdbCSV.open(csv_path, db: :mysql, delimiter: ",") do |csv|
  csv.each do |row|
    p row
  end
end

# Use foreach
RdbCSV.foreach(csv_path, db: :mysql, delimiter: ",") do |row|
  p row
end
```

### PostgreSQl
Use `COPY` to safely dump CSV,TSV on PostgreSQL.

```ruby
require 'rdb_csv'

# TSV
tsv_path = "your_dump_file_path.tsv"
RdbCSV.foreach(tsv_path, db: :postgresql, delimiter: "\t") do |row|
  p row
end

# CSV
csv_path = "your_dump_file_path.csv"
RdbCSV.foreach(csv_path, db: :postgresql, delimiter: ",") do |row|
  p row
end
```

### Convert MySQL to PostgreSQl

```ruby
require 'rdb_csv'

mysql_rows = []

mysql_tsv_path = "your_mysql_dump_file_path.tsv"
RdbCSV.foreach(mysql_tsv_path, db: :mysql, delimiter: "\t") do |row|
  mysql_rows << row
end

postgres_tsv_path = "your_postgres_dump_file_path.tsv"
RdbCSV.open(postgres_tsv_path, "w", db: :postgresql, delimiter: "\t") do |tsv|
  mysql_rows.each do |mysql_row|
    tsv << mysql_row
  end
end
```
