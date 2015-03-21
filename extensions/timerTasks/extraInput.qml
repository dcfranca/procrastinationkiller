import QtQuick 2.0
import QtQuick.Layouts 1.1

import "qrc:/utils.js" as Utils

RowLayout {
    id: newRowLayout
    anchors.right: parent.right
    anchors.rightMargin: parent.width/5

    function extraData() {
        return {"time": timeInput.text + ":00", "remaining": timeInput.text + ":00"};
    }

    Rectangle {
        width: 80
        height: 25
        border.color: "deepskyblue"
        border.width: 2
        radius: 3

        TextInput {
            id: timeInput

            objectName: "input"
            text: "25"
            focus: true
            horizontalAlignment: TextInput.AlignHCenter
            font.pixelSize: 20
            font.family: "Segoe UI Light"
            anchors.fill: parent
            inputMask: "99"

        }
    }
}

