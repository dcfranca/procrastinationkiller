/*
  General functions
*/

function addTask(taskModel, task, tasksList, extraData) {
    if (task.length > 0) {
        var item = {task: task, state: "paused", done: false};
        console.log("Extra data: " + extraData);
        for (var property in extraData) {
            item[property] = extraData[property];
        }

        //item.extend(extraData);

        tasksModel.insert(0, item);
        tasksList.currentIndex = 0;
    }
}

