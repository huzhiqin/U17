//
//  AppDelegate.swift
//  U17
//
//  Created by lyw on 2020/5/13.
//  Copyright © 2020 胡智钦. All rights reserved.
//

import UIKit

import Alamofire
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    // 监测网络
    lazy var reachability: NetworkReachabilityManager? = {
        return NetworkReachabilityManager(host: "http://app.u17.com")
    }()
    
    // 申明手机屏幕旋转方向
    var orientation: UIInterfaceOrientationMask = .portrait
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.rootViewController = TabBarController()
        window?.makeKeyAndVisible()

        // 配置
        setupBaseConfig()

        return true
    }
    
    func setupBaseConfig() {
        // 1.键盘处理
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true

        // 2.网络监控
        reachability?.listener = { status in
            switch status {
            case .reachable(.wwan):
                UNoticeBar(config: UNoticeBarConfig(title: "主人,检测到您正在使用移动数据")).show(duration: 2)
            default: break
            }
        }
        reachability?.startListening()
    }

    // 3.支持屏幕旋转
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return orientation
    }
}

extension UIApplication {
    // 4. 强制旋转屏幕
    class func changeOrientationTo(landscapeRight: Bool) {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }
        if landscapeRight == true {
            delegate.orientation = .landscapeRight
            UIApplication.shared.supportedInterfaceOrientations(for: delegate.window)
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        } else {
            delegate.orientation = .portrait
            UIApplication.shared.supportedInterfaceOrientations(for: delegate.window)
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        }
    }
}
