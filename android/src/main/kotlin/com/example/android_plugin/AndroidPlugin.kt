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
import androidx.core.app.ActivityCompat

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

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            PERMISSION_CHECK_METHOD -> permissionCheck(result)
            PERMISSION_REQUEST_METHOD -> requestPermission()
            else -> result.notImplemented()
        }
    }

    private fun permissionCheck(result: Result) {
        result.success(checkPermissionIsDenied())
    }

    private fun checkPermissionIsDenied(): Boolean {
        var permission: Boolean
        context.run {
            permission = ActivityCompat.checkSelfPermission(
                this,
                Manifest.permission.ACCESS_FINE_LOCATION
            ) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(
                this,
                Manifest.permission.ACCESS_COARSE_LOCATION
            ) != PackageManager.PERMISSION_GRANTED
        }
        return permission
    }

    private fun requestPermission() {
        context.run {
            activity.apply {
                ActivityCompat.requestPermissions(
                    this,
                    arrayOf(
                        Manifest.permission.ACCESS_COARSE_LOCATION,
                        Manifest.permission.ACCESS_FINE_LOCATION
                    ),
                    REQUEST_CODE
                )
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addActivityResultListener(this)
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
        return false
    }

    companion object AndroidPlugin {
        const val REQUEST_CODE = 500
        const val PERMISSION_CHECK_METHOD = "permissionCheck"
        const val PERMISSION_REQUEST_METHOD = "requestPermission"
        const val CHANNEL = "android_plugin"
    }
}
