package com.gigantic_tickets.urovo_scanning

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.device.ScanManager.BARCODE_STRING_TAG
import android.util.Log

class BarcodeReceiver : BroadcastReceiver() {

    private lateinit var callback: BarcodeReceiverListener

    fun setListener(callback: BarcodeReceiverListener) {
        this.callback = callback
    }

    private val ACTION_CAPTURE_IMAGE: String = "scanner_capture_image_result"
    override fun onReceive(context: Context?, intent: Intent?) {
        val action = intent?.action
        if (ACTION_CAPTURE_IMAGE != action) {
            // Get scan results, including string and byte data etc.
            val barcodeStr =
                intent?.getStringExtra(BARCODE_STRING_TAG)
            // print scan results.
            if (barcodeStr != null) {
                Log.d("BARCODE_RECEIVER", "Barcode is $barcodeStr")
                callback.onBarcodeChanged(barcodeStr as String)
            }
        }

    }

    companion object {
        fun register(context: Context, receiver: BarcodeReceiver, filter: IntentFilter) {
            Log.i("BARCODE_RECEIVER", "on unregister receiver")
            context.registerReceiver(receiver, filter)
        }

        fun unregister(context: Context, receiver: BarcodeReceiver,) {
            Log.i("BARCODE_RECEIVER", "on unregister receiver")
            context.unregisterReceiver(receiver)
        }
    }

}

abstract class BarcodeReceiverListener {
    abstract fun onBarcodeChanged(barcode : String)
}