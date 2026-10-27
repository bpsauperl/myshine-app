import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    PrivacyCover.install()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}

/// Blurs the app while it isn't active, so the app switcher doesn't show the
/// patient's messages, photos or plan.
enum PrivacyCover {
  private static let tag = 0x5A1E

  static func install() {
    let center = NotificationCenter.default
    center.addObserver(
      forName: UIScene.willDeactivateNotification, object: nil, queue: .main
    ) { note in
      windows(of: note).forEach(cover)
    }
    center.addObserver(
      forName: UIScene.didActivateNotification, object: nil, queue: .main
    ) { note in
      windows(of: note).forEach { $0.viewWithTag(tag)?.removeFromSuperview() }
    }
  }

  private static func windows(of note: Notification) -> [UIWindow] {
    (note.object as? UIWindowScene)?.windows ?? []
  }

  private static func cover(_ window: UIWindow) {
    guard window.viewWithTag(tag) == nil else { return }
    let blur = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
    blur.frame = window.bounds
    blur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    blur.tag = tag
    window.addSubview(blur)
  }
}
