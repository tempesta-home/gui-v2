/*
** Copyright (C) 2023 Victron Energy B.V.
** See LICENSE.txt for license information.
*/

import QtQml
import Victron.VenusOS

BaseDevice {
	id: root

	property bool valid: _deviceInstance.isValid && _productId.isValid && _productName.isValid

	readonly property string customName: _customName.value || ""
	readonly property string productName: _productName.value || ""
	readonly property int productId: _productId.isValid ? _productId.value : 0

	readonly property VeQuickItem _deviceInstance: VeQuickItem {
		uid: root.serviceUid ? root.serviceUid + "/DeviceInstance" : ""
	}

	readonly property VeQuickItem _customName: VeQuickItem {
		uid: root.serviceUid ? root.serviceUid + "/CustomName" : ""
	}

	readonly property VeQuickItem _productId: VeQuickItem {
		uid: root.serviceUid ? root.serviceUid + "/ProductId" : ""
	}

	readonly property VeQuickItem _productName: VeQuickItem {
		uid: root.serviceUid ? root.serviceUid + "/ProductName" : ""
	}

	deviceInstance: _deviceInstance.value === undefined ? -1 : _deviceInstance.value
	name: _customName.value || _productName.value || ""
	description: name
}
