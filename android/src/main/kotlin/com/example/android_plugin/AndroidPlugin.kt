package com.example.android_plugin

import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import android.Manifest
import android.app.Activity
import android.util.Log
import androidx.core.app.ActivityCompat.requestPermissions
import androidx.core.content.ContextCompat
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationCallback
import com.google.android.gms.location.LocationRequest
import com.google.android.gms.location.LocationRequest.PRIORITY_HIGH_ACCURACY
import com.google.android.gms.location.LocationRequest.create
import com.google.android.gms.location.LocationResult
import com.google.android.gms.location.LocationServices
import io.flutter.plugin.common.EventChannel

/** AndroidPlugin */
class AndroidPlugin : FlutterPlugin, MethodCallHandler, ActivityAware,
    PluginRegistry.ActivityResultListener {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private lateinit var activity: Activity

    private lateinit var fusedLocationClient: FusedLocationProviderClient
    private lateinit var locationRequest: LocationRequest
    private lateinit var locationCallback: LocationCallback

    private lateinit var locationEventSource: EventChannel.EventSink
    private lateinit var locationEventEmitter: EventChannel
    private var locationEventsSourceHandler: EventChannel.StreamHandler =
        object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                locationEventSource = events
            }

            override fun onCancel(arguments: Any?) {
            }
        }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
        locationEventEmitter =
            EventChannel(flutterPluginBinding.binaryMessenger, LOCATION_CHANNEL)
        locationEventEmitter.setStreamHandler(locationEventsSourceHandler)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            PERMISSION_CHECK_METHOD -> permissionCheck(result)
            PERMISSION_REQUEST_METHOD -> requestPermission(result)
            GET_LOCATION -> getLocation(result)
            INITIALIZE -> initialize(result)
            STOP_LOCATION_REQUEST -> stopLocationRequest(result)
            else -> result.notImplemented()
        }
    }

    private fun permissionCheck(result: Result) {
        result.success(isPermissionGranted())
    }

    private fun isPermissionGranted(): Boolean {
        var permission: Boolean
        context.run {
            permission = ContextCompat.checkSelfPermission(
                this,
                Manifest.permission.ACCESS_FINE_LOCATION
            ) == PackageManager.PERMISSION_GRANTED && ContextCompat.checkSelfPermission(
                this,
                Manifest.permission.ACCESS_COARSE_LOCATION
            ) == PackageManager.PERMISSION_GRANTED
        }
        return permission
    }

    private fun initialize(result: Result) {
        fusedLocationClient = LocationServices.getFusedLocationProviderClient(activity)
        val hasPermission = isPermissionGranted()
        if (hasPermission) {
            locationRequest = create().apply {
                interval = INTERVAL
                priority = PRIORITY_HIGH_ACCURACY
                locationCallback = object : LocationCallback() {
                    override fun onLocationResult(initialPosition: LocationResult) {
                        locationEventSource.success(initialPosition.locationCoordinates())
                    }
                }
            }
        } else {
            locationEventSource.success(false)
        }
        return result.success(hasPermission)
    }

    private fun getLocation(result: Result) {
        fusedLocationClient.requestLocationUpdates(
            locationRequest,
            locationCallback,
            null
        )
        return result.success(true)
    }

    private fun stopLocationRequest(result: Result) {
        context.run { fusedLocationClient.removeLocationUpdates(locationCallback) }
        locationEventSource.success(LOCATION_STOPPED)
        return result.success(true)
    }

    private fun requestPermission(result: Result) {
        context.run {
            activity.apply {
                requestPermissions(
                    this,
                    arrayOf(
                        Manifest.permission.ACCESS_COARSE_LOCATION,
                        Manifest.permission.ACCESS_FINE_LOCATION
                    ),
                    REQUEST_CODE
                )
            }
        }
        return result.success(true)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addActivityResultListener(this)
        fusedLocationClient = LocationServices.getFusedLocationProviderClient(activity)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        Log.i("onDetachedFromActivityF", "Function not implemented")
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        Log.i("onReattachedToActivity", "Function not implemented")
    }

    override fun onDetachedFromActivity() {
        Log.i("onDetachedFromActivity", "Function not implemented")
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        Log.i("onActivityResult", "Function not implemented")
        return true
    }

    companion object AndroidPlugin {
        const val REQUEST_CODE = 500
        const val PERMISSION_CHECK_METHOD = "permissionCheck"
        const val PERMISSION_REQUEST_METHOD = "requestPermission"
        const val CHANNEL = "android_plugin"
        const val GET_LOCATION = "getLocation"
        const val INITIALIZE = "initialize"
        const val STOP_LOCATION_REQUEST = "stopLocationRequest"
        const val INTERVAL: Long = 5000
        const val LOCATION_STOPPED = "Location request stopped"
        const val ERROR = "Error"
        const val PERMISSION_DENIED = "Permission denied"
        const val LOCATION_CHANNEL = "location_channel"
        const val LONGITUDE_TAG = "Longitude: "
        const val LATITUDE_TAG = "Latitude: "
    }
}
