package com.gigantic_tickets.urovo_scanning

import Barcode
import OnBarcodeChangedStreamHandler
import UrovoMessageInterface
import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin

/** UrovoScanningPlugin */
class UrovoScanningPlugin : FlutterPlugin {

    private lateinit var scanManager : BarcodeScanManager
    private var context: Context? = null
    private var receiver: BarcodeReceiver? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext

        //connecting android plugin to flutter code
        val api = urovo_message_handler()
        UrovoMessageInterface.setUp(binding.getBinaryMessenger(), api)

        val eventListener = urovo_barcode_event_channel()
        OnBarcodeChangedStreamHandler.register(binding.getBinaryMessenger(), eventListener)

        //creating barcode scanner
        scanManager = BarcodeScanManager()
        scanManager.startListening()

        //setting up Broadcast receiver
        receiver = BarcodeReceiver()

        receiver?.setListener(object : BarcodeReceiverListener() {
            override fun onBarcodeChanged(info : Barcode) {
                eventListener.onBarcodeChanged(info)
            }
        })

        try {
            val filter = scanManager.getIntentFilter()
            BarcodeReceiver.register(context!!, receiver!!, filter)
        } catch (_: Exception) {

        }

    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        BarcodeReceiver.unregister(context!!, receiver!!)
        scanManager.stopListening()
        context = null
    }
}
