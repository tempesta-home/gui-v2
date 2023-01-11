/*
** Copyright (C) 2021 Victron Energy B.V.
*/

import QtQuick
import QtQuick.Templates as CT
import Victron.VenusOS

CT.RadioButton {
	id: root

	property alias label: label

	implicitWidth: Math.max(
		implicitBackgroundWidth + leftInset + rightInset,
		implicitContentWidth + leftPadding + rightPadding,
		implicitIndicatorWidth + leftPadding + rightPadding)
	implicitHeight: Math.max(
		implicitBackgroundHeight + topInset + bottomInset,
		implicitContentHeight + topPadding + bottomPadding,
		implicitIndicatorHeight + topPadding + bottomPadding)
	indicator: RadioButtonIndicator {
		anchors {
			right: parent.right
			verticalCenter: parent.verticalCenter
		}
		down: root.down
		checked: root.checked
	}
	contentItem: RadioButtonLabel {
		id: label
	}
}
