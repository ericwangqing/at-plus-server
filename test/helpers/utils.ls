require! '../bin/database'

FIXTURE_PATH = __dirname + '/../test-bin/' # 这样写，是因为在开发时，src目录中的代码也会使用。
module.exports =
  load-fixture: (data-name)->
    eval require('fs').readFileSync(FIXTURE_PATH + data-name + '.js', {encoding: 'utf-8'}) 

  open-db-and-load-fixtures: !(collection-name, docs, done)->
    (db) <-! database.get-db
    (err, docs) <-! db.at-plus.[collection-name].insert docs
    throw new Error err if err
    done!

  clear-and-close-db: !(done)->
    (db) <-! database.get-db
    <-! db.drop-database
    database.shutdown-mongo-client done
