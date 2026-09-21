package com.gigantic_tickets.urovo_scanning

import Code
import android.device.ScanManager
import android.device.scanner.configuration.PropertyID
import android.device.scanner.configuration.Symbology
import android.device.scanner.configuration.Triggering

//urovo scanner developer manual https://en.urovo.com/developer/index.html
class BarcodeScanManager {

    private val scanManager = ScanManager()

    fun openScanner() {
        val powerOn = scanManager.scannerState
        if (!powerOn) {
            val successfullyOpened = scanManager.openScanner()
            if (!successfullyOpened) {
                throw Exception("unable to open scanner")
            }
        }
    }

    fun closeScanner() {
        val powerOn = scanManager.scannerState
        if (powerOn) {
            val successfullyClosed = scanManager.closeScanner()
            if (!successfullyClosed) {
                throw Exception("unable to close scanner")
            }
        }
    }

    fun getScannerStatus() : Boolean {
        val powerOn = scanManager.scannerState
        return powerOn
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

    fun getParameterValue(parameterId : Int) : Int {
        openScanner()

        val index = intArrayOf(parameterId)
        val found: IntArray? = scanManager.getParameterInts(index)
        val parameterValue = found?.firstOrNull() ?: 0

        if (found == null) {
            throw Exception("unable to get parameter value")
        }
        return parameterValue
    }

    fun setParameterValue(parameterId : Int, parameterValue: Int) {
        openScanner()

        val index = intArrayOf(parameterId)
        val setDisableVibrationSuccessful: Int =
            scanManager.setParameterInts(index, intArrayOf(parameterValue))

        if (setDisableVibrationSuccessful == 0) {
            //successful
        } else {
            throw Exception("unable to set parameter value")
        }
    }

}