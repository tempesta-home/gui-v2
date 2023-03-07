/*
** Copyright (C) 2022 Victron Energy B.V.
*/

import QtQuick
import Victron.VenusOS

ListItem {
	id: root

	property alias dataSource: dataPoint.source
	readonly property alias dataValue: dataPoint.value
	readonly property alias dataValid: dataPoint.valid
	function setDataValue(v) { dataPoint.setValue(v) }

	property alias secondaryText: secondaryLabel.text

	content.children: [
		Label {
			id: secondaryLabel

			anchors.verticalCenter: parent.verticalCenter
			width: Math.min(implicitWidth, root.maximumContentWidth)
			height: implicitHeight + Theme.geometry.listItem.content.verticalMargin * 2
			visible: root.secondaryText.length > 0
			text: dataValue || ""
			font.pixelSize: Theme.font.size.body2
			color: Theme.color.listItem.secondaryText
			wrapMode: Text.Wrap
			horizontalAlignment: Text.AlignRight
			verticalAlignment: Text.AlignVCenter
		}
	]

	DataPoint {
		id: dataPoint
	}
}