/*
** Copyright (C) 2021 Victron Energy B.V.
*/

import QtQuick
import Victron.VenusOS
import "/components/Utils.js" as Utils

Page {
	id: root

	SettingsListView {
		id: settingsListView

		model: ObjectModel {

			SettingsListRadioButtonGroup {
				id: loggerMode
				//% "Logging enabled"
				text: qsTrId("settings_logging_enabled")
				source: "com.victronenergy.settings/Settings/Vrmlogger/Logmode"
				model: [
					//% "Disabled"
					{ display: qsTrId("settings_logging_option_disabled"),	value: 0 },
					//% "Enabled"
					{ display: qsTrId("settings_logging_option_enabled"),	value: 1 },
				]
			}

			SettingsListTextItem {
				//% "VRM Portal ID"
				text: qsTrId("settings_vrm_portal_id")
				secondaryText: "TODO" // this depends on VePlatform, it returns the first line of /etc/venus/unique-id. Not sure how to handle it yet.
			}

			SettingsListRadioButtonGroup {
				//% "Log interval"
				text: qsTrId("settings_log_interval")
				model: [
					//% "1 min"
					{ display: qsTrId("settings_1_min"), value: 60 },
					//% "5 min"
					{ display: qsTrId("settings_5_min"), value: 300 },
					//% "10 min"
					{ display: qsTrId("settings_10_min"), value: 600 },
					//% "15 min"
					{ display: qsTrId("settings_15_min"), value: 900 },
					//% "30 min"
					{ display: qsTrId("settings_30_min"), value: 1800 },
					//% "1 hour"
					{ display: qsTrId("settings_1_hr"), value: 3600 },
					//% "2 hours"
					{ display: qsTrId("settings_2_hr"), value: 7200 },
					//% "4 hours"
					{ display: qsTrId("settings_4_hr"), value: 14400 },
					//% "12 hours"
					{ display: qsTrId("settings_12_hr"), value: 43200 },
					//% "1 day"
					{ display: qsTrId("settings_1_day"), value: 86400 },
				]
				source: "com.victronenergy.settings/Settings/Vrmlogger/LogInterval"
				visible: !!loggerMode.dataPoint.value && loggerMode.dataPoint.value > 0
			}

			SettingsListSwitch {
				//% "Use secure connection (HTTPS)"
				text: qsTrId("settings_https_enabled")
				source: "com.victronenergy.settings/Settings/Vrmlogger/HttpsEnabled"
			}

			SettingsListTextItem {
				//% "Last contact"
				text: qsTrId("settings_last_contact")
				source: "com.victronenergy.logger/Vrm/TimeLastContact"
				visible: !!loggerMode.dataPoint.value && loggerMode.dataPoint.value > 0

				Timer {
					interval: 1000
					running: parent.visible
					repeat: true
					triggeredOnStart: true
					onTriggered: parent.secondaryText = Utils.timeAgo(parent.dataPoint.value)
				}
			}

			SettingsListTextItem {
				function stringForErrorCode(errorCode) {
					switch (errorCode) {
					case 0:
						//% "No error"
						return qsTrId("settings_connection_no_error")
					case 150:
						//% "#150 Unexpected response text"
						return qsTrId("settings_connection_error_150")
					case 151:
						//% "#151 Unexpected HTTP response"
						return qsTrId("settings_connection_error_151")
					case 152:
						//% "#152 Connection timeout"
						return qsTrId("settings_connection_error_152")
					case 153:
						//% "#153 Connection error"
						return qsTrId("settings_connection_error_153")
					case 154:
						//% "#154 DNS failure"
						return qsTrId("settings_connection_error_154")
					case 155:
						//% "#155 Routing error"
						return qsTrId("settings_connection_error_155")
					case 156:
						//% "#156 VRM unavailable"
						return qsTrId("settings_connection_error_156")
					case 157:
						//% "#159 Unknown error"
						return qsTrId("settings_connection_error_157")
					default:
						return ""
					}
				}
				//% "Connection error"
				text: qsTrId("settings_connection_error")
				secondaryText: stringForErrorCode(dataPoint.value)
				source: "com.victronenergy.logger/Vrm/ConnectionError"
			}

			SettingsListItem {
				//% "Error message: \n%1"
				text: qsTrId("settings_vrm_error_message").arg(errorMessage.value)
				visible: !!errorMessage.value

				DataPoint {
					id: errorMessage
					source: "com.victronenergy.logger/Vrm/ConnectionErrorMessage"
				}
			}

			SettingsListSwitch {
				//% "VRM two-way communication"
				text: qsTrId("settings_vrm_communication")
				source: "com.victronenergy.settings/Settings/Services/MqttVrm"
			}

			SettingsListSwitch {
				//% "Reboot device when no contact"
				text: qsTrId("settings_no_contact_reboot")
				source: "com.victronenergy.settings/Settings/Watchdog/VrmTimeout"
				updateOnClick: false
				checked: dataPoint.value !== 0
				onClicked: dataPoint.setValue(checked ? 0 : 3600)
			}

			SettingsListTimeSelector {
				source: "com.victronenergy.settings/Settings/Watchdog/VrmTimeout"
				//% "No contact reset delay (hh:mm)"
				text: qsTrId("settings_vrm_no_contact_reset_delay")
				visible: !!dataPoint.value && dataPoint.value > 0
			}

			SettingsListRadioButtonGroup {
				//% "Storage location"
				text: qsTrId("settings_vrm_storage_location")
				//% "No buffer active"
				defaultSecondaryText: qsTrId("settings_vrm_no_buffer_active")
				model: [
					//% "Internal storage"
					{ display: qsTrId("settings_vrm_internal_storage"), value: 0 },
					//% "Transferring"
					{ display: qsTrId("settings_vrm_transferring"), value: 1 },
					//% "External storage"
					{ display: qsTrId("settings_vrm_external_storage"), value: 2 },
				]
				source: "com.victronenergy.logger/Buffer/Location"
				enabled: dataPoint.value !== undefined
			}

			SettingsListRadioButtonGroup {
				//% "Error"
				text: qsTrId("settings_vrm_error")
				//% "Unknown error"
				defaultSecondaryText: qsTrId("settings_vrm_unknown_error")
				model: [
					//% "No Error"
					{ display: qsTrId("settings_vrm_no_error"), value: 0 },
					//% "No space left on storage"
					{ display: qsTrId("settings_vrm_no_space_error"), value: 1 },
					//% "IO error"
					{ display: qsTrId("settings_vrm_io_error"), value: 2 },
					//% "Mount error"
					{ display: qsTrId("settings_vrm_mount_error"), value: 3 },
					//% "Contains firmware image. Not using."
					{ display: qsTrId("settings_vrm_storage_contains_firmware_error"), value: 4 },
					//% "SD card / USB stick not writable"
					{ display: qsTrId("settings_vrm_storage_not_writable_error"), value: 5 },
				]
				enabled: false
				source: "com.victronenergy.logger/Buffer/ErrorState"
				visible: !!dataPoint.value
			}

			SettingsListTextItem { // This 'flickers' between values for ~30s after inserting a usb stick. Dbus-spy shows that the underlying data point flickers also. Old gui also flickers.
				//% "Free disk space"
				text: qsTrId("settings_vrm_free_disk_space")
				secondaryText: Utils.qtyToString(dataPoint.value,
												 //% "byte"
												 qsTrId("settings_vrm_byte"),
												 //% "bytes"
												 qsTrId("settings_vrm_bytes"))
				source: "com.victronenergy.logger/Buffer/FreeDiskSpace"
			}

			SettingsListButton {
				function mountStateToText(s)
				{
					switch (s) {
					case VenusOS.PageSettingsLogger_Mounted:
						//% "Press to eject"
						return qsTrId("settings_vrm_press_to_eject")
					case VenusOS.PageSettingsLogger_UnmountRequested:
					case VenusOS.PageSettingsLogger_UnmountBusy:
						//% "Ejecting, please wait"
						return qsTrId("settings_vrm_ejecting")
					default:
						//% "No storage found"
						return qsTrId("settings_vrm_no_storage_found");
					}
				}

				//% "microSD / USB"
				text: qsTrId("settings_vrm_microsd_usb")
				button.text: mountStateToText(mountState.value)
				button.enabled: mountState.value === VenusOS.PageSettingsLogger_Mounted
				onClicked: mountState.setValue(VenusOS.PageSettingsLogger_UnmountRequested)

				DataPoint {
					id: mountState
					source: "com.victronenergy.logger/Storage/MountState"
				}
			}

			SettingsListTextItem {
				//% "Stored records"
				text: qsTrId("settings_vrm_stored_records")
				source: "com.victronenergy.logger/Buffer/Count"
				//% "%1 records"
				secondaryText: qsTrId("settings_vrm_records_count").arg(dataPoint.value ? dataPoint.value : 0)
			}

			SettingsListTextItem {
				id: oldestBacklogItemAge

				property var timeNow: Math.round(new Date() / 1000)
				//% "Oldest record age"
				text: qsTrId("settings_vrm_oldest_record_age")
				source: "com.victronenergy.logger/Buffer/OldestTimestamp"

				Timer {
					interval: 1000
					running: !!parent.dataPoint.value
					repeat: true
					triggeredOnStart: true
					onTriggered: parent.secondaryText = Utils.timeAgo(parent.dataPoint.value)
				}
			}
		}
	}
}