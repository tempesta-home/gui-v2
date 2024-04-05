/*
** Copyright (C) 2023 Victron Energy B.V.
** See LICENSE.txt for license information.
*/

import QtQuick
import QtQuick.Controls.impl as CP
import Victron.VenusOS

Page {
	id: root

	property string serviceUid

	//% "VE.CAN devices"
	title: qsTrId("settings_vecan_devices")

	GradientListView {
		model: VeQItemTableModel {
			uids: [ root.serviceUid + "/Devices" ]
			flags: VeQItemTableModel.AddChildren | VeQItemTableModel.AddNonLeaves | VeQItemTableModel.DontAddItem
		}

		delegate: ListSpinBox {
			id: listDelegate

			text: "%1 [%2]".arg(customName.value || modelName.value).arg(uniqueNumber.value)
			//% "Device# %1"
			secondaryText: qsTrId("settings_vecan_device_number").arg(dataItem.value)
			dataItem.uid: model.uid + "/DeviceInstance"

			CP.ColorImage {
				parent: listDelegate.content
				anchors.verticalCenter: parent.verticalCenter
				source: "qrc:/images/icon_arrow_32.svg"
				rotation: 180
				color: listDelegate.containsPress ? Theme.color_listItem_down_forwardIcon : Theme.color_listItem_forwardIcon
			}

			ListPressArea {
				id: mouseArea

				parent: listDelegate.backgroundRect
				radius: listDelegate.backgroundRect.radius
				anchors.fill: parent
				onClicked: {
					Global.pageManager.pushPage("/pages/settings/PageSettingsVecanDevice.qml",
						{ bindPrefix: model.uid, title: text })
				}
			}

			VeQuickItem {
				id: modelName
				uid: model.uid + "/ModelName"
			}

			VeQuickItem {
				id: customName
				uid: model.uid + "/CustomName"
			}

			VeQuickItem {
				id: uniqueNumber
				uid: model.uid + "/N2kUniqueNumber"
			}
		}
	}
}
