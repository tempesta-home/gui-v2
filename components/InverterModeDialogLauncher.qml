/*
** Copyright (C) 2024 Victron Energy B.V.
** See LICENSE.txt for license information.
*/

import QtQuick
import Victron.VenusOS

QtObject {
	id: root

	property string serviceUid

	readonly property string modeText: _isInverterChargerItem.value === 1
			? Global.inverterChargers.inverterChargerModeToText(_modeItem.value)
			: Global.inverterChargers.inverterModeToText(_modeItem.value)

	readonly property bool isMulti: _numberOfAcInputs.value === undefined ? false : (_numberOfAcInputs.value > 0)

	property VeQuickItem _isInverterChargerItem: VeQuickItem {
		uid: root.serviceUid + "/IsInverterCharger"
	}

	property VeQuickItem _modeItem: VeQuickItem {
		uid: root.serviceUid + "/Mode"
	}

	readonly property VeQuickItem _numberOfAcInputs: VeQuickItem {
		uid: root.serviceUid + "/Ac/NumberOfAcInputs"
	}

	property Component _inverterModeDialogComponent: Component {
		InverterModeDialog {
			onAccepted: root._modeItem.setValue(mode)
		}
	}

	property Component _inverterChargerModeDialogComponent: Component {
		InverterChargerModeDialog {
			isMulti: root.isMulti
			onAccepted: root._modeItem.setValue(mode)
		}
	}

	function openDialog() {
		if (_isInverterChargerItem.value === 1) {
			Global.dialogLayer.open(_inverterChargerModeDialogComponent)
		} else {
			Global.dialogLayer.open(_inverterModeDialogComponent)
		}
	}
}
