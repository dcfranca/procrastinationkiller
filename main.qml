import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

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

                Text {
                    id: timerDisplay
                    text: qsTr("TODO")
                    font.pointSize: 100
                    width: parent.width
                    height: text.height
                    horizontalAlignment: Text.AlignHCenter
                    smooth: true
                    font.italic: false
                }

                Text {
                    id: currentTask
                    anchors.top: timerDisplay.bottom
                    anchors.topMargin: -50
                    width: timerDisplay.width
                    horizontalAlignment: Text.AlignHCenter
                    text: "MY CURRENT TASK" //tasksList.itemAt(0).task
                    font.pointSize: 15
                }

                /*BorderImage {
                    x: 20
                    anchors.right: addTaskButton.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.margins: 10
                    source:"qrc:/img/textfield.png"
                    border.left: 14 ; border.right: 14 ; border.top: 8 ; border.bottom: 8
                    TextInput {
                        id: addTaskInput
                        anchors.top: currentTask.bottom
                        width: 200
                        clip: true
                        font.pointSize: 14
                        selectionColor: "blue"
                        //anchors.verticalCenter: main

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

                Image {
                    id: addTaskButton
                    source: "qrc:/img/plus-24.png"
                    anchors.left: addTaskInput.right
                    anchors.top: currentTask.bottom
                    x: 10
                }*/

                BorderImage {
                    id: addTaskBorder
                    source: "qrc:/img/textfield.png"
                    anchors.top: currentTask.bottom
                    //anchors.right: addTaskButton.left
                    width: 300
                    x: 20
                    anchors.margins: 20
                    border.left: 10 ; border.right: 10; border.top: 8; border.bottom: 8
                    TextInput {
                        id: addTaskInput
                        anchors.top: currentTask.bottom
                        width: 260
                        clip: true
                        font.pointSize: 14
                        selectionColor: "blue"
                        x: 20

                        onAccepted: {
                            tasksModel.append({task: addTaskInput.text, time: "30m", remaining: "00:30:00", state: "paused", done: false})
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

                Image {
                    id: addTaskButton
                    source: "qrc:/img/plus-24.png"
                    anchors.left: addTaskBorder.right
                    anchors.bottom: addTaskBorder.bottom
                    anchors.margins: 10
                    //verticalAlignment: addTaskBorder.verticalCenter
                    x: 20

                    MouseArea {
                        anchors.fill: parent

                        onClicked: {
                            tasksModel.append({task: addTaskInput.text, time: "30m", remaining: "00:30:00", state: "paused", done: false})
                        }
                    }
                }

                ListView {
                    id: tasksList
                    width: parent.width
                    height: 200
                    anchors.top: addTaskBorder.bottom
                    anchors.margins: 10
                    model: tasksModel
                    clip: true
                    spacing: -5
                    delegate: taskRow
                    highlight: highlightItem
                    focus: true

                    Component.onCompleted: tasksList.forceActiveFocus()
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

                        Row {
                            id: row
                            width: parent.width

                            CheckBox {
                                id: cbDone
                                x: 3
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
                                }
                            }

                            Text {
                                id: textToShow
                                text: task
                                width: 200
                                anchors.left: parent.left
                                anchors.margins: 30
                                font.pointSize: 12
                                font.italic: tasksList.ListView.isCurrentItem
                                color: "#555555"
                                smooth: true

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        tasksList.currentIndex = index;
                                    }
                                }
                            }

                            Rectangle {
                                width: 40
                                height: 40
                                id: timerCircRect
                                anchors.left: textToShow.right
                                color: "transparent"

                                Canvas {
                                    id: timerCirc
                                    anchors.fill: parent

                                    onPaint: {
                                        var ctx = getContext("2d")
                                        ctx.reset()
                                        var centreX = width/2
                                        var centreY = height/2

                                        ctx.beginPath()
                                        ctx.fillStyle = "steelblue"
                                        ctx.moveTo(centreX, centreY)

                                        ctx.fillStyle = "steelblue"
                                        ctx.moveTo(centreX, centreY)

                                        ctx.arc(centreX, centreY, width / 4, Math.PI * 0.5, 2*Math.PI, false)

                                        ctx.lineTo(centreX, centreY)
                                        ctx.closePath()
                                        ctx.fill()
                                    }
                                }
                            }

                            Text {
                                id: totalTime
                                text: time
                                font.pointSize: 10
                                smooth: true
                                anchors.left: timerCircRect.right
                                anchors.margins: 40
                                color: "steelblue"
                                font.bold: true
                            }

                            Image {
                                id: playpause
                                source: "qrc:/img/play-16.png"
                                anchors.left: totalTime.right
                                anchors.margins: 10
                                y: 6

                                property string playState: "paused"

                                MouseArea {
                                    anchors.fill: parent

                                    onClicked: {

                                        if (playpause.playState === "paused") {
                                            playpause.source = "qrc:/img/pause-16.png"
                                            playpause.playState = "working"
                                        }
                                        else {
                                            playpause.source = "qrc:/img/play-16.png"
                                            playpause.playState = "paused"
                                        }
                                    }
                                }
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
