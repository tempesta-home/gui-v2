/*
** Copyright (C) 2021 Victron Energy B.V.
*/

import QtQuick
import QtQuick.Window
import QtQuick.Controls as C
import Victron.VenusOS

Page {
	id: root

	property int _loadedPages: 0

	title: navStack.currentItem ? navStack.currentItem.title : ""
	topLeftButton: navStack.depth > 1
			? VenusOS.StatusBar_LeftButton_Back
			: VenusOS.StatusBar_LeftButton_ControlsInactive
	topRightButton: navStack.currentItem
			? navStack.currentItem.topRightButton
			: VenusOS.StatusBar_RightButton_None
	backgroundColor: navStack.currentItem ? navStack.currentItem.backgroundColor : Theme.color.page.background
	fullScreenWhenIdle: navStack.currentItem ? navStack.currentItem.fullScreenWhenIdle : false

	Repeater {
		id: preloader // preload all of the pages to improve performance

		model: navBar.model
		Loader {
			y: root.height
			asynchronous: true
			source: url
			onStatusChanged: {
				if (status === Loader.Ready) {
					if (index === 0) {
						navStack.push(item)
					}
					_loadedPages++
					if (_loadedPages === navBar.model.count) {
						Global.allPagesLoaded = true
					}
				} else if (status === Loader.Error) {
					console.warn("Error preloading page: " + source.toString())
				} else {
					console.log("Preloading page: " + source.toString())
				}
			}
		}
	}

	Connections {
		target: Global.pageManager ? Global.pageManager.emitter : null

		function onPagePushRequested(obj, properties) {
			navStack.push(obj, properties)
		}

		function onPagePopRequested(toPage) {
			navStack.pop(toPage)
		}
	}

	C.StackView {
		id: navStack
		clip: true
		focus: Global.pageManager.currentPage === root

		anchors {
			left: parent.left
			right: parent.right
			top: parent.top
			bottom: navBar.top
		}

		// Fade new navigation pages in
		replaceEnter: Transition {
			enabled: Global.allPagesLoaded

			OpacityAnimator {
				from: 0.0
				to: 1.0
				easing.type: Easing.InOutQuad
				duration: 250
			}
		}
		replaceExit: Transition {
			enabled: Global.allPagesLoaded

			OpacityAnimator {
				from: 1.0
				to: 0.0
				easing.type: Easing.InOutQuad
				duration: 250
			}
		}
	}

	NavBar {
		id: navBar

		opacity: 0
		y: root.height

		model: ListModel {
			ListElement {
				//% "Brief"
				text: QT_TRID_NOOP("nav_brief")
				icon: "qrc:/images/brief.svg"
				url: "qrc:/pages/BriefPage.qml"
			}
			ListElement {
				//% "Overview"
				text: QT_TRID_NOOP("nav_overview")
				icon: "qrc:/images/overview.svg"
				url: "qrc:/pages/OverviewPage.qml"
			}
			ListElement {
				//% "Levels"
				text: QT_TRID_NOOP("nav_levels")
				icon: "qrc:/images/levels.svg"
				url: "qrc:/pages/LevelsPage.qml"
			}
			ListElement {
				//% "Notifications"
				text: QT_TRID_NOOP("nav_notifications")
				icon: "qrc:/images/notifications.svg"
				url: "qrc:/pages/NotificationsPage.qml"
			}
			ListElement {
				//% "Settings"
				text: QT_TRID_NOOP("nav_settings")
				icon: "qrc:/images/settings.png"
				url: "qrc:/pages/SettingsPage.qml"
			}
		}

		onCurrentIndexChanged: {
			navStack.replace(null, preloader.itemAt(currentIndex).item)
		}

		SequentialAnimation {
			running: !Global.splashScreenVisible

			PauseAnimation {
				duration: Theme.animation.navBar.initialize.delayedStart.duration
			}
			ParallelAnimation {
				NumberAnimation {
					target: navBar
					property: "y"
					from: root.height - navBar.height + Theme.geometry.navigationBar.initialize.margin
					to: root.height - navBar.height
					duration: Theme.animation.navBar.initialize.fade.duration
				}
				NumberAnimation {
					target: navBar
					property: "opacity"
					to: 1
					duration: Theme.animation.navBar.initialize.fade.duration
				}
			}
		}

		SequentialAnimation {
			id: animateNavBarIn

			running: Global.pageManager.interactivity === VenusOS.PageManager_InteractionMode_EndFullScreen
					 || Global.pageManager.interactivity === VenusOS.PageManager_InteractionMode_ExitIdleMode

			NumberAnimation {
				target: navBar
				property: "y"
				from: root.height
				to: root.height - navBar.height
				duration: Theme.animation.page.idleResize.duration
				easing.type: Easing.InOutQuad
			}
			ScriptAction {
				script: {
					Global.pageManager.interactivity = VenusOS.PageManager_InteractionMode_ExitIdleMode
				}
			}
			OpacityAnimator {
				target: navBar
				from: 0.0
				to: 1.0
				duration: Theme.animation.page.idleOpacity.duration
				easing.type: Easing.InOutQuad
			}
			ScriptAction {
				script: {
					Global.pageManager.interactivity = VenusOS.PageManager_InteractionMode_Interactive
				}
			}
		}

		SequentialAnimation {
			id: animateNavBarOut

			running: Global.pageManager.interactivity === VenusOS.PageManager_InteractionMode_EnterIdleMode
					 || Global.pageManager.interactivity === VenusOS.PageManager_InteractionMode_BeginFullScreen

			OpacityAnimator {
				target: navBar
				from: 1.0
				to: 0.0
				duration: Theme.animation.page.idleOpacity.duration
				easing.type: Easing.InOutQuad
			}
			ScriptAction {
				script: {
					Global.pageManager.interactivity = VenusOS.PageManager_InteractionMode_BeginFullScreen
				}
			}
			NumberAnimation {
				target: navBar
				property: "y"
				from: root.height - navBar.height
				to: root.height
				duration: Theme.animation.page.idleResize.duration
				easing.type: Easing.InOutQuad
			}
			ScriptAction {
				script: {
					Global.pageManager.interactivity = VenusOS.PageManager_InteractionMode_Idle
				}
			}
		}
	}

	Component.onCompleted: Global.pageManager.navBar = navBar
}