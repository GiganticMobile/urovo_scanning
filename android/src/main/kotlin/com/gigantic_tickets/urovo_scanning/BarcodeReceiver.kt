package com.gigantic_tickets.urovo_scanning

import BarcodeInfo
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.device.ScanManager.DECODE_DATA_TAG
import android.device.ScanManager.BARCODE_STRING_TAG
import android.device.ScanManager.BARCODE_LENGTH_TAG
import android.device.ScanManager.BARCODE_TYPE_TAG
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
            // Get results from the laser scanner

            val barcodeBytes: ByteArray? = intent?.getByteArrayExtra(DECODE_DATA_TAG)

            val barcodeString: String? = intent?.getStringExtra(BARCODE_STRING_TAG)

            val barcodeLength: Int? = intent?.getIntExtra(BARCODE_LENGTH_TAG, 0)

            val barcodeType: Byte? = intent?.getByteExtra(BARCODE_TYPE_TAG, 0.toByte())

            try {
                callback.onBarcodeChanged(BarcodeInfo(
                    barcodeBytes!!,
                    barcodeString!!,
                    (barcodeLength!!).toLong(),
                    (barcodeType!!).toLong()
                ))
            } catch (_ : Exception) {
                //could not read scan result
            }
        }

    }

    companion object {
        fun register(context: Context, receiver: BarcodeReceiver, filter: IntentFilter) {
            Log.i("BARCODE_RECEIVER", "on unregister receiver")
            context.registerReceiver(receiver, filter)
        }

        fun unregister(context: Context, receiver: BarcodeReceiver) {
            Log.i("BARCODE_RECEIVER", "on unregister receiver")
            context.unregisterReceiver(receiver)
        }
    }

}

abstract class BarcodeReceiverListener {
    abstract fun onBarcodeChanged(info : BarcodeInfo)
}