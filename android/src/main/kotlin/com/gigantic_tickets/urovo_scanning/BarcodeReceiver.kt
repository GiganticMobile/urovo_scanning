package com.gigantic_tickets.urovo_scanning

import Barcode
import android.device.ScanManager
import android.device.ScanManager.ACTION_DECODE
import android.device.scanner.configuration.PropertyID
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.device.ScanManager.BARCODE_LENGTH_TAG
import android.device.ScanManager.BARCODE_STRING_TAG
import android.device.ScanManager.BARCODE_TYPE_TAG
import android.device.ScanManager.DECODE_DATA_TAG
import android.util.Log

class BarcodeReceiver : BroadcastReceiver() {

    private lateinit var callback: BarcodeReceiverListener

    fun setListener(callback: BarcodeReceiverListener) {
        this.callback = callback
    }

    private val ACTION_DECODE_DATA = "android.intent.ACTION_DECODE_DATA"
    override fun onReceive(context: Context?, intent: Intent?) {
        val action = intent?.action
        if (ACTION_DECODE_DATA == action) {

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
        fun register(context: Context, receiver: BarcodeReceiver,) {

            val scanManager = ScanManager()

            val filter = IntentFilter()
            val idbuf = intArrayOf(
                PropertyID.WEDGE_INTENT_ACTION_NAME,
                PropertyID.WEDGE_INTENT_DATA_STRING_TAG
            )
            val value_buf: Array<String?> = scanManager.getParameterString(idbuf)
            if (value_buf[0] != null && value_buf[0] != "") {
                filter.addAction(value_buf[0])
            } else {
                filter.addAction(ACTION_DECODE)
            }

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