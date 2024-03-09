/*
** Copyright (C) 2023 Victron Energy B.V.
** See LICENSE.txt for license information.
*/

import QtQuick
import Victron.VenusOS

DcInputWidget {
	id: root

	title: Global.dcInputs.inputTypeToText(VenusOS.DcInputs_InputType_Alternator)
	icon.source: "qrc:/images/alternator.svg"
	type: VenusOS.OverviewWidget_Type_Alternator
	detailUrl: "/pages/settings/devicelist/dc-in/PageAlternator.qml"
}
