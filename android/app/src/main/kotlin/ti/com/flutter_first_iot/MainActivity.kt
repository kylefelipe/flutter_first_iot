package ti.com.flutter_first_iot

import android.os.Bundle
import android.os.Handler
import com.pubnub.api.PNConfiguration
import com.pubnub.api.PubNub
import com.pubnub.api.callbacks.SubscribeCallback
import com.pubnub.api.enums.PNStatusCategory
import com.pubnub.api.models.consumer.PNStatus
import com.pubnub.api.models.consumer.pubsub.PNMessageResult
import com.pubnub.api.models.consumer.pubsub.PNPresenceEventResult

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodChannel
import java.util.*


class MainActivity: FlutterActivity() {

  private val CHANNEL = "flutter.native/helper"
  private val SUBCRIBER = "flutter.native/subscriber"

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)

    val pnConfiguration = PNConfiguration()
    pnConfiguration.setSubscribeKey("sub...")
    pnConfiguration.setPublishKey("pub...")

    val pubnub = PubNub(pnConfiguration)

    val channelName = "flutter_iot"

    pubnub.addListener(object : SubscribeCallback() {
      override fun status(pubnub: PubNub, status: PNStatus) {}

      override fun message(pubnub: PubNub, message: PNMessageResult) {
        val receivedMessageObject = message.getMessage()

        this@MainActivity.runOnUiThread(java.lang.Runnable {
          MethodChannel(flutterView, SUBCRIBER).invokeMethod("messageReceived", receivedMessageObject.toString());
        })
      }

      override fun presence(pubnub: PubNub, presence: PNPresenceEventResult) {

      }
    })

    pubnub.subscribe().channels(Arrays.asList<String>(channelName)).execute()
  }
}
