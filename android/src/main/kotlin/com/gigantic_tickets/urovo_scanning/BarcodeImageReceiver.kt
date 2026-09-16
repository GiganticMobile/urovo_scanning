package com.gigantic_tickets.urovo_scanning

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter

class BarcodeImageReceiver : BroadcastReceiver() {

    private lateinit var callback: BarcodeImageReceiverListener

    fun setListener(callback: BarcodeImageReceiverListener) {
        this.callback = callback
    }

    private val ACTION_GET_IMAGE = "scanner_capture_image_result"
    override fun onReceive(context: Context?, intent: Intent?) {
        val action = intent?.action

        if (ACTION_GET_IMAGE == action) {
            val imageData: ByteArray? = intent.getByteArrayExtra("bitmapBytes")
            try {
                callback.onBarcodeImageChanged(imageData)
            } catch (_ : Exception) {
                //could not read scan result
            }
        }

    }

    companion object {
        fun register(context: Context, receiver: BarcodeImageReceiver) {
            val filter = IntentFilter()
            filter.addAction("scanner_capture_image_result")
            context.registerReceiver(receiver, filter)
        }

        fun unregister(context: Context, receiver: BarcodeImageReceiver) {
            context.unregisterReceiver(receiver)
        }
    }

}

abstract class BarcodeImageReceiverListener {
    abstract fun onBarcodeImageChanged(imageBytes : ByteArray?)
}