/*
 * Copyright (C) 2024 Victron Energy B.V.
 * See LICENSE.txt for license information.
*/

import QtTest
import Victron.VenusOS

TestCase {
	name: "FirmwareVersionTest"

	function test_versionFormat() {
		compare(FirmwareVersion.versionFormat("VE.Bus"), "vebus")
		compare(FirmwareVersion.versionFormat("ve.bus"), undefined)
		compare(FirmwareVersion.versionFormat("something"), undefined)
		compare(FirmwareVersion.versionFormat(undefined), undefined)
	}

	function test_versionText_veBus() {
		// Sample of VE.Bus devices
		compare(FirmwareVersion.versionText(1282, "vebus"), "v502")
		compare(FirmwareVersion.versionText(1058, "vebus"), "v422")
	}

	function test_versionText_other() {
		// Test versions for VE.Direct/VE.Can/Generic devices.

		// Sample of VE.Direct devices
		compare(FirmwareVersion.versionText(776), "v3.08")
		compare(FirmwareVersion.versionText(297), "v1.29")
		compare(FirmwareVersion.versionText(353), "v1.61")

		// Sample of VE.Can devices
		compare(FirmwareVersion.versionText("v3.0.2V"), "v3.0.2V")
		compare(FirmwareVersion.versionText(68095), "v1.09")
		compare(FirmwareVersion.versionText(71433), "v1.17-beta-09")

		// Sample of generic devices
		compare(FirmwareVersion.versionText(345), "v1.59")
	}

	function test_version_none() {
		compare(FirmwareVersion.versionText(undefined), "")
	}
}
