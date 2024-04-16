/*
** Copyright (C) 2024 Victron Energy B.V.
** See LICENSE.txt for license information.
*/

import QtQuick
import QtQuick.Controls as C
import Victron.VenusOS

Page {
	id: root

	required property string navButtonText
	required property url navButtonIcon
	required property url url
	required property SwipeView view

	// Allow animations if this is the current page, or when dragging between pages
	animationEnabled: defaultAnimationEnabled && visible

	// Only set visible=true when the page is within the visible area of the SwipeView.
	// (This also helps to avoid QTBUG-115468.)
	visible: Global.mainView && Global.mainView.swipeView.pageInView(x, width, Theme.geometry_page_content_horizontalMargin)
}
