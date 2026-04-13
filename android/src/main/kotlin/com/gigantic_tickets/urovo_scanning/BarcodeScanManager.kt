package com.gigantic_tickets.urovo_scanning

import android.device.ScanManager
import android.content.IntentFilter
import android.device.ScanManager.ACTION_DECODE
import android.device.scanner.configuration.PropertyID

//urovo scanner developer manual https://en.urovo.com/developer/index.html
class BarcodeScanManager {

    private val scanManager = ScanManager()

    fun turnOnScanner() {
        val powerOn = scanManager.scannerState
        if (!powerOn) {
            scanManager.openScanner()
        }
        //send scan result to intent (broad case receiver)
        scanManager.switchOutputMode(0)
    }

    fun turnOffScanner() {
        val powerOn = scanManager.scannerState
        if (powerOn) {
            scanManager.closeScanner()
        }
    }

    fun getIntentFilter() : IntentFilter {

        val filter = IntentFilter()
        val idbuf = intArrayOf(
            PropertyID.WEDGE_INTENT_ACTION_NAME,
            PropertyID.WEDGE_INTENT_DATA_STRING_TAG
        )
        val value_buf: Array<String?> = scanManager.getParameterString(idbuf)
        if (value_buf[0] != null && value_buf[0] != "") {
            filter.addAction(value_buf[0])
        } else {
            filter.addAction(ACTION_DECODE)
        }

        return filter
    }


    fun suspensionButton() {

    }

    fun triggerType() {

    }

    fun setSound() {

    }

    fun setVibrate() {

    }

    fun setCodingFormat() {


    }

}