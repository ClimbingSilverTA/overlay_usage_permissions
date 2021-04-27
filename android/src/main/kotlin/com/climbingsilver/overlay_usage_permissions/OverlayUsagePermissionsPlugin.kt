package com.climbingsilver.overlay_usage_permissions

import android.app.Activity
import android.app.AppOpsManager
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Process
import android.provider.Settings
import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.Registrar

/** OverlayUsagePermissionsPlugin */
public class OverlayUsagePermissionsPlugin: FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  private var activity: Activity? = null
  private var pendingResult: Result? = null
  private lateinit var context: Context

  override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(binding.binaryMessenger, "overlay_usage_permissions")
    channel.setMethodCallHandler(this)
    context = binding.applicationContext
  }

  // This static function is optional and equivalent to onAttachedToEngine. It supports the old
  // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
  // plugin registration via this function while apps migrate to use the new Android APIs
  // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
  //
  // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
  // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
  // depending on the user's project. onAttachedToEngine or registerWith must both be defined
  // in the same class.
  companion object {
    private const val REQUEST_CODE_OVERLAYS = 1222
    private const val REQUEST_CODE_USAGE_STATS = 1223

    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "overlay_usage_permissions")
      channel.setMethodCallHandler(OverlayUsagePermissionsPlugin())
    }

    fun isStatsGranted(context: Context): Boolean {
      if (Build.VERSION.SDK_INT < Build.VERSION_CODES.LOLLIPOP) return true
      val opsManager = context.getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
      val mode = opsManager.checkOpNoThrow("android:get_usage_stats", Process.myUid(), context.packageName)
      return mode == AppOpsManager.MODE_ALLOWED
    }

    fun isDrawGranted(context: Context): Boolean {
      return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
        Settings.canDrawOverlays(context)
      } else {
        true
      }
    }

    fun requestUsageStats(activity: Activity?) {
      activity?.startActivityForResult(Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS), REQUEST_CODE_USAGE_STATS, null)
    }

    fun requestDraw(activity: Activity?) {
      val packageString = Uri.parse("package:" + activity?.packageName)
      val intent = Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION, packageString)
      intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
      activity?.startActivityForResult(intent, REQUEST_CODE_OVERLAYS, Bundle.EMPTY)
    }

  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "isStatsGranted" -> {
        val granted = isStatsGranted(context)
        result.success(granted)
      }
      "isDrawGranted" -> {
        val granted = isDrawGranted(context)
        result.success(granted)
      }
      "requestStats" -> {
        requestUsageStats(activity)
        pendingResult = result
      }
      "requestDraw" -> {
        requestDraw(activity)
        pendingResult = result
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
    if (requestCode == REQUEST_CODE_OVERLAYS || requestCode == REQUEST_CODE_USAGE_STATS) {
      pendingResult?.success(true)
      pendingResult = null
    }

    return false
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
    binding.addActivityResultListener(this)
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivity() {
    activity = null
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activity = null
  }

}
