//
//  UIViewControllerExtension.swift
//  Klikdokter
//
//  Created by Huy Lai on 3/10/22.
//

import UIKit
import NotificationBannerSwift
import NVActivityIndicatorView

extension UIViewController {
    func createBanner(_ title: String, _ style: BannerStyle, duration: Double? = 3) {
        if let appDelegate = UIApplication.shared.delegate,
           let appWindow = appDelegate.window,
           appWindow?.viewWithTag(100) != nil {
            return
        }
        let banner = GrowingNotificationBanner(title: title,
                                               subtitle: "", style: style)
        if style == .danger {
            banner.backgroundColor = .red
        } else if style == .success {
            banner.backgroundColor = .green
        }
        banner.tag = 100
        banner.duration = duration ?? 3.0
        banner.show()
    }

    func showLoading() {
        if let _ = self.view.viewWithTag(100) {
            return
        }
        let loadingView = UIView(frame: self.view.bounds)
        loadingView.tag = 100
        loadingView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        let spinningView = NVActivityIndicatorView(frame: CGRect(x: loadingView.center.x - 25, y: loadingView.center.y - 25, width: 50, height: 50), type: .lineScale, color: UIColor.white, padding: nil)
        loadingView.addSubview(spinningView)
        self.view.addSubview(loadingView)
        spinningView.startAnimating()
    }

    func dismissLoading() {
        if let loadingView = self.view.viewWithTag(100) {
            loadingView.removeFromSuperview()
        }
    }
}
