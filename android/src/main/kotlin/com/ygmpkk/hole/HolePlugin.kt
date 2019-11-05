package com.ygmpkk.hole

import com.alipay.sdk.app.AuthTask
import com.alipay.sdk.app.EnvUtils
import com.alipay.sdk.app.PayTask
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import kotlinx.coroutines.*
import android.content.pm.PackageManager
import android.content.pm.ResolveInfo
import android.content.Intent
import android.net.Uri


class HolePlugin(private var registrar: Registrar) : MethodCallHandler {
    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar): Unit {
            val channel = MethodChannel(registrar.messenger(), "com.ygmpkk/hole")
            channel.setMethodCallHandler(HolePlugin(registrar))
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when {
            call.method == "version" -> version(result)
            call.method == "aOrder" -> pay(call, result)
            call.method == "auth" -> auth(call, result)
            call.method == "isAlipInstalled" -> isAliPayInstalled(result)
            else -> result.notImplemented()
        }
    }

    private fun pay(call: MethodCall, result: Result) {
        GlobalScope.launch(Dispatchers.Main, CoroutineStart.DEFAULT) {
            if (call.argument<Int>("payEnv") == 1) {
                EnvUtils.setEnv(EnvUtils.EnvEnum.SANDBOX)
            } else {
                EnvUtils.setEnv(EnvUtils.EnvEnum.ONLINE)
            }
            val payResult = doPayTask(call.argument("order")?:"")
            result.success(payResult.plus("platform" to "android"))
        }
    }



    private suspend fun doPayTask(orderInfo: String): Map<String, String> {

        return GlobalScope.async(Dispatchers.Default, CoroutineStart.DEFAULT) {
            val alipay = PayTask(registrar.activity())
            alipay.payV2(orderInfo, true) ?: mapOf<String, String>()
        }.await()
    }


    private fun auth(call: MethodCall, result: Result) {
        GlobalScope.launch(Dispatchers.Main, CoroutineStart.DEFAULT) {
            val authResult = doAuthTask(call.arguments as String)
            result.success(authResult.plus("platform" to "android"))
        }
    }

    private suspend fun doAuthTask(authInfo: String): Map<String, String> {

        return GlobalScope.async(Dispatchers.Default, CoroutineStart.DEFAULT) {
            val alipay = AuthTask(registrar.activity())
            alipay.authV2(authInfo, true) ?: mapOf<String, String>()
        }.await()
    }


    private fun version(result: Result) {
        GlobalScope.launch(Dispatchers.Main, CoroutineStart.DEFAULT) {
            val version = doGetVersionTask()
            result.success(mapOf(
                    "platform" to "android",
                    "version" to version
            ))
        }
    }

    private fun isAliPayInstalled(result: Result){
        val manager = registrar.context().packageManager
        val action = Intent(Intent.ACTION_VIEW)
        action.data = Uri.parse("alipays://")
        val list = manager.queryIntentActivities(action, PackageManager.GET_RESOLVED_FILTER)
        result.success(list != null && list.size > 0)
    }

    private suspend fun doGetVersionTask(): String {

        return GlobalScope.async(Dispatchers.Default, CoroutineStart.DEFAULT) {
            val alipay = PayTask(registrar.activity())
            alipay.version ?: ""
        }.await()
    }
}