import QtQuick 2.3
import QtQml.Models 2.1
import Sonetta 0.1
import Navigation 0.1

import "../common"

FocusScope {
    id: root
    width: 100
    height: 100

    states: [
        State {
            name: "playback"
            PropertyChanges { target: pager; currentIndex: 0 }
            PropertyChanges { target: mainMenu; currentIndex: 0 }
            PropertyChanges { target: topRow; opacity: 0 }
            PropertyChanges { target: rightSeparator; opacity: 0 }
            PropertyChanges { target: playbackPage; opacity: 1 }
            PropertyChanges { target: playlistsPage; opacity: 0 }
            PropertyChanges { target: explorePage; opacity: 0 }
            PropertyChanges { target: settingsPage; opacity: 0 }
        },
        State {
            name: "playlists"
            PropertyChanges { target: pager; currentIndex: 1 }
            PropertyChanges { target: mainMenu; currentIndex: 1 }
            PropertyChanges { target: playlistsPage; state: "container" }
            PropertyChanges { target: topRow; opacity: 1 }
            PropertyChanges { target: rightSeparator; opacity: 1 }
            PropertyChanges { target: playbackPage; opacity: 0 }
            PropertyChanges { target: playlistsPage; opacity: 1 }
            PropertyChanges { target: explorePage; opacity: 0 }
            PropertyChanges { target: settingsPage; opacity: 0 }
        },
        State {
            name: "playlist"
            PropertyChanges { target: pager; currentIndex: 1 }
            PropertyChanges { target: mainMenu; currentIndex: 1 }
            PropertyChanges { target: playlistsPage; state: "playlist" }
            PropertyChanges { target: topRow; opacity: 1 }
            PropertyChanges { target: rightSeparator; opacity: 1 }
            PropertyChanges { target: playbackPage; opacity: 0 }
            PropertyChanges { target: playlistsPage; opacity: 1 }
            PropertyChanges { target: explorePage; opacity: 0 }
            PropertyChanges { target: settingsPage; opacity: 0 }
        },
        State {
            name: "explore"
            PropertyChanges { target: pager; currentIndex: 2 }
            PropertyChanges { target: mainMenu; currentIndex: 2 }
            PropertyChanges { target: topRow; opacity: 1 }
            PropertyChanges { target: rightSeparator; opacity: 1 }
            PropertyChanges { target: playbackPage; opacity: 0 }
            PropertyChanges { target: playlistsPage; opacity: 0 }
            PropertyChanges { target: explorePage; opacity: 1 }
            PropertyChanges { target: settingsPage; opacity: 0 }
        },
        State {
            name: "settings"
            PropertyChanges { target: pager; currentIndex: 3 }
            PropertyChanges { target: mainMenu; currentIndex: 3 }
            PropertyChanges { target: topRow; opacity: 1 }
            PropertyChanges { target: rightSeparator; opacity: 1 }
            PropertyChanges { target: playbackPage; opacity: 0 }
            PropertyChanges { target: playlistsPage; opacity: 0 }
            PropertyChanges { target: explorePage; opacity: 0 }
            PropertyChanges { target: settingsPage; opacity: 1 }
        }
    ]
    state: controller.initialStateName

    transitions: Transition {
        SmoothedAnimation { property: "opacity"; duration: UI.timing.highlightMove; velocity: -1 }
    }

    Pattern {
        id: logoContainer
        pattern: "dark"
        anchors {
            top: root.top
            left: root.left
            right: leftColumn.right
            bottom: topRow.bottom
        }

        Image {
            id: logo
            source: "../images/sonetta_small.png"
            fillMode: Image.PreserveAspectFit
            anchors {
                fill: logoContainer
                margins: UI.globalSpacing
            }
        }
    }

    Rectangle {
        id: leftSeparator
        color: UI.colors.light
        height: 1
        anchors {
            left: logoContainer.left
            right: logoContainer.right
            top: logoContainer.bottom
        }
    }

    Pattern {
        id: leftColumn

        width: 250
        pattern: "dark"
        anchors {
            left: root.left
            top: leftSeparator.bottom
            bottom: root.bottom
        }

        MainMenu {
            id: mainMenu
            focus: true
            anchors {
                fill: leftColumn
            }

            onPlaybackRequested: controller.playback()
            onPlaylistsRequested: controller.playlistsOverview()
            onExploreRequested: controller.explore()
            onSettingsRequested: controller.settings()
        }

        KeyNavigation.right: pager
    }

    Rectangle {
        id: rightSeparator
        height: 1
        color: UI.colors.dark
        anchors {
            left: topRow.left
            right: topRow.right
            top: topRow.bottom
        }
    }

    PageView {
        id: pager
        anchors {
            left: leftColumn.right
            right: root.right
            top: root.top
            bottom: root.bottom
        }
        clip: true
        scrollAnimationTime: UI.timing.highlightMove

        model: ObjectModel {
            PlaybackPage {
                id: playbackPage
                width: pager.width
                height: pager.height
                focus: true
            }

            PlaylistsPage {
                id: playlistsPage
                width: pager.width
                height: pager.height
                focus: true

                onPlaylistRequested: controller.playlist(index)
            }

            ExplorePage {
                id: explorePage
                width: pager.width
                height: pager.height
                focus: true
            }

            SettingsPage {
                id: settingsPage
                width: pager.width
                height: pager.height
                focus: true
            }
        }

        KeyNavigation.left: mainMenu
    }

    Pattern {
        id: topRow
        height: childrenRect.height + 2 * UI.globalSpacing
        pattern: "light"
        anchors {
            left: leftColumn.right
            right: root.right
            top: root.top
        }

        NowPlaying {
            anchors {
                left: topRow.left
                top: topRow.top
                right: topRow.right
                margins: UI.globalSpacing
            }
        }

        Binding {
            target: UI
            property: "pageTopMargin"
            value: topRow.height + rightSeparator.height
        }
    }

    SessionStateController {
        id: controller

        onPlaybackRequested: root.state = "playback"
        onPlaylistsOverviewRequested: root.state = "playlists"
        onExploreRequested: root.state = "explore"
        onSettingsRequested: root.state = "settings"

        onPlaylistRequested: {
            playlistsPage.index = index
            root.state = "playlist"
        }
    }

    Navigation.onBack: if (!event.autoRepeat) controller.back()
}
