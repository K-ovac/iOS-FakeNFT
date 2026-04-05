//
//  UIBlockingProgressHUD.swift
//  FakeNFT
//
//  Created by Максим Лозебной on 04.04.2026.
//

import UIKit
import ProgressHUD

// MARK: - UIBlockingProgressHUD

final class UIBlockingProgressHUD {
    private static var window: UIWindow? {
        UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
    
    // MARK: - Show ProgressHUD Method
    
    static func show() {
        DispatchQueue.main.async {
            window?.isUserInteractionEnabled = false
            ProgressHUD.show()
        }
    }
    
    // MARK: - Dismiss ProgressHUD Method
    
    static func dismiss() {
        DispatchQueue.main.async {
            window?.isUserInteractionEnabled = true
            ProgressHUD.dismiss()
        }
    }
}
