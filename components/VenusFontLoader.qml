/*
** Copyright (C) 2023 Victron Energy B.V.
** See LICENSE.txt for license information.
*/

import QtQuick
import Victron.VenusOS

FontLoader {
	source: Language.fontFileUrl
	onStatusChanged: console.log("Font status:", status)
}
