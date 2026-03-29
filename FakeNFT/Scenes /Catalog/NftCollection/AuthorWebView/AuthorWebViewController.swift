//
//  AuthorWebViewController.swift
//  FakeNFT
//
//  Created by Максим Лозебной on 29.03.2026.
//


import UIKit

final class AuthorWebViewController: BaseWebViewController {
    
    // MARK: - Properties
    
    private let url: String
    
    // MARK: - Init
    
    init(url: String) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        load(url: url)
    }
    
}
