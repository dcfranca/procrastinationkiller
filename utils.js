/*
  General functions
*/

function addTask(taskModel, task, tasksList) {
    if (task.length > 0) {
        tasksModel.insert(0, {task: task, time: "30m", remaining: "00:30:00", state: "paused", done: false})
        tasksList.currentIndex = 0;
    }
}

