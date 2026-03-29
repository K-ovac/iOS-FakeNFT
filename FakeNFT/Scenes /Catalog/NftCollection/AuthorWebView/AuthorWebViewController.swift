//
//  AuthorWebViewController.swift
//  FakeNFT
//
//  Created by Максим Лозебной on 29.03.2026.
//


import UIKit
import WebKit

final class AuthorWebViewController: BaseWebViewController {
    
    // MARK: - Properties
    
    private let authorWebViewViewModel: AuthorWebViewViewModel
    
    // MARK: - Init
    
    init(authorWebViewViewModel: AuthorWebViewViewModel) {
        self.authorWebViewViewModel = authorWebViewViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}
