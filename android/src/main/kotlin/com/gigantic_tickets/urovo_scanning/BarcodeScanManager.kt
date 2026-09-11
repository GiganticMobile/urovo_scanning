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
            val successfullyOpened = scanManager.openScanner()
            if (!successfullyOpened) {
                throw Exception("unable to open scanner")
            }
        }
    }

    private fun closeScanner() {
        val powerOn = scanManager.scannerState
        if (powerOn) {
            val successfullyClosed = scanManager.closeScanner()
            if (!successfullyClosed) {
                throw Exception("unable to close scanner")
            }
        }
    }

    //start listening to barcode scanning events
    fun startListening() {
        openScanner()
        /*
        mode - 0 if barcode output is to be sent as intent,
        1 if barcode output is to be sent to the text box in focus.
        The default output mode is TextBox Mode.
         */
        val successfullySwitch = scanManager.switchOutputMode(0)
        if (!successfullySwitch) {
            throw Exception("could not switch out put mode")
        }
    }

    fun stopListening() {
        /*
        There might be a better solution to this by checking if the
        device is a urovo device so can close the scanner.
        However, the scanner will automatically be closed when the timeout
        runs out.
         */
        //closeScanner()
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

    fun hasScanner() : Boolean {
        try {
            openScanner()
            closeScanner()

            //scanner opened and closed without error
            //so device should have scanner
            return true
        }  catch (_: Exception) {
            //opening or closing the scanner failed
            //this is most likely because the device
            //does not have a scanner
            return false
        }
    }

    fun start() {
        openScanner()
        val started: Boolean = scanManager.startDecode()

        //if stated is true then the device has successfully turned
        //on the scanner. If not the scanner failed
        if (!started) {
            throw Exception("unable to start scanner")
        }
    }

    fun stop() {
        openScanner()
        val stopped = scanManager.stopDecode()
        //closeScanner() may effect any streams if the scanner is suddenly closed
        if (!stopped) {
            throw Exception("unable to stop scanner")
        }
    }

    fun reset() {
        openScanner()
        val reset = scanManager.resetScannerParameters()
        //reset the scanner to send results in an intent
        scanManager.switchOutputMode(0)
        //closeScanner()
        if (!reset) {
            throw Exception("unable to reset scanner")
        }
    }

    fun getTimeout() : Int {
        openScanner()

        val index = intArrayOf(PropertyID.LASER_ON_TIME)
        val value: IntArray? = scanManager.getParameterInts(index)

        val time = value?.firstOrNull() ?: 0
        return time
    }

    fun setTimeout(timeout : Int) {
        openScanner()

        val index = intArrayOf(PropertyID.LASER_ON_TIME)
        val setTimeOutSuccessful: Int = scanManager.setParameterInts(index, intArrayOf(timeout))

        if (setTimeOutSuccessful == 0) {
            //success
        } else {
            throw Exception("unable to set time out")
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

    fun setSoundMode(mode : Int) {
        openScanner()

        val index = intArrayOf(PropertyID.SEND_GOOD_READ_BEEP_ENABLE)
        val setSoundSuccessful: Int = scanManager.setParameterInts(index, intArrayOf(mode))

        if (setSoundSuccessful == 0) {
            //success
        } else {
            throw Exception("unable to set sound")
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

    fun enableVibration() {
        openScanner()

        val index = intArrayOf(PropertyID.SEND_GOOD_READ_VIBRATE_ENABLE)
        val setEnableVibrationSuccessful: Int =
            scanManager.setParameterInts(index, intArrayOf(1))

        if (setEnableVibrationSuccessful == 0) {
            //successful
        } else {
            throw Exception("unable to enable vibration")
        }
    }

    fun disableVibration() {
        openScanner()

        val index = intArrayOf(PropertyID.SEND_GOOD_READ_VIBRATE_ENABLE)
        val setDisableVibrationSuccessful: Int =
            scanManager.setParameterInts(index, intArrayOf(0))

        if (setDisableVibrationSuccessful == 0) {
            //successful
        } else {
            throw Exception("unable to disable vibration")
        }
    }

    fun isTriggerLocked() : Boolean {
        openScanner()
        //if true then the scan trigger buttons are enabled
        return scanManager.getTriggerLockState()
    }

    fun enableTrigger() {
        openScanner()
        val enableTriggerSuccessful = scanManager.unlockTrigger()
        if (!enableTriggerSuccessful) {
            throw Exception("unable to enable trigger")
        }
    }

    fun disableTrigger() {
        openScanner()
        val disableTriggerSuccessful = scanManager.lockTrigger()
        if (!disableTriggerSuccessful) {
            throw Exception("unable to disable trigger")
        }
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

    private fun convertSymbology(symbol : Symbology?) : Code? {

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