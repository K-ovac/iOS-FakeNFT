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
    
    var onProfileUpdated: (() -> Void)?
    
    private var updatedAvatarURL: String?
    private var activeTextField: UIView?
    private var originalScrollViewInsets: UIEdgeInsets?
    
    // MARK: - UI
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.keyboardDismissMode = .onDrag
        return view
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Avatar Section
    
    private lazy var avatarContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var cameraButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.backgroundColor = .white
        button.layer.cornerRadius = 11.29
        button.clipsToBounds = true
        
        let cameraImage = UIImage(systemName: "camera.fill")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 10, weight: .medium))
        button.setImage(cameraImage, for: .normal)
        button.tintColor = .black
        
        button.addTarget(self, action: #selector(changePhotoTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Labels
    
    private func makeLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private lazy var nameLabel = makeLabel("Имя")
    private lazy var descriptionLabel = makeLabel("Описание")
    private lazy var websiteLabel = makeLabel("Сайт")
    
    // MARK: - Inputs
    
    private func makeTextField(placeholder: String) -> UITextField {
        let field = UITextField()
        field.placeholder = placeholder
        field.font = .bodyRegular
        field.backgroundColor = .systemGray6
        field.layer.cornerRadius = 12
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        field.leftViewMode = .always
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }
    
    private lazy var nameTextField = makeTextField(placeholder: "Введите имя")
    private lazy var websiteTextField = makeTextField(placeholder: "Введите сайт")
    
    private lazy var descriptionTextView: UITextView = {
        let view = UITextView()
        view.font = .bodyRegular
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 12
        view.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Save Button

    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Сохранить", for: .normal)
        button.titleLabel?.font = .bodyBold
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let v = UIActivityIndicatorView(style: .medium)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.hidesWhenStopped = true
        return v
    }()
    
    // MARK: - Init
     init(profile: Profile?) {
         self.profile = profile
         let service = ProfileServiceImpl(networkClient: DefaultNetworkClient())
         self.viewModel = ProfileEditViewModel(profileService: service)
         super.init(nibName: nil, bundle: nil)
     }
     
     required init?(coder: NSCoder) { fatalError() }
     
     // MARK: - Lifecycle
     override func viewDidLoad() {
         super.viewDidLoad()
         setupUI()
         setupNavigationBar()
         setupKeyboardDismiss()
         setupTextFieldsDelegates()
         setupKeyboardNotifications()
         fillData()
         bindViewModel()
     }
     
     deinit {
         NotificationCenter.default.removeObserver(self)
     }
     
     // MARK: - Setup
     
     private func setupKeyboardNotifications() {
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
     
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let activeField = activeTextField else { return }
        
        let keyboardHeight = keyboardFrame.height
        let bottomOffset = keyboardHeight + 40
        
        if originalScrollViewInsets == nil {
            originalScrollViewInsets = scrollView.contentInset
        }
        
        var contentInsets = scrollView.contentInset
        contentInsets.bottom = bottomOffset
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        scrollView.layoutIfNeeded()
        
        let fieldFrame = activeField.convert(activeField.bounds, to: scrollView)
        let fieldBottom = fieldFrame.maxY
        let visibleHeight = scrollView.frame.height - keyboardHeight - 20
        
        let offsetY = max(0, (fieldBottom - visibleHeight)/2)
        
        scrollView.setContentOffset(CGPoint(x: 0, y: offsetY), animated: true)
    }
     
     @objc private func keyboardWillHide(_ notification: Notification) {
         if let originalInsets = originalScrollViewInsets {
             scrollView.contentInset = originalInsets
             scrollView.scrollIndicatorInsets = originalInsets
             originalScrollViewInsets = nil
         } else {
             scrollView.contentInset = .zero
             scrollView.scrollIndicatorInsets = .zero
         }
     }
    
    private func setupNavigationBar() {
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backTapped)
        )
        backButton.tintColor = .black
        navigationItem.leftBarButtonItem = backButton
        
        navigationController?.navigationBar.tintColor = .black
    }
    
    @objc private func backTapped() {
        let alert = UIAlertController(
            title: "Уверены, что хотите выйти?",
            message: nil,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Остаться", style: .cancel) { _ in })
        
        alert.addAction(UIAlertAction(title: "Выйти", style: .default) { [weak self] _ in
            self?.dismiss(animated: true)
        })
        
        present(alert, animated: true)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        view.addSubview(saveButton)
        view.addSubview(activityIndicator)
        
        scrollView.addSubview(contentView)
        
        // Аватар с иконкой камеры
        contentView.addSubview(avatarImageView)
        contentView.addSubview(cameraButton)
        contentView.addSubview(nameLabel)
        contentView.addSubview(nameTextField)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(descriptionTextView)
        contentView.addSubview(websiteLabel)
        contentView.addSubview(websiteTextField)
        
        NSLayoutConstraint.activate([
            // scroll
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -8),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            websiteTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            // avatar
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            avatarImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            
            // camera button
            cameraButton.trailingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 4),
            cameraButton.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 4),
            cameraButton.widthAnchor.constraint(equalToConstant: 22.57),
            cameraButton.heightAnchor.constraint(equalToConstant: 22.57),
            
            // name
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 24),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nameTextField.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            // description
            descriptionLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            descriptionTextView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 120),
            
            // website
            websiteLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 16),
            websiteLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            websiteTextField.topAnchor.constraint(equalTo: websiteLabel.bottomAnchor, constant: 8),
            websiteTextField.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            websiteTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            websiteTextField.heightAnchor.constraint(equalToConstant: 44),
            websiteTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            // save button
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            saveButton.heightAnchor.constraint(equalToConstant: 60),
            
            // loader
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupKeyboardDismiss() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupTextFieldsDelegates() {
        nameTextField.delegate = self
        websiteTextField.delegate = self
        descriptionTextView.delegate = self
    }
    
    private func fillData() {
        guard let profile else { return }
        
        nameTextField.text = profile.name
        descriptionTextView.text = profile.description
        websiteTextField.text = profile.website
        
        if let url = URL(string: profile.avatar) {
            avatarImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "person.crop.circle.fill"))
        } else {
            avatarImageView.image = UIImage(systemName: "person.crop.circle.fill")
            avatarImageView.tintColor = .systemGray3
        }
    }
    
    private func bindViewModel() {
        viewModel.onSaveSuccess = { [weak self] in
            self?.onProfileUpdated?()
            self?.dismiss(animated: true)
        }
        
        viewModel.onLoadingStateChange = { [weak self] isLoading in
            self?.saveButton.isEnabled = !isLoading
            self?.saveButton.alpha = isLoading ? 0.5 : 1
            
            if isLoading {
                self?.activityIndicator.startAnimating()
            } else {
                self?.activityIndicator.stopAnimating()
            }
        }
        
        viewModel.onError = { [weak self] message in
            self?.showError(message: message)
        }
    }
    
    private func showError(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Actions
    
    @objc private func saveTapped() {
        guard let profile else { return }
        
        guard !(nameTextField.text ?? "").isEmpty else {
            showError(message: "Введите имя")
            return
        }
        
        let updated = ProfileUpdate(
            name: nameTextField.text ?? "",
            avatar: updatedAvatarURL ?? profile.avatar,
            description: descriptionTextView.text ?? "",
            website: websiteTextField.text ?? "",
            likes: profile.likes,
            nfts: profile.nfts
        )
        
        viewModel.saveProfile(updated, profileId: "1")
    }
    
    @objc private func cancelTapped() {
        let alert = UIAlertController(
            title: "Уверены, что хотите выйти?",
            message: nil,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Остаться", style: .cancel) { _ in })
        
        alert.addAction(UIAlertAction(title: "Выйти", style: .default) { [weak self] _ in
            self?.dismiss(animated: true)
        })
        
        present(alert, animated: true)
    }
    
    @objc private func changePhotoTapped() {
        let alert = UIAlertController(
            title: "Фото профиля",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        alert.addAction(UIAlertAction(title: "Изменить фото", style: .default) { [weak self] _ in
            self?.showPhotoURLInput()
        })
        
        alert.addAction(UIAlertAction(title: "Удалить фото", style: .destructive) { [weak self] _ in
            self?.deletePhoto()
        })
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private let defaultAvatarURL: String? = nil

    @objc private func deletePhoto() {
        let alert = UIAlertController(
            title: "Удалить фото?",
            message: "Фото профиля будет удалено",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            self?.updatedAvatarURL = ""
            
            self?.avatarImageView.image = UIImage(systemName: "person.crop.circle.fill")
            self?.avatarImageView.tintColor = .systemGray3
            self?.avatarImageView.backgroundColor = .systemGray6
            self?.avatarImageView.contentMode = .center
            
            print("📸 Photo will be deleted (sent as empty string)")
        })
        
        present(alert, animated: true)
    }
    
    private func showPhotoURLInput() {
        let alert = UIAlertController(title: "Ссылка на фото", message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "http://example.com/image.jpg"
            textField.text = self.updatedAvatarURL ?? self.profile?.avatar
        }
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Сохранить", style: .default) { [weak self] _ in
            guard let text = alert.textFields?.first?.text,
                  let url = URL(string: text) else {
                self?.showError(message: "Некорректная ссылка")
                return
            }
            
            self?.updatedAvatarURL = text
            
            // Показываем индикатор загрузки
            self?.activityIndicator.startAnimating()
            
            KingfisherManager.shared.retrieveImage(with: url) { result in
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    
                    switch result {
                    case .success(let imageResult):
                        self?.avatarImageView.image = imageResult.image
                        print("✅ Avatar loaded successfully")
                    case .failure(let error):
                        print("❌ Failed to load avatar: \(error)")
                        self?.showError(message: "Не удалось загрузить изображение")
                        self?.updatedAvatarURL = nil
                    }
                }
            }
        })
        
        present(alert, animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UITextFieldDelegate
extension ProfileEditViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
}

// MARK: - UITextViewDelegate
extension ProfileEditViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        activeTextField = textView
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        activeTextField = nil
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
