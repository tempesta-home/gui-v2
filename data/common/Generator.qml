/*
** Copyright (C) 2023 Victron Energy B.V.
*/

import QtQuick
import Victron.Veutil
import Victron.VenusOS
import "/components/Utils.js" as Utils

QtObject {
	id: generator

	property string serviceUid

	readonly property int state: _state.value === undefined ? -1 : _state.value
	readonly property bool autoStart: _autoStart.value === 1
	readonly property int manualStartTimer: _manualStartTimer.value === undefined ? -1 : _manualStartTimer.value
	readonly property int runtime: _runtime.value === undefined ? -1 : _runtime.value
	readonly property int runningBy: _runningBy.value === undefined ? -1 : _runningBy.value
	readonly property int deviceInstance: _deviceInstance.value === undefined ? -1 : _deviceInstance.value

	readonly property VeQuickItem _state: VeQuickItem {
		uid: serviceUid + "/State"
	}

	readonly property VeQuickItem _manualStart: VeQuickItem {
		uid: serviceUid + "/ManualStart"
	}

	readonly property VeQuickItem _manualStartTimer: VeQuickItem {
		uid: serviceUid + "/ManualStartTimer"
	}

	readonly property VeQuickItem _runtime: VeQuickItem {
		uid: serviceUid + "/Runtime"
	}

	readonly property VeQuickItem _runningBy: VeQuickItem {
		uid: serviceUid + "/RunningByConditionCode"
	}

	readonly property VeQuickItem _deviceInstance: VeQuickItem {
		uid: serviceUid + "/DeviceInstance"
		onValueChanged: Global.generators.refreshFirstGenerator()
	}

	readonly property VeQuickItem _autoStart: VeQuickItem {
		uid: serviceUid + "/AutoStartEnabled"
	}

	function start(durationSecs) {
		_manualStartTimer.setValue(durationSecs)
		_manualStart.setValue(1)
	}

	function stop() {
		_manualStart.setValue(0)
	}

	function setAutoStart(auto) {
		_autoStart.setValue(auto ? 1 : 0)
	}
}