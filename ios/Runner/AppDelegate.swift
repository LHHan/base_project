import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      GeneratedPluginRegistrant.register(with: self)

      guard let controller = window?.rootViewController as? FlutterViewController else {
          return super.application(application, didFinishLaunchingWithOptions: launchOptions)
      }
      let flavorChannel = FlutterMethodChannel(name: "flavor", binaryMessenger: controller.binaryMessenger)
      flavorChannel.setMethodCallHandler({(call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          switch call.method {
          case "getFlavor":
              let flavor = Bundle.main.infoDictionary?["AppFlavor"]
              result(flavor)
          default:
              result(FlutterMethodNotImplemented)
          }
      })
      
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
