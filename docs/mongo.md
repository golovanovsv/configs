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
mongodump --port 27017 -u admin --password <password> --authenticationDatabase=admin --db=mongo_db [--collection=<collection>] --archive=mongo_db.dump [--gzip]
mongorestore --port 27017 -u admin --password <password> --authenticationDatabase=admin --archive=mongo_db.dump [--gzip] // db/collection не указывается при восстановлении из бинаря

mongodump --port 27017 -u admin --password <password> --authenticationDatabase=admin --db=swap_global --collection=plugin_combinations --archive=swap_global.plugin_combinations.ts.dump
mongorestore --port 27017 --host 172.16.121.8 --nsFrom "swap_global.plugin_combinations" --nsTo "upload.plugin_combinations_ts" --archive=swap_global.plugin_combinations.ts.dump
mongorestore --port 27017 --host 172.16.121.8 --nsFrom "swap_global.*" --nsTo "upload.*" --archive=swap_global.plugin_combinations.ts.dump

mongodump --port 27018 -u admin --password DoociecuNgo1ee --authenticationDatabase=admin --db=stfs_mongo --archive=stfs_mongo.dump --gzip
mongodump --port 27018 -u admin --password DoociecuNgo1ee --authenticationDatabase=admin --db=stfs_mongo --collection=policy_diff --archive=policy_diff.dump --gzip

# Пользователи
db.getUsers()
db.changeUserPassword("monitor", "<pwd>")
db.updateUser("monitor", { pwd: "<pwd>", passwordDigestor:"server"});
db.createUser({
  user: "logger",
  pwd: "zPGLTSBzTOkLqcXc",
  roles: [
    { role: "root", db: "admin" },
    { role: "userAdminAnyDatabase", db: "admin" },
    { role: "dbAdminAnyDatabase", db: "admin" },
    { role: "readWriteAnyDatabase", db: "admin" }
  ],
  mechanisms: ["SCRAM-SHA-256"],
})
db.dropUser("email")

# Коллекции
db.getCollectionNames()
db.<collection-name>.drop()
db.<collection-name>.stats().avgObjectSize
db.<collection-name>.totalSize()/1024/1024/1024

db.runCommand({"convertToCapped": "<collection-name>", size: 1000000000});

## Объем коллекций
db.getCollection('eve_taxi').count()
db.getCollectionNames().forEach(function(c) {
  printjson(db[c].stats().storageSize/1024/1024+" Mb: "+db[c].stats().ns);
})
db.getCollectionNames().forEach(function(c) {
  if (db[c].stats().storageSize/1024/1024/1024 > 1) {
    printjson(db[c].stats().storageSize/1024/1024/1024+" Gb: "+db[c].stats().ns);
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

# Profiling
#  Индивидуальные параметры для каждого сервера
db.getProfilingStatus()
db.setProfilingLevel(0, { slowms: 200 })

db.teams.remove({ _id: "stfs" })
db.users.updateOne({ _id: "f5846a32-683a-44b5-829d-9f19f9163dd8"}, { $set: { "roles": ["FraudChiefOfficer", "ChiefRiskOfficer"] }})

# Replication
rs.initiate()
rs.initiate(
  {
    _id: "mall",
    members: [
      {_id: 0, host: "192.168.218.8:27017" },
      {_id: 1, host: "192.168.219.8:27017" }
    ]
  }
)
rs.add( {host: "<host>:<port>", priority: 0, hidden: true} )
rs.addArb("<host>:<port>")
rs.remove("<hostname>:<port>")
db.printReplicationInfo()

# Set default concern
db.adminCommand({ "getDefaultRWConcern" : 1 })
db.adminCommand({ "setDefaultRWConcern" : 1, "defaultWriteConcern" : { "w" : 2 } })

# Oplog size
use local
db.oplog.rs.stats().maxSize/1024/1024/1024

oplog является локальным параметром сервера. Не реплицируется.
db.adminCommand({replSetResizeOplog: 1, size: <size-in-mb>})

# force
cfg = rs.conf();
cfg.members[3].host = "172.30.37.13:27017"; // Меняем IP у hidden (восстановление из бэкапа)
cfg.members[3].hidden = false; // Выключаем признак hidden
cfg.members[3].priority = 1; // Позволяем учавствовать в выборах
cfg.members.splice(0,3); // Удаляем 3 элемента начиная с нулевого
rs.reconfig(cfg, {force: true}); // Принудительно применяем новый конфиг

# remove arbiter
Чтобы удалить арбитра нужно отобрать у всех SECONDARY голоса и приоритет
cfg = rs.conf()
cfg.members[x].votes = 0
cfg.members[x].priority = 0
rs.reconfig(cfg)

Удалить арбитра(-ов)
rs.remove("arbiter:port")

Вернуть голоса и приоритеты особым образом
cfg = rs.conf()
cfg.members[x].votes = 1
cfg.members[x].priority = 1
rs.reconfigForPSASet(x,cfg)
