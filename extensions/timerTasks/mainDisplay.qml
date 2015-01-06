import QtQuick 2.0

Text {
    id: mainDisplay
    text: qsTr("00:00:00")
    font.pointSize: 70
    width: parent.width
    height: text.height
    horizontalAlignment: Text.AlignHCenter
    anchors.bottom: currentTask.top
    smooth: true
    font.italic: false    
}
