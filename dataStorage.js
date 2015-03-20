.import QtQuick.LocalStorage 2.0 as Sql

function getDatabase() {
    return Sql.LocalStorage.openDatabaseSync("./todoDB", "1.0", "Procrastination Killer", 100000);
}

function init() {
    var db = getDatabase();

    db.transaction(
        function(tx) {
            console.log("Create table...");
            tx.executeSql('CREATE TABLE IF NOT EXISTS taskData(\
                           name VARCHAR(100),
                           parameter VARCHAR(50),
                           value VARCHAR(50))')
        }
    )
}

function loadTasks() {
    var obj = {};
    var objList = [];
    var db = getDatabase();
    db.transaction(
       function(tx) {
           var rs = tx.executeSql('SELECT * FROM taskData ORDER BY name')

           var lastTask = null;
           var obj = null;
           for(var i = 0; i < rs.rows.length; i++) {
               var item = rs.rows.item(i);

               if (lastTask !== item.name) {
                   obj = {'task': item.name};
                   lastTask = item.name;
                   objList.push(obj);
               }
               else {
                   obj[item.parameter] = item.value;
               }
           }
       })

    return objList;
}

function updateTaskParam(name, param, value) {
    console.log("updateTaskParam")
    var db = getDatabase();
    db.transaction(
        function(tx) {
            var rs = tx.executeSql('SELECT 1 FROM taskData WHERE name = ? AND parameter = ?', [name, param])
            if (rs.rows.length > 0)
                tx.executeSql('UPDATE taskData SET value = ? WHERE name = ? AND parameter = ?', [value, name, param])
            else
                tx.executeSql('INSERT INTO taskData VALUES(?, ?, ?)', [name, param, value])
        }
    )
}

function AddOrUpdateTask(name, params) {
    console.log("AddOrUpdateTask")
    for (var property in params) {
         if (params.hasOwnProperty(property)) {
             updateTaskParam(name, property, params[property])
         }
    }
}

function DeleteTask(name) {
    console.log("DeleteTask " + name)
    var db = getDatabase();
    db.transaction(
        function(tx) {
            tx.executeSql('DELETE FROM taskData WHERE name = ?', [name]);
        }
    )
}
