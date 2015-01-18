import QtQuick 2.0

Rectangle {
    anchors.right: parent.right
    anchors.rightMargin: 200
    property var model: null
    property var lastUpdate: null
    property var remaining: null

    function findQmlElement(root, id) {
        if (root.objectName === id)
            return root;
        for (var x=0; x < root.children.length; x++) {
            var elem = findQmlElement(root.children[x], id);
            if (elem)
                return elem;
        }

        return;
    }

    Timer {
        id: timer
        interval: 500
        repeat: true

        function addZero(val) {
            if (val < 10) {
                val = "0" + val;
            }

            return val;
        }

        onTriggered: {
            var timerDisplay = findQmlElement(tabHome, "timerDisplay")

            //lastStart: 10:20:09
            //remaining: 25:00 <- show on timerDisplay

            if (!lastUpdate || !remaining)
                return;

            var subtract = new Date() - lastUpdate;
            lastUpdate = new Date()
            console.log("REMAINING: " + remaining)
            remaining = new Date(remaining - subtract);

            if (remaining.getHours() <= 0 && remaining.getMinutes() <= 0) {
                timer.stop()
                timerDisplay.text = "00:00";
            }
            else {
                timerDisplay.text = addZero(remaining.getMinutes()) + ":" + addZero(remaining.getSeconds());
            }
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
                    lastUpdate = new Date()
                    console.log(model.remaining)

                    var min = parseInt(model.remaining.substr(0,2))
                    var sec = parseInt(model.remaining.substr(3,5))

                    remaining = new Date(null, null, null, 0, min, sec, 0)
                    timer.start()
                    playpause.playState = "running"
                }
                else {
                    console.log("Stopping...")
                    playpause.source = "qrc:/img/play-16.png"
                    playpause.playState = "paused"
                    timer.stop()
                    var timerDisplay = findQmlElement(tabHome, "timerDisplay");
                    model.remaining = timerDisplay.text;
                }
            }
        }
    }
}

