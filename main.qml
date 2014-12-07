

import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

ApplicationWindow {
    width: 448;
    height: 672;
    visible: true;
    color: white;

    TabView {
        height: parent.height
        width: parent.width

        style: TabViewStyle {
            frameOverlap: 1
            tab: Rectangle {
                color: styleData.selected ? "steelblue" :"lightsteelblue"
                border.color:  "steelblue"
                implicitWidth: Math.max(text.width + 4, 80)
                implicitHeight: 50
                radius: 2
                Text {
                    id: text
                    anchors.centerIn: parent
                    text: styleData.title
                    color: styleData.selected ? "white" : "black"
                }
            }
            frame: Rectangle { color: "steelblue" }
        }

        Tab {
            title: "Home"

            Rectangle {
                id: home
                color: "white"

                height: parent.height
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
