/*
** Copyright (C) 2021 Victron Energy B.V.
*/

import QtQuick
import Victron.VenusOS

ModalDialog {
	id: root

	property int currentLimit
	property int inputType
	property alias ampOptions: buttonRow.model

	title: Global.acInputs.currentLimitTypeToText(inputType)

	contentItem: Item {
		anchors {
			left: parent.left
			right: parent.right
			top: parent.header.bottom
			bottom: parent.footer.top
		}

		Column {
			id: contentColumn

			anchors.verticalCenter: parent.verticalCenter
			width: parent.width

			spacing: Theme.geometry.modalDialog.content.spacing

			SpinBox {
				id: spinbox

				width: parent.width - 2*Theme.geometry.modalDialog.content.horizontalMargin
				anchors.horizontalCenter: parent.horizontalCenter
				stepSize: 100 // mA
				to: 1000000 // mA
				indicatorImplicitWidth: Theme.geometry.spinBox.indicator.maximumWidth
				//% "%1 A"
				label.text: qsTrId("inverter_current_limit_value").arg(spinbox.value/1000)  // TODO use UnitConverter.convertToString() or unitToString() instead
				value: root.currentLimit
				onValueChanged: root.currentLimit = value
			}

			SegmentedButtonRow {
				id: buttonRow

				width: spinbox.width
				anchors.horizontalCenter: parent.horizontalCenter
				onButtonClicked: function (buttonIndex){
					currentIndex = buttonIndex
					root.currentLimit = model[currentIndex] * 1000 // mA
					spinbox.value = model[currentIndex] * 1000 // mA
				}
			}
		}
	}
}