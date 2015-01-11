import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtQuick.Layouts 1.1

import "qrc:/utils.js" as Utils
import "qrc:/extensions.js" as Extensions

ApplicationWindow {
    id: main
    width: 448;
    height: 672;
    visible: true;
    color: "white";

    TabView {
        x: 0
        y: 0
        height: parent.height
        currentIndex: 0
        width: parent.width

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
            ListElement { task: "Current task"; time: "25m"; remaining: "00:02:00"; state: "running"; done: false }
            ListElement { task: "[Eureca] Add something"; time: "10m"; remaining: "00:10:00"; state: "waiting"; done: false }
            ListElement { task: "[GS] Auto complete"; time: "45m"; remaining: "00:00:00"; state: "finished"; done: false }
            ListElement { task: "[GS] Fixing bugs"; time: "30m"; remaining: "00:15:30"; state: "paused"; done: false }
            ListElement { task: "[GS] Big project"; time: "15m"; remaining: "01:15:00"; state: "waiting"; done: false }
            ListElement { task: "[Extranet] To do stuff"; time: "15m"; remaining: "00:13:00"; state: "paused"; done: false }
            ListElement { task: "[Extranet] Whatever"; time: "11m"; remaining: "00:11:00"; state: "paused"; done: false }
        }

        Tab {
            title: "Home"
            width: parent.width

            Rectangle {
                anchors.fill: parent
                id: homeContainer;


                Component.onCompleted: {
                    //mainDisplay.destroy();
                    //Extensions.createExtensionComponent("mainDisplay.qml", homeContainer);
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
                    //height: text.height
                }

                Text {
                    id: currentTask
                    anchors.top: mainDisplay.bottom
                    //anchors.topMargin: -80
                    width: homeContainer.width
                    horizontalAlignment: Text.AlignHCenter
                    text: "" //tasksList.itemAt(0).task
                    font.pointSize: 15
                }

                RowLayout {
                    anchors.top: currentTask.bottom
                    width: parent.width
                    id: addTaskLayout

                    BorderImage {
                        id: addTaskBorder
                        source: "qrc:/img/textfield.png"

                        width: 300
                        x: 20
                        anchors.margins: 20
                        border.left: 10 ; border.right: 10; border.top: 8; border.bottom: 8

                        TextInput {
                            id: addTaskInput
                            width: 260
                            clip: true
                            font.pointSize: 14
                            selectionColor: "blue"
                            x: 20

                            onAccepted: {
                                Utils.addTask(tasksModel, addTaskInput.text, tasksList)
                            }

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
                        Extensions.createExtensionComponent("extraInput.qml", addTaskLayout);
                    }

                    Image {
                        id: addTaskButton
                        source: "qrc:/img/plus-24.png"
                        anchors.right: parent.right
                        anchors.margins: 40
                        x: 20

                        MouseArea {
                            anchors.fill: parent

                            onClicked: {
                                Utils.addTask(tasksModel, addTaskInput.text, tasksList)
                            }
                        }
                    }
                }

                ListView {
                    id: tasksList
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

                    Component.onCompleted: tasksList.forceActiveFocus()

                    onCurrentIndexChanged: {
                        currentTask.text = tasksModel.get(tasksList.currentIndex).task
                    }

                }

                Component {
                    id: highlightItem

                    Rectangle {
                        width: ListView.view.width
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

                        RowLayout {
                            id: row
                            width: parent.width
                            x: 10

                            CheckBox {
                                id: cbDone

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
                                    tasksModel.get(index).done = checked
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
                                Extensions.createExtensionComponent("taskRow.qml", row, tasksModel.get(index));
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
                            if (item.done) {
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
