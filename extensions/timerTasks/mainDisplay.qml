import QtQuick 2.0

Text {
    id: timerDisplay
    objectName: "timerDisplay"
    text: "00.00"
    font.pointSize: 70
    font.family: "Courier"
    width: parent.width
    height: text.height
    horizontalAlignment: Text.AlignHCenter
    smooth: true
    font.italic: false    
}
