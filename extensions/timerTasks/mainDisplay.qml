import QtQuick 2.0

Text {
    id: timerDisplay
    text: "00:00:00"
    font.pointSize: 70
    width: parent.width
    height: text.height
    horizontalAlignment: Text.AlignHCenter
    anchors.bottom: currentTask.top
    smooth: true
    font.italic: false    
}
