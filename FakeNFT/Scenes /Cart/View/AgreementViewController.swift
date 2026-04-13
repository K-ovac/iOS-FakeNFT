//
//  AgreementViewController.swift
//  FakeNFT
//
//  Created by Аркадий Червонный on 13.04.2026.
//

import UIKit
import WebKit

final class AgreementViewController: UIViewController {
    
    // MARK: - Properties
    
    private let url: URL
    private let webView = WKWebView()
    
    // MARK: - Init
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Пользовательское соглашение"
        
        setupUI()
        loadPage()
    }
}

private extension AgreementViewController {
    func setupUI() {
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func loadPage() {
        webView.load(URLRequest(url: url))
    }
}
