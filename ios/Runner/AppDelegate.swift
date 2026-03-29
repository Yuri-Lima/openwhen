import Flutter
import UIKit

private enum InstagramStoriesChannel {
  static let name = "com.openwhen.app/instagram_stories"

  static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: name, binaryMessenger: registrar.messenger())
    channel.setMethodCallHandler { call, result in
      switch call.method {
      case "isInstagramStoryAvailable":
        guard let url = URL(string: "instagram-stories://share") else {
          result(false)
          return
        }
        result(UIApplication.shared.canOpenURL(url))
      case "shareInstagramStory":
        guard let args = call.arguments as? [String: Any],
              let bgPath = args["backgroundPath"] as? String,
              let appId = args["facebookAppId"] as? String else {
          result(
            FlutterError(
              code: "INVALID_ARGUMENT",
              message: "Missing backgroundPath or facebookAppId",
              details: nil))
          return
        }
        let fileUrl = URL(fileURLWithPath: bgPath)
        guard let data = try? Data(contentsOf: fileUrl) else {
          result(
            FlutterError(
              code: "FILE_NOT_FOUND",
              message: "Could not read background image",
              details: nil))
          return
        }
        let pasteboardItems: [[String: Any]] = [
          ["com.instagram.sharedSticker.backgroundImage": data],
        ]
        let options: [UIPasteboard.OptionsKey: Any] = [
          .expirationDate: Date().addingTimeInterval(60 * 5),
        ]
        UIPasteboard.general.setItems(pasteboardItems, options: options)
        var components = URLComponents(string: "instagram-stories://share")
        components?.queryItems = [URLQueryItem(name: "source_application", value: appId)]
        guard let url = components?.url else {
          result(
            FlutterError(
              code: "INVALID_ARGUMENT",
              message: "Bad instagram-stories URL",
              details: nil))
          return
        }
        if UIApplication.shared.canOpenURL(url) {
          UIApplication.shared.open(url, options: [:]) { success in
            result(success)
          }
        } else {
          result(
            FlutterError(
              code: "INSTAGRAM_NOT_INSTALLED",
              message: "Cannot open Instagram",
              details: nil))
        }
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }
}

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Needed so APNs delivers a device token before Dart calls FCM getToken().
    application.registerForRemoteNotifications()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "InstagramStoriesPlugin") {
      InstagramStoriesChannel.register(with: registrar)
    }
  }
}
