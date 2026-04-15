//
//  UIImageView+Load.swift
//  FakeNFT
//
//  Created by Аркадий Червонный on 06.04.2026.
//

import UIKit

extension UIImageView {
    func setImage(from url: URL?) {
        guard let url else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard
                let data,
                let image = UIImage(data: data)
            else { return }

            DispatchQueue.main.async {
                self?.image = image
            }
        }.resume()
    }
}
