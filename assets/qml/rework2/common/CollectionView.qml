import QtQuick 2.1
import Sonetta 0.1

/*

  - CollectionView:
  Provides a generic list component with a custom look and feel,
  intended to reduce repetition of QML code to achieve more or less
  the same look and feel across the entire interface.

  Usage: CollectionView provides look and feel in terms of alternating
         item backgrounds and highlight. Just provide a delegate (of type CollectionDelegate)
         that displays the content.
  */

FocusScope {
    id: root

    property Component delegate
    property alias model: list.model

    ListView {
        id: list
        anchors.fill: parent
        delegate: delegateComponent
        highlight: highlightComponent
        highlightFollowsCurrentItem: true
        highlightMoveDuration: ui.misc.globalAnimationTime
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        focus: true
        interactive: false
        currentIndex: 0

        onCountChanged: console.log(count)

        Navigation.onDown: incrementCurrentIndex()
        Navigation.onUp: decrementCurrentIndex()
    }

    Component {
        id: highlightComponent

        Rectangle {
            width: list.currentItem.width
            height: list.currentItem.height
            color: ui.colors.highlight //root.activeFocus ? ui.colors.highlight : ui.colors.selected
        }
    }

    Component {
        id: delegateComponent

        FocusScope {
            id: delegateRoot
            width: delegateLoader.width
            height: delegateLoader.height

            property int modelIndex: index

            Image {
                anchors.fill: delegateRoot
                parent: list.contentItem
                z: -1

                source: "../images/dark.png"
                fillMode: Image.Tile
                visible: modelIndex % 2 == 0
            }

            Loader {
                id: delegateLoader
                sourceComponent: root.delegate

                property QtObject internalModelData: model
            }
        }
    }

}