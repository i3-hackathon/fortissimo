import QtQuick 2.1
import Sonetta 0.1
import "../common"

FocusScope {
    id: root
    height: childrenRect.height
    width: childrenRect.width

    property alias label: inputlabel.text
    readonly property alias text: input.text

    signal complete

    Column {
        height: childrenRect.height
        width: childrenRect.width

        Label {
            id: inputlabel

            anchors {
                left: input.left
                right: input.right
            }
        }

        VirtualKeyboardInput {
            id: input
            collapsible: true
            focus: true

            onComplete: root.complete()
        }
    }
}
