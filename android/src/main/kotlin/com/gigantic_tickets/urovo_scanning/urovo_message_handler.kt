package com.gigantic_tickets.urovo_scanning

import UrovoMessageInterface
import android.util.Log

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
}