import QtQuick 2.0

Rectangle {
    anchors.right: parent.right
    anchors.rightMargin: 200
    property var model: null

    Timer {
        id: timer
        interval: 500
        repeat: true

        onTriggered: {
            timerDisplay.text = "BABABA"
        }
    }

    Rectangle {
        width: 40
        height: 40
        id: timerCircRect
        anchors.left: parent.right
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
        font.pointSize: 10
        smooth: true
        anchors.left: timerCircRect.right
        anchors.margins: 40
        color: "steelblue"
        font.bold: true
        text: model.time
    }

    Image {
        id: playpause
        source: "qrc:/img/play-16.png"
        anchors.left: totalTime.right
        anchors.margins: 40
        y: 6

        property string playState: "paused"

        MouseArea {
            anchors.fill: parent

            onClicked: {

                if (playpause.playState === "paused") {
                    playpause.source = "qrc:/img/pause-16.png"
                    playpause.playState = "working"
                    timer.start()
                }
                else {
                    playpause.source = "qrc:/img/play-16.png"
                    playpause.playState = "paused"
                }
            }
        }
    }
}

