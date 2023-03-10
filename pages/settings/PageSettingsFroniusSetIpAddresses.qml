/*
** Copyright (C) 2022 Victron Energy B.V.
*/

import QtQuick
import QtQuick.Controls as C
import Victron.VenusOS
import "/components/Utils.js" as Utils

ListPage {
	id: root

	property var _addDialog

	topRightButton: VenusOS.StatusBar_RightButton_Add

	listView: IpAddressListView {
		id: settingsListView
		ipAddresses.source: "com.victronenergy.settings/Settings/Fronius/IPAddresses"
	}

	Connections {
		target: Global.pageManager.statusBar
		enabled: root.isCurrentPage

		function onRightButtonClicked() {
			const addresses = settingsListView.ipAddresses.value ? settingsListView.ipAddresses.value.split(',') : []
			addresses.push("192.168.1.1")
			settingsListView.ipAddresses.setValue(addresses.join(','))
		}
	}
}


