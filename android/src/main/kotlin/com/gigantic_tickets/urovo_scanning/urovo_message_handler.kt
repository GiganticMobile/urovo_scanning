package com.gigantic_tickets.urovo_scanning

import SoundMode
import SymbologyCode
import TriggerMode
import UrovoMessageInterface
import android.util.Log

class urovo_message_handler : UrovoMessageInterface {

    override fun getDeviceManufacture(callback: (Result<String>) -> Unit) {
        //val deviceName: String? = android.os.Build.MODEL
        val deviceMan: String? = android.os.Build.MANUFACTURER
        callback.invoke(Result.success(deviceMan ?: ""))
    }

    override fun startScanning(delay: Long?) {

        val scanManager = BarcodeScanManager()
        scanManager.start()
    }

    override fun stopScanning() {
        val scanManager = BarcodeScanManager()
        scanManager.stop()
    }

    override fun getTimeOut(callback: (Result<Long>) -> Unit) {
        val scanManager = BarcodeScanManager()
        val timeout = scanManager.getTimeout()
        callback.invoke(Result.success(timeout.toLong()))
    }

    override fun setTimeOut(timeout: Long) {
        val scanManager = BarcodeScanManager()
        scanManager.setTimeout(timeout.toInt())
    }

    override fun getSoundMode(callback: (Result<SoundMode>) -> Unit) {
        val scanManager = BarcodeScanManager()
        val mode = scanManager.getSoundSetting()
        callback.invoke(Result.success(mode))
    }

    override fun setSoundMode(mode: SoundMode) {
        val scanManager = BarcodeScanManager()
        scanManager.setSoundMode(mode)
    }

    override fun isVibrationEnabled(callback: (Result<Boolean>) -> Unit) {
        val scanManager = BarcodeScanManager()

        val isEnabled = scanManager.isVibrationEnabled()
        callback.invoke(Result.success(isEnabled))
    }

    override fun enableVibration() {
        val scanManager = BarcodeScanManager()
        scanManager.enableVibration()
    }

    override fun disableVibration() {
        val scanManager = BarcodeScanManager()
        scanManager.disableVibration()
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