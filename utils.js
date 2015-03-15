/*
  General functions
*/

.import "qrc:/dataStorage.js" as Storage

function addTask(taskModel, task, tasksList, parentLayout) {
    var extraData = loadExtraData(parentLayout)
    if (task.length > 0) {
        var item = {task: task, state: "paused"};
        console.log("Extra data: " + extraData);
        for (var property in extraData) {
            item[property] = extraData[property];
        }

        delete item['task']

        console.log("Task: " + task);
        console.log("Item: " + JSON.stringify(item));

        Storage.AddOrUpdateTask(task, item);
        item['task'] = task;

        tasksModel.insert(0, item);
        tasksList.currentIndex = 0;
    }
}

function loadExtraData(parentLayout) {
    var extraData = {};
    for (var x=0; x<parentLayout.inputObjects.length; x++) {
        var extra = parentLayout.inputObjects[x].extraData();
        for (var property in extra) {
            extraData[property] = extra[property];
        }
    }

    return extraData;
}

