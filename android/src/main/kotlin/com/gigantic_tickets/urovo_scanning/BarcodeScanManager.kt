package com.gigantic_tickets.urovo_scanning

import SymbologyCode
import TriggerMode
import android.content.IntentFilter
import android.device.ScanManager
import android.device.ScanManager.ACTION_DECODE
import android.device.scanner.configuration.PropertyID
import android.device.scanner.configuration.Triggering
import android.device.scanner.configuration.Symbology

//urovo scanner developer manual https://en.urovo.com/developer/index.html
class BarcodeScanManager {

    private val scanManager = ScanManager()

    private fun openScanner() {
        val powerOn = scanManager.scannerState
        if (!powerOn) {
            scanManager.openScanner()
        }
    }

    private fun closeScanner() {
        val powerOn = scanManager.scannerState
        if (powerOn) {
            scanManager.closeScanner()
        }
    }

    //start listening to barcode scanning events
    fun startListening() {
        openScanner()
        //set result of scans to be sent to an intent
        scanManager.switchOutputMode(0)
    }

    fun stopListening() {
        closeScanner()
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

    fun start() : Boolean {
        openScanner()
        val decoding: Boolean = scanManager.startDecode()

        //if decoding is true then the device has successfully turned
        //on the scanner. If not the scanner failed
        return decoding
    }

    fun stop() : Boolean {
        openScanner()
        val result = scanManager.stopDecode()
        closeScanner()
        //did the plugin successfully stop decoding
        return result
    }

    fun reset() : Boolean {
        openScanner()
        val result = scanManager.resetScannerParameters()
        closeScanner()
        //did the plugin successfully reset the scanner
        return result
    }

    fun isTriggerLocked() : Boolean {
        openScanner()
        //if true then the scan trigger buttons are enabled
        return scanManager.getTriggerLockState()
    }

    fun enableTrigger() : Boolean {
        openScanner()
        return scanManager.unlockTrigger()
    }

    fun disableTrigger() : Boolean {
        openScanner()
        return scanManager.lockTrigger()
    }

    fun getTriggerMode() : TriggerMode {
        openScanner()
        val mode: Triggering? = scanManager.getTriggerMode()

        return when (mode) {
            Triggering.HOST -> {
                TriggerMode.HOST
            }
            Triggering.PULSE -> {
                TriggerMode.PULSE
            }
            Triggering.CONTINUOUS -> {
                TriggerMode.CONTINUOUS
            }
            else -> {
                TriggerMode.HOST
            }
        }
    }

    fun setTriggerMode(mode : TriggerMode) {
        openScanner()
        val triggerMode : Triggering
        when (mode) {
            TriggerMode.HOST -> {
                triggerMode = Triggering.HOST
            }
            TriggerMode.PULSE -> {
                triggerMode = Triggering.PULSE
            }
            TriggerMode.CONTINUOUS -> {
                triggerMode = Triggering.CONTINUOUS
            }
        }
        scanManager.setTriggerMode(triggerMode)
    }

    fun getSymbology() : List<SymbologyCode> {
        val symbologyCodes = mutableListOf<SymbologyCode>()
        openScanner()

        val codes = Symbology.values().asList()

        for (code in codes) {
            val isSupported = scanManager.isSymbologySupported(code)

            if (isSupported) {
                val isEnabled = scanManager.isSymbologyEnabled(code)

                symbologyCodes.add(
                    SymbologyCode(
                        code.name,
                        code.ordinal.toLong(),
                        isEnabled)
                )
            }
        }

        return  symbologyCodes.toList()
    }

    fun enableSymbology(code : SymbologyCode) {
        val symbology = getValidSymbology(code)
        if (symbology != null) {
            scanManager.enableSymbology(symbology, true)
        }
    }

    fun disableSymbology(code : SymbologyCode) {
        val symbology = getValidSymbology(code)
        if (symbology != null) {
            scanManager.enableSymbology(symbology, false)
        }
    }

    private fun getValidSymbology(code: SymbologyCode) : Symbology? {
        openScanner()
        val found = Symbology.values().elementAtOrNull(code.index.toInt())

        if (found == null) {
            return null
        } else {
            val isSupported = scanManager.isSymbologySupported(found)
            if (isSupported) {
                return found
            } else {
                return null
            }
        }
    }

}