package com.gigantic_tickets.urovo_scanning

import Barcode
import OnBarcodeChangedStreamHandler
import PigeonEventSink

class urovo_barcode_event_channel : OnBarcodeChangedStreamHandler() {

    private var eventSink: PigeonEventSink<Barcode>? = null

    override fun onListen(p0: Any?, sink: PigeonEventSink<Barcode>) {
        super.onListen(p0, sink)
        eventSink = sink
    }

    fun onBarcodeChanged(info: Barcode) {
        eventSink?.success(info)
    }

    override fun onCancel(p0: Any?) {
        super.onCancel(p0)
        eventSink?.endOfStream()
    }

}