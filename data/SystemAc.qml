/*
** Copyright (C) 2023 Victron Energy B.V.
** See LICENSE.txt for license information.
*/

import QtQuick
import Victron.VenusOS

QtObject {
	id: root

	property QtObject consumption: QtObject {
		property real power: NaN
		readonly property real current: phases.count === 1 ? _firstPhaseCurrent : NaN // multi-phase systems don't have a total current
		readonly property real maximumCurrent: _maximumCurrent.value === undefined ? NaN : _maximumCurrent.value
		property real _firstPhaseCurrent: NaN

		property ListModel phases: ListModel {}

		function setPhaseCount(phaseCount) {
			reset()
			for (let i = 0; i < phaseCount; ++i) {
				phases.append({
					name: "L" + (i + 1),
					power: NaN,
					current: NaN
				})
			}
		}

		function setPhaseData(index, data) {
			phases.set(index, data)

			// Update totals for the model.
			let totalPower = NaN
			for (let i = 0; i < consumption.phases.count; ++i) {
				const phaseData = i === index ? data : consumption.phases.get(i)
				if (!phaseData) {
					continue
				}
				totalPower = Units.sumRealNumbers(totalPower, phaseData.power)
			}
			power = totalPower
			if (index === 0) {
				_firstPhaseCurrent = data.current
			}
		}

		function reset() {
			phases.clear()
			power = NaN
			_firstPhaseCurrent = NaN
		}

		readonly property VeQuickItem _maximumCurrent: VeQuickItem {
			uid: Global.systemSettings.serviceUid + "/Settings/Gui/Gauges/NoAcIn/Consumption/Current/Max"
		}
	}

	function reset() {
		root.consumption.reset()
	}
}
