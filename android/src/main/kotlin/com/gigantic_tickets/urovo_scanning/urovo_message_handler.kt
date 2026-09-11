package com.gigantic_tickets.urovo_scanning

import Code
import FlutterError
import UrovoMessageInterface
import android.content.Context
import android.content.Intent

class urovo_message_handler(private val context : Context?) : UrovoMessageInterface {

    override fun getDeviceManufacture(callback: (Result<String>) -> Unit) {
        //val deviceName: String? = android.os.Build.MODEL
        val deviceMan: String? = android.os.Build.MANUFACTURER
        callback.invoke(Result.success(deviceMan ?: ""))
    }

    override fun getDeviceModel(callback: (Result<String>) -> Unit) {
        val deviceModel: String? = android.os.Build.MODEL
        callback.invoke(Result.success(deviceModel ?: ""))
    }

    /*override fun hasDeviceScanner(callback: (Result<Boolean>) -> Unit) {
        try {
            val scanManager = BarcodeScanManager()
            val result = scanManager.hasScanner()
            callback.invoke(Result.success(result))
        } catch (_ : Exception) {
            callback.invoke(Result.success(false))
        }
    }*/

    override fun startScanning() {
        try {
            val scanManager = BarcodeScanManager()
            scanManager.start()
        } catch (e : Exception) {
            throw FlutterError("start scanning", e.message)
        }
    }

    override fun startScanningReturnImage() {
        try {
            val scanManager = BarcodeScanManager()
            val ctx = context
            if (ctx != null) {
                val intent: Intent = Intent("action.scanner_capture_image")
                ctx.sendBroadcast(intent)
            }
            scanManager.start()
        } catch (e : Exception) {
            throw FlutterError("start scanning and return image", e.message)
        }
    }

    override fun stopScanning() {
        try {
            val scanManager = BarcodeScanManager()
            scanManager.stop()
        } catch (e : Exception) {
            throw FlutterError("stop scanning", e.message)
        }
    }

    override fun getTimeOut(callback: (Result<Long>) -> Unit) {
        try {
            val scanManager = BarcodeScanManager()
            val timeout = scanManager.getTimeout()
            callback.invoke(Result.success(timeout.toLong()))
        } catch (e : Exception) {
            callback.invoke(Result.failure(e))
        }
    }

    override fun setTimeOut(timeout: Long) {
        try {
            val scanManager = BarcodeScanManager()
            scanManager.setTimeout(timeout.toInt())
        } catch (e : Exception) {
            throw FlutterError("set time out", e.message)
        }
    }

    override fun getSoundMode(callback: (Result<Long?>) -> Unit) {
        try {
            val scanManager = BarcodeScanManager()
            val sound = scanManager.getSoundSetting()?.toLong()
            callback.invoke(Result.success(sound))
        } catch (e : Exception) {
            callback.invoke(Result.failure(e))
        }
    }

    override fun setSoundMode(mode: Long) {
        try {
            val scanManager = BarcodeScanManager()
            scanManager.setSoundMode(mode.toInt())
        } catch (e : Exception) {
            throw FlutterError("set sound mode", e.message)
        }
    }

    override fun isVibrationEnabled(callback: (Result<Boolean>) -> Unit) {
        try {
            val scanManager = BarcodeScanManager()

            val isEnabled = scanManager.isVibrationEnabled()
            callback.invoke(Result.success(isEnabled))
        } catch (e : Exception) {
            callback.invoke(Result.failure(e))
        }
    }

    override fun enableVibration() {
        try {
            val scanManager = BarcodeScanManager()
            scanManager.enableVibration()
        } catch (e : Exception) {
            throw FlutterError("enable vibration", e.message)
        }
    }

    override fun disableVibration() {
        try {
            val scanManager = BarcodeScanManager()
            scanManager.disableVibration()
        } catch (e : Exception) {
            throw FlutterError("disable vibration", e.message)
        }
    }

    override fun isTriggerEnabled(callback: (Result<Boolean>) -> Unit) {
        try {
            val scanManager = BarcodeScanManager()
            //enabled is unlocked (isTriggerLocked false
            val isTriggerLocked = !scanManager.isTriggerLocked()
            //Log.d("MESSAGE_HANDLER", "is trigger locked $isTriggerLocked")
            callback.invoke(Result.success(isTriggerLocked))
        } catch (e : Exception) {
            callback.invoke(Result.failure(e))
        }
    }

    override fun enableTrigger() {
        try {
            val scanManager = BarcodeScanManager()
            scanManager.enableTrigger()
        } catch (e : Exception) {
            throw FlutterError("enable trigger", e.message)
        }
    }

    override fun disableTrigger() {
        try {
            val scanManager = BarcodeScanManager()
            scanManager.disableTrigger()
        } catch (e : Exception) {
            throw FlutterError("disable trigger", e.message)
        }
    }

    override fun getScanMode(callback: (Result<Long?>) -> Unit) {
        try {
            val scanManager = BarcodeScanManager()
            val scanMode = scanManager.getTriggerMode()
            callback.invoke(Result.success(scanMode?.toLong()))
        } catch (e : Exception) {
            callback.invoke(Result.failure(e))
        }
    }

    override fun setScanMode(mode: Long) {
        try {
            val scanManager = BarcodeScanManager()
            scanManager.setTriggerMode(mode.toInt())
        } catch (e : Exception) {
            throw FlutterError("set scan mode", e.message)
        }
    }

    override fun getCodes(callback: (Result<List<Code>>) -> Unit) {
        try {
            val scanManager = BarcodeScanManager()
            val codes = scanManager.getAllSymbology()
            callback.invoke(Result.success(codes))
        } catch (e : Exception) {
            callback.invoke(Result.failure(e))
        }
    }

    override fun getCode(codeId: Long, callback: (Result<Code?>) -> Unit) {
        try {
            val scanManager = BarcodeScanManager()
            val code = scanManager.getSymbology(codeId.toInt())
            callback.invoke(Result.success(code))
        } catch (e : Exception) {
            callback.invoke(Result.failure(e))
        }
    }

    override fun enableCode(codeId: Long) {
        try {
            val scanManager = BarcodeScanManager()
            scanManager.enableSymbology(codeId.toInt())
        } catch (e : Exception) {
            throw FlutterError("enable code", e.message)
        }
    }

    override fun enableAllCodes() {
        try {
            val scanManager = BarcodeScanManager()
            scanManager.enableAllSymbology()
        } catch (e : Exception) {
            throw FlutterError("enable all codes", e.message)
        }
    }

    override fun disableCode(codeId: Long) {
        try {
            val scanManager = BarcodeScanManager()
            scanManager.disableSymbology(codeId.toInt())
        } catch (e : Exception) {
            throw FlutterError("disable code", e.message)
        }
    }

    override fun disableAllCodes() {
        try {
            val scanManager = BarcodeScanManager()
            scanManager.disableAllSymbology()
        } catch (e : Exception) {
            throw FlutterError("disable all codes", e.message)
        }
    }

    override fun resetScanner() {
        try {
            val scanManager = BarcodeScanManager()
            scanManager.reset()
        } catch (e : Exception) {
            throw FlutterError("reset scanner", e.message)
        }
    }

}