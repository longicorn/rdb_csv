# Load test

## MySQL
```
$ cp spec/load/docker/docker-compose.mysql.yml docker-compose.yml
$ sudo docker-compose up -d
$ mysql -h 127.0.0.1 -P 3306 -u docker -p < spec/load/create_table.mysql.sql
```

load csv
```
$ mysql -h 127.0.0.1 -P 3306 -u docker -p < spec/load/load.mysql.csv.sql
```

load tsv
```
$ mysql -h 127.0.0.1 -P 3306 -u docker -p < spec/load/load.mysql.tsv.sql
```

## PostgreSQL
```
$ cp spec/load/docker/docker-compose.postgresql.yml docker-compose.yml
$ sudo docker-compose up -d
$ mysql -h 127.0.0.1 -P 3306 -u docker -p < spec/load/create_table.postgresql.sql
```

load csv
```
$ sudo docker cp spec/fixtures/postgresql.csv <CONTAINER ID>:/tmp/postgresql.csv
$ psql -h 127.0.0.1 -p 5432 -U docker < spec/load/load.postgresql.csv.sql
```

load tsv
```
$ sudo docker cp spec/fixtures/postgresql.tsv <CONTAINER ID>:/tmp/postgresql.csv
$ psql -h 127.0.0.1 -p 5432 -U docker < spec/load/load.postgresql.tsv.sql
```
