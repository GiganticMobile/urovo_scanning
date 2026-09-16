package com.gigantic_tickets.urovo_scanning

import Barcode
import OnBarcodeChangedStreamHandler
import UrovoMessageInterface
import android.content.Context
import android.content.Intent
import io.flutter.embedding.engine.plugins.FlutterPlugin

/** UrovoScanningPlugin */
class UrovoScanningPlugin : FlutterPlugin {

    private lateinit var scanManager : BarcodeScanManager
    private var context: Context? = null
    private var receiver: BarcodeReceiver? = null
    private var imageReceiver: BarcodeImageReceiver? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext

        //connecting android plugin to flutter code
        val api = urovo_message_handler()
        UrovoMessageInterface.setUp(binding.getBinaryMessenger(), api)

        val barcodeEventListener = urovo_barcode_event_channel()
        OnBarcodeChangedStreamHandler.register(binding.getBinaryMessenger(), barcodeEventListener)
        val barcodeImageEventListener = urovo_barcode_image_event_channel()
        OnBarcodeImageChangedStreamHandler.register(binding.getBinaryMessenger(), barcodeImageEventListener)

        //creating barcode scanner
        scanManager = BarcodeScanManager()
        scanManager.startListening()

        //setting up Broadcast receiver
        receiver = BarcodeReceiver()
        imageReceiver = BarcodeImageReceiver()

        receiver?.setListener(object : BarcodeReceiverListener() {
            override fun onBarcodeChanged(info : Barcode) {
                barcodeEventListener.onBarcodeChanged(info)
                val ctx = context
                if (ctx != null) {
                    //after a successful scan get the image of the barcode
                    //from the device. Image returned to image receiver
                    val intent = Intent("action.scanner_capture_image")
                    ctx.sendBroadcast(intent)
                }
            }
        })

        imageReceiver?.setListener(object : BarcodeImageReceiverListener() {
            override fun onBarcodeImageChanged(imageBytes: ByteArray?) {
                if (imageBytes != null) {
                    barcodeImageEventListener.onBarcodeImageChanged(imageBytes)
                }
            }
        })

        try {
            val ctx = context
            val rec = receiver
            if (ctx != null && rec != null) {
                BarcodeReceiver.register(ctx, rec)
            }
            val imageRec = imageReceiver
            if (ctx != null && imageRec != null) {
                BarcodeImageReceiver.register(ctx, imageRec)
            }
        } catch (_: Exception) {

        }

    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        val ctx = context
        val rec = receiver
        if (ctx != null && rec != null) {
            BarcodeReceiver.unregister(ctx, rec)
        }
        val imageRec = imageReceiver
        if (ctx != null && imageRec != null) {
            BarcodeImageReceiver.unregister(ctx, imageRec)
        }
        scanManager.stopListening()
        context = null
    }
}
