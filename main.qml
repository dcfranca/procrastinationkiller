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
                focus: true

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
                    //anchors.left: timerDisplay.left
                    horizontalAlignment: Text.AlignHCenter
                    text: "MY CURRENT TASK" //tasksList.itemAt(0).task
                    font.pointSize: 15
                }

                ListView {
                    id: tasksList
                    width: parent.width
                    height: 200
                    anchors.top: currentTask.bottom
                    anchors.margins: 30
                    model: tasksModel
                    clip: true
                    spacing: -5
                    delegate: taskRow
                    highlight: highlightItem
                    focus: true
                }

                Component {
                    id: highlightItem

                    Rectangle {
                        width: ListView.view.width
                        color: "steelblue"
                    }
                }

                Component {
                    id: taskRow

                    Rectangle {
                        width: main.width
                        height: 40

                        Row {
                            id: row
                            //spacing: 45
                            width: parent.width

                            CheckBox {
                                id: cbDone

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
                                font.italic: false
                                color: ListView.isCurrentItem?"steelblue":"#555555"
                                smooth: true
                            }

                            Rectangle {
                                width: 40
                                height: 40
                                id: timerCircRect
                                anchors.left: textToShow.right

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
                                //anchors.right: parent.right
                                anchors.left: timerCircRect.right
                                anchors.margins: 50
                                color: "steelblue"
                                font.bold: true
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
