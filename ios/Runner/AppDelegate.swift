import UIKit
import Flutter
import flutter_downloader
import flutter_local_notifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    // Register plugins normally
    GeneratedPluginRegistrant.register(with: self)
    
    // Setup Flutter Downloader
    FlutterDownloaderPlugin.setPluginRegistrantCallback(registerPlugins)
    
    // Setup Local Notifications (important if background isolates need plugin access)
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { registry in
      GeneratedPluginRegistrant.register(with: registry)
    }
    
    // Prevent screen recording / screenshots
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(screenCaptureDidChange),
      name: UIScreen.capturedDidChangeNotification,
      object: nil
    )
    checkScreenCapture()
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  @objc private func screenCaptureDidChange() {
    checkScreenCapture()
  }
  
  private func checkScreenCapture() {
    if UIScreen.main.isCaptured {
      showPrivacyOverlay()
    } else {
      hidePrivacyOverlay()
    }
  }
  
  private func showPrivacyOverlay() {
    if self.window?.viewWithTag(999999) == nil {
      let overlay = UIView(frame: UIScreen.main.bounds)
      overlay.backgroundColor = UIColor.black
      overlay.tag = 999999
      self.window?.addSubview(overlay)
    }
  }
  
  private func hidePrivacyOverlay() {
    self.window?.viewWithTag(999999)?.removeFromSuperview()
  }
}

// Register background isolate plugins for flutter_downloader
private func registerPlugins(registry: FlutterPluginRegistry) {
    if !registry.hasPlugin("FlutterDownloaderPlugin") {
        FlutterDownloaderPlugin.register(
          with: registry.registrar(forPlugin: "FlutterDownloaderPlugin")!
        )
    }
}
