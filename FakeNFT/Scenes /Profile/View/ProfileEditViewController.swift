//
//  ProfileEditViewController.swift
//  FakeNFT
//
//  Created by Воробьева Юлия on 24.03.2026.
//

import UIKit
import Kingfisher

final class ProfileEditViewController: UIViewController {
    
    private let viewModel: ProfileEditViewModelProtocol
    private let profile: Profile?
    
    // MARK: - UI Elements
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var changePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Сменить фото", for: .normal)
        button.setTitleColor(.primary, for: .normal)
        button.titleLabel?.font = .caption1
        button.addTarget(self, action: #selector(changePhotoTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Text Fields
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Имя"
        label.font = .caption1
        label.textColor = .textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.font = .bodyRegular
        textField.borderStyle = .none
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 12
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Описание"
        label.font = .caption1
        label.textColor = .textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = .bodyRegular
        textView.backgroundColor = .systemGray6
        textView.layer.cornerRadius = 12
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var websiteLabel: UILabel = {
        let label = UILabel()
        label.text = "Сайт"
        label.font = .caption1
        label.textColor = .textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var websiteTextField: UITextField = {
        let textField = UITextField()
        textField.font = .bodyRegular
        textField.borderStyle = .none
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 12
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // MARK: - Init
    init(profile: Profile?) {
        self.profile = profile
        let profileService = ProfileServiceImpl(networkClient: DefaultNetworkClient())
        self.viewModel = ProfileEditViewModel(profileService: profileService)
        super.init(nibName: nil, bundle: nil)
        print("✏️ ProfileEditViewController init")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("✏️ ProfileEditViewController viewDidLoad")
        setupUI()
        setupNavigationBar()
        setupKeyboardHandling()
        fillData()
        bindViewModel()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(avatarImageView)
        contentView.addSubview(changePhotoButton)
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(nameTextField)
        
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(descriptionTextView)
        
        contentView.addSubview(websiteLabel)
        contentView.addSubview(websiteTextField)
        
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Avatar
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            avatarImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            
            changePhotoButton.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            changePhotoButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            // Name
            nameLabel.topAnchor.constraint(equalTo: changePhotoButton.bottomAnchor, constant: 24),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            // Description
            descriptionLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            descriptionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 120),
            
            // Website
            websiteLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 16),
            websiteLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            websiteLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            websiteTextField.topAnchor.constraint(equalTo: websiteLabel.bottomAnchor, constant: 8),
            websiteTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            websiteTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            websiteTextField.heightAnchor.constraint(equalToConstant: 44),
            websiteTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            // Activity Indicator
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        let doneButton = UIBarButtonItem(
            title: "",
            style: .done,
            target: self,
            action: #selector(saveTapped)
        )
        navigationItem.rightBarButtonItem = doneButton
        
        let cancelButton = UIBarButtonItem(
            title: "",
            style: .plain,
            target: self,
            action: #selector(cancelTapped)
        )
        navigationItem.leftBarButtonItem = cancelButton
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupKeyboardHandling() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func fillData() {
        guard let profile = profile else { return }
        
        nameTextField.text = profile.name
        descriptionTextView.text = profile.description ?? ""
        websiteTextField.text = profile.website
        
        if let url = URL(string: profile.avatar) {
            avatarImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "person.crop.circle.fill"))
        }
    }
    
    private func bindViewModel() {
        viewModel.onSaveSuccess = { [weak self] in
            print("✏️ Save success, dismissing")
            DispatchQueue.main.async {
                self?.dismiss(animated: true)
            }
        }
        
        viewModel.onLoadingStateChange = { [weak self] isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                }
            }
        }
        
        viewModel.onError = { [weak self] errorMessage in
            print("✏️ Save error: \(errorMessage)")
            DispatchQueue.main.async {
                self?.showError(message: errorMessage)
            }
        }
    }
    
    private func showError(message: String) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Actions
    @objc private func changePhotoTapped() {
        print("Change photo tapped - будет реализовано позже")
        let alert = UIAlertController(
            title: "Смена фото",
            message: "Функция будет добавлена позже",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func saveTapped() {
        guard let profile = profile else { return }
        
        let updatedProfile = ProfileUpdate(
            name: nameTextField.text ?? "",
            avatar: profile.avatar,
            description: descriptionTextView.text.isEmpty ? nil : descriptionTextView.text,
            website: websiteTextField.text ?? "",
            likes: profile.likes,
            nfts: profile.nfts
        )
        viewModel.saveProfile(updatedProfile)
    }
    
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
