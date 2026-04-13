package com.gigantic_tickets.urovo_scanning

import OnBarcodeChangedStreamHandler
import UrovoMessageInterface
import android.content.Context
import android.content.IntentFilter
import android.device.ScanManager
import android.device.ScanManager.ACTION_DECODE
import android.device.scanner.configuration.PropertyID
import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin

/** UrovoScanningPlugin */
class UrovoScanningPlugin : FlutterPlugin {
    //private lateinit var channel: EventChannel
    //private var handler: ScanStreamHandler? = null

    private lateinit var scanManager : BarcodeScanManager
    private var context: Context? = null
    private var receiver: BarcodeReceiver? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        // 2. Store the application context from the binding
        context = binding.applicationContext

        Log.i("UrovoScanningPlugin", "setup")
        //connecting android plugin to flutter code
        val api = urovo_message_handler()
        UrovoMessageInterface.setUp(binding.getBinaryMessenger(), api)

        val eventListener = urovo_barcode_event_channel()
        OnBarcodeChangedStreamHandler.register(binding.getBinaryMessenger(), eventListener)

        //creating barcode scanner
        scanManager = BarcodeScanManager()
        scanManager.turnOnScanner()

        //setting up Broadcast receiver
        receiver = BarcodeReceiver()

        receiver?.setListener(object : BarcodeReceiverListener() {
            override fun onBarcodeChanged(barcode : String) {
                eventListener.onBarcodeChanged(barcode)
            }
        })

        try {

            /*val filter = IntentFilter()
            val idbuf = intArrayOf(
                PropertyID.WEDGE_INTENT_ACTION_NAME,
                PropertyID.WEDGE_INTENT_DATA_STRING_TAG
            )
            val value_buf: Array<String?> = ScanManager().getParameterString(idbuf)
            if (value_buf[0] != null && value_buf[0] != "") {
                filter.addAction(value_buf[0])
            } else {
                filter.addAction(ACTION_DECODE)
            }*/

            val filter = scanManager.getIntentFilter()
            BarcodeReceiver.register(context!!, receiver!!, filter)
            //context?.registerReceiver(receiver, filter)
        } catch (_: Exception) {

        }

    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        //channel?.setStreamHandler(null)
        //context?.unregisterReceiver(receiver)
        BarcodeReceiver.unregister(context!!, receiver!!)
        scanManager.turnOffScanner()
        context = null
    }

    /*private fun initScan() {
        scanManager = ScanManager()
        val powerOn = scanManager.scannerState
        if (!powerOn) {
            scanManager.openScanner()
        }
        //send scan result to intent (broad case receiver)
        scanManager.switchOutputMode(0)
    }*/
}

/*
abstract class BarcodeReceiverListener {
    abstract fun onBarcodeChanged(barcode : String)
}

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
                //Log.d("SCANNING", barcodeStr)
                callback.onBarcodeChanged(barcodeStr)
            }
        }

    }

}*/

/*
class ScanStreamHandler(private val context: Context) : EventChannel.StreamHandler {
    private var receiver: BroadcastReceiver? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        receiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                val data = intent?.getStringExtra("scanner_data")
                events?.success(data)
            }
        }

        val filter = IntentFilter("com.scanner.SCAN_ACTION")
        // Android 14+ Export check
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.TIRAMISU) {
            context.registerReceiver(receiver, filter, Context.RECEIVER_EXPORTED)
        } else {
            context.registerReceiver(receiver, filter)
        }
    }

    override fun onCancel(arguments: Any?) {
        context.unregisterReceiver(receiver)
        receiver = null
    }
}*/

    /*:
    FlutterPlugin,
    MethodCallHandler {
    // The MethodChannel that will the communication between Flutter and native Android
    //
    // This local reference serves to register the plugin with the Flutter Engine and unregister it
    // when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "urovo_scanning")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(
        call: MethodCall,
        result: Result
    ) {
        var scan = ScanManager()
        val ret: Boolean = scan.openScanner()
        Log.i("UrovoScanningPlugin", ret.toString())
        if (call.method == "getPlatformVersion") {
            result.success("Android ${android.os.Build.VERSION.RELEASE}")
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}*/
