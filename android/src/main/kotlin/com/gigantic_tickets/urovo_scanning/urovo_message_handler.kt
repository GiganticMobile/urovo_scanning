package com.gigantic_tickets.urovo_scanning

import Code
import UrovoMessageInterface
//import android.util.Log

class urovo_message_handler : UrovoMessageInterface {

    override fun getDeviceManufacture(callback: (Result<String>) -> Unit) {
        //val deviceName: String? = android.os.Build.MODEL
        val deviceMan: String? = android.os.Build.MANUFACTURER
        callback.invoke(Result.success(deviceMan ?: ""))
    }

    override fun startScanning() {
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

    override fun getSoundMode(callback: (Result<Long?>) -> Unit) {
        val scanManager = BarcodeScanManager()
        val sound = scanManager.getSoundSetting()?.toLong()
        callback.invoke(Result.success(sound))
    }

    override fun setSoundMode(mode: Long) {
        val scanManager = BarcodeScanManager()
        scanManager.setSoundMode(mode.toInt())
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
        //Log.d("MESSAGE_HANDLER", "is trigger locked $isTriggerLocked")
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

    override fun getScanMode(callback: (Result<Long?>) -> Unit) {
        val scanManager = BarcodeScanManager()
        val scanMode = scanManager.getTriggerMode()
        callback.invoke(Result.success(scanMode?.toLong()))
    }

    override fun setScanMode(mode: Long) {
        val scanManager = BarcodeScanManager()
        scanManager.setTriggerMode(mode.toInt())
    }

    override fun getCodes(callback: (Result<List<Code>>) -> Unit) {
        val scanManager = BarcodeScanManager()
        val codes = scanManager.getAllSymbology()
        callback.invoke(Result.success(codes))
    }

    override fun getCode(codeId: Long, callback: (Result<Code?>) -> Unit) {
        val scanManager = BarcodeScanManager()
        val code = scanManager.getSymbology(codeId.toInt())
        callback.invoke(Result.success(code))
    }

    override fun enableCode(codeId: Long) {
        val scanManager = BarcodeScanManager()
        scanManager.enableSymbology(codeId.toInt())
    }

    override fun enableAllCodes() {
        val scanManager = BarcodeScanManager()
        scanManager.enableAllSymbology()
    }

    override fun disableCode(codeId: Long) {
        val scanManager = BarcodeScanManager()
        scanManager.disableSymbology(codeId.toInt())
    }

    override fun disableAllCodes() {
        val scanManager = BarcodeScanManager()
        scanManager.disableAllSymbology()
    }

    override fun resetScanner() {
        val scanManager = BarcodeScanManager()
        scanManager.reset()
    }

}