/*
  General functions
*/

function addTask(taskModel, task, tasksList, parentLayout) {
    var extraData = loadExtraData(parentLayout)
    if (task.length > 0) {
        var item = {task: task, state: "paused", done: false};
        console.log("Extra data: " + extraData);
        for (var property in extraData) {
            item[property] = extraData[property];
        }

        tasksModel.insert(0, item);
        tasksList.currentIndex = 0;
    }
}

function loadExtraData(parentLayout) {
    var extraData = {};
    for (var x=0; x<parentLayout.inputObjects.length; x++) {
        var extra = parentLayout.inputObjects[x].extraData();
        for (var property in parentLayout.inputObjects[x].extraData()) {
            extraData[property] = extra[property];
        }
    }

    return extraData;
}

