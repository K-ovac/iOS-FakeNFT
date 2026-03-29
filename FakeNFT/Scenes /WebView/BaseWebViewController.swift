//
//  BaseWebViewController.swift
//  FakeNFT
//
//  Created by Максим Лозебной on 29.03.2026.
//

import UIKit
import WebKit

class BaseWebViewController: UIViewController {
    
    // MARK: - UI Components
    
    private lazy var webView = WKWebView()
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progressTintColor = .primaryForeground
        
        return progressView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configureView()
        
        webView.navigationDelegate = self
    }
    
    // MARK: - Configure UI
    
    private func configureNavBar() {
        let backButton = UIBarButtonItem(
            image: Images.back,
            style: .plain,
            target: self,
            action: #selector(backButtonTapped))
        backButton.tintColor = .primaryForeground
        
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func configureView() {
        view.backgroundColor = .background
        webView.backgroundColor = .background
        [webView, progressView].forEach {
            view.addSubview($0)
        }
        setupLayout()
    }
    
    // MARK: - Setup Layout
    
    private func setupLayout() {
        [webView, progressView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    // MARK: - Action
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Public Method
    
    func load(url: String) {
        guard let url = URL(string: url) else { return }
        webView.load(URLRequest(url: url))
    }
}

// MARK: - Extension BaseWebViewController: WKNavigationDelegate

extension BaseWebViewController: WKNavigationDelegate {
    // TODO: - черновой вариант загрузки
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        progressView.progress = 0
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.progress = 1
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        progressView.isHidden = true
    }
}
