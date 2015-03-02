import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtQuick.Layouts 1.1

import "qrc:/utils.js" as Utils
import "qrc:/extensions.js" as Extensions
import "qrc:/dataStorage.js" as DataStorage

ApplicationWindow {
    id: main
    width: 448;
    height: 672;
    visible: true;
    color: "white";

    property variant extraInput: null
    property variant db: null

    TabView {
        x: 0
        y: 0
        height: parent.height
        currentIndex: 0
        width: parent.width
        id: tabView

        style: TabViewStyle {
            frameOverlap: 1
            tab: Rectangle {
                color: styleData.selected ? "cornflowerblue" :"#DEDEDE"
                border.color:  "white"
                border.width: 1
                implicitWidth: main.width/3
                implicitHeight: 70
                Text {
                    id: text
                    anchors.centerIn: parent
                    text: styleData.title
                    color: "white"
                }
            }
            frame: Rectangle { color: "white" }
        }

        ListModel {
            id: tasksModel
        }

        Tab {
            title: "Home"
            width: parent.width
            id: tabHome

            Rectangle {
                anchors.fill: parent
                id: homeContainer;

                Component.onCompleted: {
                    var extensionsList = extMng.extensions
                    var baseDir = "qrc:/extensions/";
                    for (var x=0; x < extensionsList.length; x++) {
                        mainDisplay.source = baseDir + extensionsList[x] + "/mainDisplay.qml";
                        break;
                    }

                }

                Loader {
                    id: mainDisplay
                    width: parent.width
                }

                Text {
                    id: currentTask
                    anchors.top: mainDisplay.bottom
                    anchors.topMargin: -30
                    width: homeContainer.width
                    horizontalAlignment: Text.AlignHCenter
                    text: "" //tasksList.itemAt(0).task
                    font.pointSize: 15
                }

                RowLayout {
                    anchors.top: currentTask.bottom
                    width: parent.width
                    id: addTaskLayout

                    property var inputObjects: []
                    property var inputItems: []

                    Rectangle {
                        id: addTaskBorder

                        width: 260
                        height: 25
                        anchors.left: parent.left
                        anchors.leftMargin: 20
                        border.width: 2
                        border.color: "deepskyblue"
                        radius: 3

                        function inputAccepted() {
                            Utils.addTask(tasksModel, addTaskInput.text, tasksList, addTaskLayout);
                        }

                        function retrieveInputs(item) {
                            for (var x=0; x < item.children.length; x++){
                                var entry = item.children[x];
                                if (entry.objectName === "input")
                                    addTaskLayout.inputItems.push(entry);
                                else if (entry.children.length > 0)
                                    retrieveInputs(entry)
                            }
                        }

                        function retrieveTaskRow(item) {
                            for (var x=0; x < item.children.length; x++){
                                var entry = item.children[x];
                                if (entry.objectName === "taskRow")
                                    return entry;
                                else if (entry.children.length > 0)
                                    retrieveTaskRow(entry)
                            }
                        }

                        TextInput {
                            id: addTaskInput
                            width: 250
                            clip: true
                            font.pointSize: 11
                            selectionColor: "blue"
                            x: 10
                            focus: true
                            objectName: "input"

                            Component.onCompleted: {
                                addTaskInput.onAccepted.connect(addTaskBorder.inputAccepted);
                                addTaskLayout.inputObjects.forEach(function(entry) {
                                    addTaskBorder.retrieveInputs(entry);
                                })

                                addTaskLayout.inputItems.forEach(function(inputField){
                                    inputField.onAccepted.connect(addTaskBorder.inputAccepted)
                                })
                            }

                            KeyNavigation.tab: addTaskLayout.inputObjects[0].children[0].children[0]

                            Text {
                                id: placeholderText
                                anchors.fill: parent
                                verticalAlignment: Text.AlignVCenter
                                visible: !(parent.text.length || parent.inputMethodComposing)
                                font: parent.font
                                text: "New task..."
                                color: "#aaa"
                            }
                        }
                    }

                    Component.onCompleted: {
                        addTaskLayout.inputObjects = Extensions.createExtensionComponent("extraInput.qml", addTaskLayout);
                    }

                    Image {
                        id: addTaskButton
                        source: "qrc:/img/plus-24.png"
                        anchors.right: parent.right
                        anchors.rightMargin: 30
                        focus: true

                        MouseArea {
                            anchors.fill: parent
                            id: mouseArea

                            onClicked: {
                                Utils.addTask(tasksModel, addTaskInput.text, tasksList, addTaskLayout)
                            }
                        }
                    }
                }

                ListView {
                    id: tasksList
                    objectName: "tasksList"
                    width: parent.width
                    height: 200
                    anchors.top: addTaskLayout.bottom
                    anchors.margins: 10
                    model: tasksModel
                    clip: true
                    spacing: -5
                    delegate: taskRow
                    highlight: highlightItem
                    focus: true

                    Component.onCompleted: {
                        console.log("Init storage")
                        DataStorage.init();
                        var tasks = DataStorage.loadTasks();

                        tasks.forEach(function(entry){
                            var item = {task: entry.task};
                            for (var property in entry) {
                                item[property] = entry[property];
                            }
                            tasksModel.insert(0, item);
                        })

                        tasksList.forceActiveFocus()
                    }

                    onCurrentIndexChanged: {
                        currentTask.text = tasksModel.get(tasksList.currentIndex).task
                    }

                }

                Component {
                    id: highlightItem

                    Rectangle {
                        //width: ListView.view.width
                        height: 100
                        color: "deepskyblue"
                        radius: 3
                    }
                }

                Component {
                    id: taskRow

                    Rectangle {
                        width: main.width
                        height: 40
                        color: "transparent"

                        Keys.onSpacePressed: cbDone.checked = !cbDone.checked;
                        /*Keys.forwardTo: {
                            //var tk = addTaskBorder.retrieveTaskRow(taskRow)
                            //console.log("Retrieved: " + tk)
                            //return tk;
                        }*/
                        Keys.onReturnPressed: {
                            console.log("On Enter pressed")
                        }


                        RowLayout {
                            id: row
                            width: parent.width
                            x: 10

                            CheckBox {
                                id: cbDone
                                objectName: "cbDone"

                                style: CheckBoxStyle {
                                    indicator: Rectangle {
                                            implicitWidth: 16
                                            implicitHeight: 16
                                            radius: 10
                                            border.color: "#555555"
                                            border.width: 1
                                            Rectangle {
                                                visible: control.checked
                                                color: "green"
                                                border.color: "#333"
                                                radius: 10
                                                anchors.margins: 4
                                                anchors.fill: parent
                                            }
                                    }
                                }

                                onCheckedChanged: {
                                    textToShow.font.strikeout = checked
                                    tasksModel.get(index).status = "finished"
                                    tasksList.currentIndex = index
                                }
                            }

                            Text {
                                id: textToShow
                                text: task
                                width: 200
                                anchors.left: cbDone.left
                                anchors.leftMargin: 30
                                font.pointSize: 12
                                font.italic: tasksList.ListView.isCurrentItem
                                color: "#555555"

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        tasksList.currentIndex = index;
                                    }
                                }
                            }

                            Component.onCompleted: {
                                Extensions.createExtensionComponent("taskRow.qml", row, {"model":tasksModel.get(index), "index": index});
                            }
                        }
                    }
                }

                Button {
                    id: btClearTasks
                    width: 80
                    height: 40
                    text: qsTr("Clear")
                    anchors.top: tasksList.bottom
                    anchors.margins: 20
                    x: 5

                    onClicked: {
                        for (var x=0; x<tasksList.count; x++) {
                            var item = tasksModel.get(x)
                            if (item.status === "finished") {
                                tasksModel.remove(x)
                                x--;
                            }
                        }
                    }
                }
            }
        }
        Tab {
            title: "Report"
        }
        Tab {
            title: "Settings"
        }
    }
}
