## Mongo

# Подключаемся
mongo -u admin -p --authenticationDatabase admin

show dbs
use <db>

db.adminCommand("listDatabases").databases.forEach(function (d) {
   mdb = db.getSiblingDB(d.name);
   printjson(mdb.stats().db+": "+mdb.stats().storageSize/1024/1024+" Mb");
})

# Обслуживание DB
## Перевести ноду в режим обслуживания
db.adminCommand({ replSetMaintenance: 1 })
## Выполнять только на SECONDARY! Приводит к остановке реплики.
db.repairDatabase() 

db.<collection-name>.stats().wiredTiger["block-manager"]["file bytes available for reuse"]
db.runCommand({ compact: <collection-name> })

## Управление уровнем совместимости
db.adminCommand( { getParameter: 1, featureCompatibilityVersion: 1 } )
db.adminCommand( { setFeatureCompatibilityVersion: "4.2" } )

# Backup-restore
mongodump --port 27017 -u admin --password <password> --authenticationDatabase=admin --db=mongo_db --archive=mongo_db.dump 
mongorestore --port 27017 -u admin --password <password> --authenticationDatabase=admin --db=mongo_db --archive=mongo_db.dump


# Пользователи
db.getUsers()

# Коллекции
db.getCollectionNames()
db.<collection-name>.drop()
db.<collection-name>.stats().avgObjectSize
db.<collection-name>.totalSize()/1024/1024/1024

db.runCommand({"convertToCapped": "<collection-name>", size: 1000000000});

## Объем коллекций
db.getCollection('eve_taxi').count()
db.getCollectionNames().forEach(function(c) {
  printjson(db[c].stats().ns+": "+db[c].stats().storageSize/1024/1024+" Mb");
})
db.getCollectionNames().forEach(function(c) {
  if (db[c].stats().storageSize/1024/1024/1024 > 1) {
    printjson(db[c].stats().ns+": "+db[c].stats().storageSize/1024/1024/1024+" Gb");
  }
})

# Смотрим индексы коллекции
db.getCollection('eve_taxi').getIndexes()

# Документы
db.getCollection('customers').findOne()
db.getCollection('customers').find({"_id":"XXX"})

db.customers2.insertOne(
   { _id: 2, status: "b", lastModified: ISODate("2013-10-02T01:11:18.965Z") }
)

# Queries
db.getMongo().setSlaveOk()

db.<collection>.deleteMany({$and: [{"createdAt":  {$gte: 124124241 }},  {$createdAt: {$lte: 12421424}}  ] })
db.<collection>.find({ $and: [{"createdAt": { $gte: 1598918400 }}, { "createdAt": { $lte: 1599040800 } }] })
db.<collection>.find({ $and: [{"createdAt": { $gte: 1598918400 }}, { "createdAt": { $lte: 1599040800 } }] }).sort({"createdAt": 1}).limit(1)
db.<collection>.findOne({ $and: [{"createdAt": { $gte: 1598918400 }}, { "createdAt": { $lte: 1599040800 } }] })

var date = NumberLong(new Date("2020-07-20T00:00:00Z"))
var date = new Date(<NumberLong>)

# Создаем индексы
db.getCollectionNames().forEach(
  function(col) {
    print("Create indexes for " + col);
    db.getCollection(col).createIndex({'value' : 1, 'time' : -1}, { background: true, name: 'value_by_time_idx'})
    db.getCollection(col).createIndex({'ttl' : 1}, { expireAfterSeconds:1, background: true, name: 'ttl_idx'})
  }
)