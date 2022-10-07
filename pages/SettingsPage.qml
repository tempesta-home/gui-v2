/*
** Copyright (C) 2021 Victron Energy B.V.
*/

import QtQuick
import Victron.VenusOS

Page {
	id: root

	SettingsListView {
		id: settingsListView

		model: [
			{
				//% "General"
				text: qsTrId("settings_general"),
				page: "/pages/settings/PageSettingsGeneral.qml"
			},
			{
				//% "Date & Time"
				text: qsTrId("settings_date_and_time"),
				page: "/pages/settings/PageTzInfo.qml"
			},
			{
				//% "Remote Console"
				text: qsTrId("settings_remote_console"),
				page: "/pages/settings/PageSettingsRemoteConsole.qml"
			},
			{
				//% "System setup"
				text: qsTrId("settings_system_setup"),
				page: "/pages/settings/PageSettingsSystem.qml"
			},
			{
				//% "DVCC"
				text: qsTrId("settings_system_dvcc"),
				page: "/pages/settings/PageSettingsDvcc.qml"
			},
			{
				//% "Display & Language"
				text: qsTrId("settings_display_and_language"),
				page: "/pages/settings/PageSettingsDisplay.qml"
			},
			{
				//% "ESS"
				text: systemType.value === "Hub-4" ? systemType.value : qsTrId("settings_ess"),
				page: "/pages/settings/PageSettingsHub4.qml"
			},
			{
				// TODO remove this temporary page that demonstrates the settings UI
				text: "Demo settings page",
				page: "/pages/settings/PageSettingsDemo.qml"
			},
		]

		delegate: SettingsListNavigationItem {
			text: modelData.text
			onClicked: {
				Global.pageManager.pushPage(modelData.page, {"title": modelData.text})
			}
		}
	}

	DataPoint {
		id: systemType

		source: "com.victronenergy.system/SystemType"
	}
}
