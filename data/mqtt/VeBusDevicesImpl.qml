/*
** Copyright (C) 2021 Victron Energy B.V.
*/

import QtQuick
import Victron.VenusOS
import Victron.Veutil
import "../common"

QtObject {
	id: root

	property Instantiator vebusInverterObjects: Instantiator {
		model: VeQItemTableModel {
			uids: ["mqtt/vebus"]
			flags: VeQItemTableModel.AddChildren | VeQItemTableModel.AddNonLeaves | VeQItemTableModel.DontAddItem
		}

		delegate: VeBusDevice {
			serviceUid: model.uid
		}
	}

	property Instantiator multiRsInverterObjects: Instantiator {
		model: VeQItemTableModel {
			uids: ["mqtt/multi"]
			flags: VeQItemTableModel.AddChildren | VeQItemTableModel.AddNonLeaves | VeQItemTableModel.DontAddItem
		}

		delegate: VeBusDevice {
			serviceUid: model.uid
		}
	}
}