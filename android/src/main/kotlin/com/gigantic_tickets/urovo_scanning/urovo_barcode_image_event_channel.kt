package com.gigantic_tickets.urovo_scanning

import OnBarcodeImageChangedStreamHandler
import PigeonEventSink

class urovo_barcode_image_event_channel : OnBarcodeImageChangedStreamHandler() {

    private var eventSink: PigeonEventSink<ByteArray>? = null

    override fun onListen(p0: Any?, sink: PigeonEventSink<ByteArray>) {
        super.onListen(p0, sink)
        eventSink = sink
    }

    fun onBarcodeImageChanged(imageBytes: ByteArray) {
        eventSink?.success(imageBytes)
    }

    override fun onCancel(p0: Any?) {
        super.onCancel(p0)
        eventSink?.endOfStream()
    }
}