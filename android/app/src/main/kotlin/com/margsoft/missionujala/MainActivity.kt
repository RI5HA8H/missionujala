package com.margsoft.missionujala
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.util.Base64
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.security.MessageDigest

class MainActivity : FlutterActivity() {
    private val CHANNEL = "signatureVerification"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "getSHA1Signature") {
                    val signature = getSHA1Signature()
                    result.success(signature)
                } else {
                    result.notImplemented()
                }
            }
    }

    private fun getSHA1Signature(): String? {
        return try {
            val packageName = packageName
            val packageInfo = packageManager.getPackageInfo(packageName, PackageManager.GET_SIGNATURES)
            val signatureBytes = packageInfo.signatures[0].toByteArray()
            //val osh1=signatureBytes.toString()
            //val sha1 = Base64.encodeToString(signatureBytes, Base64.DEFAULT)
            val md = MessageDigest.getInstance("SHA-1")
            val digest = md.digest(signatureBytes)

            // Convert byte array to hex string
            val hexString = StringBuilder()
            for (byte in digest) {
                hexString.append(String.format("%02X:", byte))
            }

            // Remove last ':' character
            return hexString.toString().substring(0, hexString.length - 1)
        } catch (e: Exception) {
            e.printStackTrace()
            null
        }
    }
}