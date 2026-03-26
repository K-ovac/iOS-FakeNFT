//
//  CatalogCell.swift
//  FakeNFT
//
//  Created by Максим Лозебной on 25.03.2026.
//
import UIKit

final class CatalogCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = String(describing: CatalogCell.self)
    
    // MARK: - UI Components
    
    private lazy var nftImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = Metrics.CornerRadius.medium
        
        return imageView
    }()
    
    private lazy var nftNameLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .textPrimary
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var nftCountLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .textPrimary
        
        return label
    }()
    
    // MARK: Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure UI
    
    private func configureView() {
        contentView.backgroundColor = .background
        selectionStyle = .none
        
        [nftImageView, nftNameLabel, nftCountLabel].forEach {
            contentView.addSubview($0)
        }
        
        setupLayout()
    }
    private func setupLayout() {
        [nftImageView, nftCountLabel, nftNameLabel].forEach {
            ($0).translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Metrics.Spacing.verySmall),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Metrics.Spacing.medium),
            nftImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Metrics.Spacing.medium),
            nftImageView.bottomAnchor.constraint(equalTo: nftNameLabel.topAnchor, constant: -Metrics.Spacing.verySmall)
        ])
        NSLayoutConstraint.activate([
            nftNameLabel.leadingAnchor.constraint(equalTo: nftImageView.leadingAnchor),
            nftNameLabel.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: Metrics.Spacing.verySmall),
            nftNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Metrics.Spacing.medium2)
        ])
        NSLayoutConstraint.activate([
            nftCountLabel.centerYAnchor.constraint(equalTo: nftNameLabel.centerYAnchor),
            nftCountLabel.leadingAnchor.constraint(equalTo: nftNameLabel.trailingAnchor, constant: Metrics.Spacing.verySmall),
        ])
    }
    
    // MARK: - Configure Cell
    
    func configure(with catalog: Catalog) {
        if let url = URL(string: catalog.cover) {
            nftImageView.kf.setImage(with: url)
        }
        nftNameLabel.text = catalog.name
        nftCountLabel.text = "(\(catalog.nfts.count))"
    }
}
