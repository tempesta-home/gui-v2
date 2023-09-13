/*
** Copyright (C) 2021 Victron Energy B.V.
*/

import QtQuick
import Victron.VenusOS

Item {
	id: root

	readonly property bool _dataObjectsReady: !!Global.acInputs
			&& !!Global.acInputs
			&& !!Global.batteries
			&& !!Global.dcInputs
			&& !!Global.environmentInputs
			&& !!Global.ess
			&& !!Global.evChargers
			&& !!Global.generators
			&& !!Global.inverters
			&& !!Global.notifications
			&& !!Global.pvInverters
			&& !!Global.relays
			&& !!Global.solarChargers
			&& !!Global.system
			&& !!Global.systemSettings
			&& !!Global.tanks
			&& !!Global.venusPlatform

	readonly property bool _shouldInitialize: _dataObjectsReady
			&& BackendConnection.type !== BackendConnection.UnknownSource
			&& BackendConnection.state === BackendConnection.Ready

	function _setBackendSource() {
		if (!_shouldInitialize) {
			return
		}
		if (dataManagerLoader.active) {
			console.warn("Data manager source is already set to", dataManagerLoader.source,
				"cannot be changed after initialization")
			return
		}
		switch (BackendConnection.type) {
		case BackendConnection.DBusSource:
			console.warn("Loading D-Bus data backend...")
			dataManagerLoader.source = "qrc:/data/dbus/DBusDataManager.qml"
			break
		case BackendConnection.MqttSource:
			console.warn("Loading MQTT data backend...")
			dataManagerLoader.source = "qrc:/data/mqtt/MqttDataManager.qml"
			break
		case BackendConnection.MockSource:
			console.warn("Loading mock data backend...")
			dataManagerLoader.source = "qrc:/data/mock/MockDataManager.qml"
			break
		default:
			console.warn("Unsupported data backend!", BackendConnection.type)
			return
		}
		dataManagerLoader.active = true
	}

	on_ShouldInitializeChanged: _setBackendSource()

	Connections {
		target: BackendConnection

		function onTypeChanged() {
			_setBackendSource()
		}
	}

	// Global data types
	AcInputs {}
	Batteries {}
	DcInputs {}
	EnvironmentInputs {}
	Ess {}
	EvChargers {}
	Generators {}
	Inverters {}
	Notifications {}
	PvInverters {}
	Relays {}
	SolarChargers {}
	System {}
	SystemSettings {}
	Tanks {}
	VenusPlatform {}

	Loader {
		id: dataManagerLoader

		active: false
		asynchronous: true
		onStatusChanged: if (status === Loader.Error) console.warn("Unable to load data manager:", source)
		onLoaded: Global.dataManagerLoaded = true
	}
}
