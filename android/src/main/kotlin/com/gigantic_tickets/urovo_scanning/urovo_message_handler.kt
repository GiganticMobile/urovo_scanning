package com.gigantic_tickets.urovo_scanning

import SymbologyCode
import TriggerMode
import UrovoMessageInterface
import java.util.Timer
import kotlin.concurrent.schedule
import android.util.Log
import java.util.TimerTask

class urovo_message_handler : UrovoMessageInterface {
    /*override fun test(callback: (Result<String>) -> Unit) {
        Log.i("UrovoScanningPlugin", "test method called")

        val deviceName: String? = android.os.Build.MODEL
        val deviceMan: String? = android.os.Build.MANUFACTURER
        Log.i("UrovoScanningPlugin", "device name $deviceName device manufacture $deviceMan")
        callback.invoke(Result.success("device name $deviceName device manufacture $deviceMan"))
    }*/
    override fun getDeviceManufacture(callback: (Result<String>) -> Unit) {
        //val deviceName: String? = android.os.Build.MODEL
        val deviceMan: String? = android.os.Build.MANUFACTURER
        callback.invoke(Result.success(deviceMan ?: ""))
    }

    //this timer task keeps track of the time the scanner has been on for
    private var scanningTimerTask : TimerTask? = null
    override fun startScanning(delay: Long?) {

        if (scanningTimerTask != null) {
            //scanner already running and needs to be stopped
            //before it can be restarted
            stopScanning()
        }

        val scanManager = BarcodeScanManager()
        val decoding = scanManager.start()

        if (decoding) {
            Log.d("MESSAGE_HANDLER", "start scanning")
            //if timer is already running then cancel it
            scanningTimerTask = Timer().schedule(delay ?: 5000) {
                //automatically stop the scanning after delay (which defaults to 5 seconds)
                //of inactivity. The device will automatically turn
                //off if it scans a barcode.
                Log.d("MESSAGE_HANDLER", "auto cancel scanning")
                scanManager.stop()
                scanningTimerTask = null
            }
        }
    }

    override fun stopScanning() {
        val scanManager = BarcodeScanManager()
        scanManager.stop()
        scanningTimerTask?.cancel()
        scanningTimerTask = null
    }

    override fun isTriggerEnabled(callback: (Result<Boolean>) -> Unit) {
        val scanManager = BarcodeScanManager()
        //enabled is unlocked (isTriggerLocked false
        val isTriggerLocked = !scanManager.isTriggerLocked()
        Log.d("MESSAGE_HANDLER", "is trigger locked $isTriggerLocked")
        callback.invoke(Result.success(isTriggerLocked))
    }

    override fun enableTrigger() {
        val scanManager = BarcodeScanManager()
        scanManager.enableTrigger()
    }

    override fun disableTrigger() {
        val scanManager = BarcodeScanManager()
        scanManager.disableTrigger()
    }

    override fun resetScanner() {
        val scanManager = BarcodeScanManager()
        scanManager.reset()
    }

    override fun getTriggerMode(callback: (Result<TriggerMode>) -> Unit) {
        val scanManager = BarcodeScanManager()
        val mode = scanManager.getTriggerMode()
        callback.invoke(Result.success(mode))
    }

    override fun setTriggerMode(mode: TriggerMode) {
        val scanManager = BarcodeScanManager()
        scanManager.setTriggerMode(mode)
    }

    override fun getSymbology(callback: (Result<List<SymbologyCode>>) -> Unit) {
        val scanManager = BarcodeScanManager()
        callback.invoke(Result.success(scanManager.getSymbology()))
    }

    override fun enableSymbology(code: SymbologyCode) {
        val scanManager = BarcodeScanManager()
        scanManager.enableSymbology(code)
    }

    override fun disableSymbology(code: SymbologyCode) {
        val scanManager = BarcodeScanManager()
        scanManager.disableSymbology(code)
    }

}