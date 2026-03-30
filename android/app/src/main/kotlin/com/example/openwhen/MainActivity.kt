package com.example.openwhen

import android.content.Intent
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    private val channelName = "com.openwhen.app/instagram_stories"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName).setMethodCallHandler { call, result ->
            when (call.method) {
                "isInstagramStoryAvailable" -> {
                    val intent = Intent("com.instagram.share.ADD_TO_STORY").apply {
                        setPackage("com.instagram.android")
                    }
                    result.success(intent.resolveActivity(packageManager) != null)
                }
                "shareInstagramStory" -> {
                    val bgPath = call.argument<String>("backgroundPath")
                    val appId = call.argument<String>("facebookAppId")
                    if (bgPath == null || appId == null) {
                        result.error("INVALID_ARGUMENT", "Missing backgroundPath or facebookAppId", null)
                        return@setMethodCallHandler
                    }
                    val file = File(bgPath)
                    if (!file.exists()) {
                        result.error("FILE_NOT_FOUND", "Background file missing", null)
                        return@setMethodCallHandler
                    }
                    val uri = FileProvider.getUriForFile(
                        this,
                        "${applicationContext.packageName}.fileprovider",
                        file,
                    )
                    val intent = Intent("com.instagram.share.ADD_TO_STORY").apply {
                        setDataAndType(uri, "image/*")
                        setPackage("com.instagram.android")
                        putExtra("source_application", appId)
                        addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                    }
                    try {
                        if (intent.resolveActivity(packageManager) != null) {
                            startActivity(intent)
                            result.success(true)
                        } else {
                            result.error("INSTAGRAM_NOT_INSTALLED", "Instagram not installed", null)
                        }
                    } catch (e: Exception) {
                        result.error("NATIVE_ERROR", e.message, null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }
}
