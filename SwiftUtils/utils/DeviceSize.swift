//
//  SizeInfo.swift
//  ISawIt
//
//  Created by liujiang on 2020/9/25.
//  Copyright © 2020 liujiang. All rights reserved.
//

import UIKit
extension UIScreen {
    class var isFullScreen: Bool {
        get {
            if #available(iOS 11.0, *) {
                guard let window = UIApplication.shared.delegate?.window else {
                    return false
                }
                return window?.safeAreaInsets.bottom ?? 0 > 0
            }
            return false
            
        }
    }
    class var isPortrait: Bool {
        get {
            return UIApplication.shared.statusBarOrientation == .portrait || UIApplication.shared.statusBarOrientation == .portraitUpsideDown
        }
    }
    class var sizeInfo: (statusBarHeight: CGFloat, navigationBarHeight: CGFloat, headerHeight: CGFloat, homeIndicatorHeight: CGFloat, tabBarHeight:CGFloat, footerHeight: CGFloat) {
        get {
            var statusBarH = UIApplication.shared.statusBarFrame.size.height
            let window = UIApplication.shared.delegate?.window
            if statusBarH <= 0 {
                if UIDevice.current.userInterfaceIdiom == .pad, #available(iOS 11.0, *), let _window = window, let bottom = _window?.safeAreaInsets.bottom, bottom > 0 {
                    statusBarH = 24.0
                }else if UIDevice.current.userInterfaceIdiom == .phone, #available(iOS 11.0, *), let _window = window, let bottom = _window?.safeAreaInsets.bottom, bottom > 0 {
                    statusBarH = 44.0
                }else {
                    statusBarH = 20.0
                }
            }
            let navH = UIDevice.current.userInterfaceIdiom == .pad ? CGFloat(50.0) : CGFloat(44.0)
            let homeIndicatorH: CGFloat = self.isFullScreen ? 34 : 0
            return (statusBarHeight: statusBarH, navigationBarHeight: navH, headerHeight: navH+statusBarH, homeIndicatorHeight: homeIndicatorH, tabBarHeight:49, footerHeight: homeIndicatorH + 49)
        }
    }
    class var frame: CGRect {
        get {
            return CGRect(origin: CGPoint.zero, size: CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        }
    }
    class var width: CGFloat {
        get {
            return UIScreen.main.bounds.size.width
        }
    }
    class var height: CGFloat {
        get {
            return UIScreen.main.bounds.size.height
        }
    }
    class var origin: CGPoint {
        get {
            return CGPoint.zero
        }
    }
    class var size: CGSize {
        get {
            return UIScreen.main.bounds.size
        }
    }
}

extension UIApplication {
    class func currentViewController() -> UIViewController? {
        guard var rootVC = self.shared.keyWindow?.rootViewController else {
            return nil
        }
        while rootVC.presentedViewController != nil {
            rootVC = rootVC.presentedViewController!
        }
        return self.recursiveChildController(rootVC)
        
    }
    private class func recursiveChildController(_ child: UIViewController?) -> UIViewController? {
        guard let _child = child else {
            return nil
        }
        if let nav = _child as? UINavigationController {
            return self.recursiveChildController(nav.topViewController)
        }else if let tab = _child as? UITabBarController {
            return self.recursiveChildController(tab.selectedViewController)
        }
        
        return _child
    }
    
    class func currentNavigationController() -> UINavigationController? {
        return self.currentViewController()?.navigationController
    }
    
    class func currentNavigationControllerOtherwiseViewController() -> UIViewController? {
        let current = self.currentViewController()
        return current?.navigationController ?? current
    }
    
    class func dismissAllPresentedViewController(_ completion: @escaping () -> ()) {
        guard let rootVC = self.shared.keyWindow?.rootViewController else {
            return completion()
        }
        
        if rootVC.presentedViewController != nil {
            self.currentNavigationControllerOtherwiseViewController()?.dismiss(animated: false, completion: {
                self.dismissAllPresentedViewController(completion)
            })
            return
        }
        return completion()
    }
    
    class var firstDisplayingViewControllers: [UIViewController] {
        guard let rootVC = self.shared.delegate?.window??.rootViewController else {
            return []
        }
        return self.mostNearlyContainerViewController(rootVC) ?? []
    }
    private class func mostNearlyContainerViewController(_ vc: UIViewController?) -> [UIViewController]? {
        guard let _child = vc else {
            return nil
        }
        if let nav = _child as? UINavigationController {
            return self.mostNearlyContainerViewController(nav.children.first)
        }else if let tab = _child as? UITabBarController {
            var arr = [UIViewController]()
            for child in tab.children {
                if let found = self.mostNearlyContainerViewController(child) {
                    arr.append(contentsOf: found)
                }
            }
            return arr
        }
        return [_child]
    }
}

extension UINavigationController {
    @objc func popViewController(animated: Bool, completion: @escaping () -> Void) {
        popViewController(animated: animated)
        
        if animated, let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion()
            }
        } else {
            completion()
        }
    }
    
    @objc func pushViewController(_ viewController: UIViewController, animated: Bool, completion: @escaping () -> Void) {
        pushViewController(viewController, animated: animated)
        
        if animated, let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion()
            }
        } else {
            completion()
        }
    }
}

extension Float {
    var rpx: CGFloat {
        get {
            let screenWidth = UIScreen.main.bounds.width
            return CGFloat(self) * (screenWidth / 375.0)
        }
    }
}
extension Int {
    var rpx: CGFloat {
        get {
            let screenWidth = UIScreen.main.bounds.width
            return CGFloat(self) * (screenWidth / 375.0)
        }
    }
}
extension CGFloat {
    var rpx: CGFloat {
        get {
            let screenWidth = UIScreen.main.bounds.width
            return CGFloat(self) * (screenWidth / 375.0)
        }
    }
}
extension Double {
    var rpx: CGFloat {
        get {
            let screenWidth = UIScreen.main.bounds.width
            return CGFloat(self) * (screenWidth / 375.0)
        }
    }
}
