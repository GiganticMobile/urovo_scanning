package com.gigantic_tickets.urovo_scanning

import Barcode
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.device.ScanManager.BARCODE_LENGTH_TAG
import android.device.ScanManager.BARCODE_STRING_TAG
import android.device.ScanManager.BARCODE_TYPE_TAG
import android.device.ScanManager.DECODE_DATA_TAG

class BarcodeReceiver : BroadcastReceiver() {

    private lateinit var callback: BarcodeReceiverListener

    fun setListener(callback: BarcodeReceiverListener) {
        this.callback = callback
    }

    private val ACTION_DECODE_DATA = "android.intent.ACTION_DECODE_DATA"
    override fun onReceive(context: Context?, intent: Intent?) {
        val action = intent?.action
        if (ACTION_DECODE_DATA == action) {
            // Get results from the laser scanner

            /*val extra = intent?.getExtras()
            for (key in extra!!.keySet()) {
                Log.d("BARCODE_RECEIVER", "extra key is ${key}")
                Log.d("BARCODE_RECEIVER", "extra is ${extra!!.get(key)}")
            }*/

            val barcodeBytes: ByteArray? = intent?.getByteArrayExtra(DECODE_DATA_TAG)

            val barcodeString: String? = intent?.getStringExtra(BARCODE_STRING_TAG)

            val barcodeLength: Int? = intent?.getIntExtra(BARCODE_LENGTH_TAG, 0)

            val codeType: String? = intent?.getStringExtra("codetype")

            val barcodeType: Byte? = intent?.getByteExtra(BARCODE_TYPE_TAG, 0.toByte())

            try {
                callback.onBarcodeChanged(Barcode(
                    barcodeBytes,
                    barcodeString,
                    (barcodeLength)?.toLong(),
                    codeType,
                    (barcodeType)?.toLong()
                ))
            } catch (_ : Exception) {
                //could not read scan result
            }
        }

    }

    companion object {
        fun register(context: Context, receiver: BarcodeReceiver, filter: IntentFilter) {
            context.registerReceiver(receiver, filter)
        }

        fun unregister(context: Context, receiver: BarcodeReceiver) {
            context.unregisterReceiver(receiver)
        }
    }

}

abstract class BarcodeReceiverListener {
    abstract fun onBarcodeChanged(info : Barcode)
}