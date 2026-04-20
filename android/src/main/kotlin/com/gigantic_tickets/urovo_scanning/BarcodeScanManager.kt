package com.gigantic_tickets.urovo_scanning

import Code
import android.content.IntentFilter
import android.device.ScanManager
import android.device.ScanManager.ACTION_DECODE
import android.device.scanner.configuration.PropertyID
import android.device.scanner.configuration.Symbology
import android.device.scanner.configuration.Triggering

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
        //reset the scanner to send results in an intent
        scanManager.switchOutputMode(0)
        closeScanner()
        //did the plugin successfully reset the scanner
        return result
    }

    fun getTimeout() : Int {
        openScanner()

        val index = intArrayOf(PropertyID.LASER_ON_TIME)
        val value: IntArray? = scanManager.getParameterInts(index)

        val time = value?.firstOrNull() ?: 0
        return time
    }

    fun setTimeout(timeout : Int) : Boolean {
        openScanner()

        val index = intArrayOf(PropertyID.LASER_ON_TIME)
        val result: Int = scanManager.setParameterInts(index, intArrayOf(timeout))

        return if (result == 0) {
            //successful
            true
        } else {
            //error occurred
            false
        }
    }

    fun getSoundSetting() : Int? {
        openScanner()

        //SEND_GOOD_READ_BEEP_ENABLE means that if the barcode
        //was read successfully and the result was send in a broadcast receiver
        //then the device should vibrate
        val index = intArrayOf(PropertyID.SEND_GOOD_READ_BEEP_ENABLE)
        val value: IntArray? = scanManager.getParameterInts(index)

        //0 : None
        //1 : Short
        //2 : Sharp

        return value?.firstOrNull()
    }

    fun setSoundMode(mode : Int) : Boolean {
        openScanner()

        val index = intArrayOf(PropertyID.SEND_GOOD_READ_BEEP_ENABLE)
        val result: Int = scanManager.setParameterInts(index, intArrayOf(mode))

        return if (result == 0) {
            //successful
            true
        } else {
            //error occurred
            false
        }
    }

    fun isVibrationEnabled() : Boolean {

        openScanner()

        //SEND_GOOD_READ_VIBRATE_ENABLE means that if the barcode
        //was read successfully and the result was send in a broadcast receiver
        //then the device should vibrate
        val index = intArrayOf(PropertyID.SEND_GOOD_READ_VIBRATE_ENABLE)
        val value: IntArray? = scanManager.getParameterInts(index)

        //0 is disbaled
        //1 is enabled
        return value?.firstOrNull() == 1
    }

    fun enableVibration() : Boolean {
        openScanner()

        val index = intArrayOf(PropertyID.SEND_GOOD_READ_VIBRATE_ENABLE)
        val result: Int = scanManager.setParameterInts(index, intArrayOf(1))

        return if (result == 0) {
            //successful
            true
        } else {
            //error occurred
            false
        }
    }

    fun disableVibration() : Boolean {
        openScanner()

        val index = intArrayOf(PropertyID.SEND_GOOD_READ_VIBRATE_ENABLE)
        val result: Int = scanManager.setParameterInts(index, intArrayOf(0))

        return if (result == 0) {
            //successful
            true
        } else {
            //error occurred
            false
        }
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

    fun getTriggerMode() : Int? {
        openScanner()
        val mode: Triggering? = scanManager.getTriggerMode()

        //0: pulse
        //1: Continuous
        //2: Host

        return mode?.ordinal
    }

    fun setTriggerMode(mode : Int) {
        openScanner()

        val triggerMode = Triggering.values().get(mode)

        scanManager.setTriggerMode(triggerMode)
    }

    fun getAllSymbology() : List<Code> {
        val symbologyCodes = mutableListOf<Code>()
        openScanner()

        val codes = Symbology.values().asList()

        for (code in codes) {
            val newCode = convertSymbology(code)
            if (newCode != null) {
                symbologyCodes.add(newCode)
            }
        }

        return  symbologyCodes.toList()
    }

    private fun convertSymbology(symbol : Symbology) : Code? {

        if (symbol == null) {
            return null
        }

        val isSupported = scanManager.isSymbologySupported(symbol)
        val isEnabled = scanManager.isSymbologyEnabled(symbol)

        val id = symbol.ordinal.toLong()
        val type = symbol.name
        return  Code(id, type, isSupported, isEnabled)
    }

    fun getSymbology(id : Int) : Code? {
        openScanner()
        val symbol =
            Symbology.values().firstOrNull { code -> code.ordinal == id }

        if (symbol == null) {
            return null
        }
        return convertSymbology(symbol)
    }

    fun enableSymbology(id : Int) {
        val symbology = getValidSymbology(id)
        if (symbology != null) {
            scanManager.enableSymbology(symbology, true)
        }
    }

    fun enableAllSymbology() {
        openScanner()
        scanManager.enableAllSymbologies(true)
    }

    fun disableSymbology(id : Int) {
        val symbology = getValidSymbology(id)
        if (symbology != null) {
            scanManager.enableSymbology(symbology, false)
        }
    }

    fun disableAllSymbology() {
        openScanner()
        scanManager.enableAllSymbologies(false)
    }

    private fun getValidSymbology(id: Int) : Symbology? {
        openScanner()
        val found = Symbology.values().firstOrNull { code -> code.ordinal == id }

        return if (found == null) {
            null
        } else {
            val isSupported = scanManager.isSymbologySupported(found)
            if (isSupported) {
                found
            } else {
                null
            }
        }
    }

}