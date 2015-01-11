import QtQuick 2.0
import QtQuick.Layouts 1.1

RowLayout {
    anchors.right: parent.right
    anchors.rightMargin: parent.width/5

    Rectangle {
        width: 80
        height: 25
        border.color: "deepskyblue"
        border.width: 2
        radius: 3

        TextInput {
            id: timeInput
            text: "25:00"
            horizontalAlignment: TextInput.AlignHCenter
            font.pixelSize: 20
            font.family: "Segoe UI Light"
            anchors.fill: parent
            inputMask: "99:99"
        }
    }
}

