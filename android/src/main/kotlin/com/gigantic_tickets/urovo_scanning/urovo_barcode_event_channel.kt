package com.gigantic_tickets.urovo_scanning

import OnBarcodeChangedStreamHandler
import PigeonEventSink
import android.util.Log

class urovo_barcode_event_channel : OnBarcodeChangedStreamHandler() {

    private var eventSink: PigeonEventSink<String>? = null

    override fun onListen(p0: Any?, sink: PigeonEventSink<String>) {
        super.onListen(p0, sink)
        eventSink = sink
    }

    fun onBarcodeChanged(barcode : String) {
        eventSink?.success(barcode)
    }

    override fun onCancel(p0: Any?) {
        super.onCancel(p0)
        Log.i("Urovo scan ended", "onListen")
        eventSink?.endOfStream()
    }

}