//
//  ProfileEditViewModel.swift
//  FakeNFT
//
//  Created by Воробьева Юлия on 24.03.2026.
//

import Foundation

protocol ProfileEditViewModelProtocol: AnyObject {
    var onSaveSuccess: (() -> Void)? { get set }
    var onLoadingStateChange: ((Bool) -> Void)? { get set }
    var onError: ((String) -> Void)? { get set }
    
    func saveProfile(_ profile: ProfileUpdate)
}

final class ProfileEditViewModel: ProfileEditViewModelProtocol {
    var onSaveSuccess: (() -> Void)?
    var onLoadingStateChange: ((Bool) -> Void)?
    var onError: ((String) -> Void)?
    
    private let profileService: ProfileService
    
    init(profileService: ProfileService) {
        self.profileService = profileService
        print("📦 ProfileEditViewModel initialized")
    }
    
    func saveProfile(_ profile: ProfileUpdate) {
        print("🔄 Saving profile...")
        onLoadingStateChange?(true)
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.profileService.updateProfile(profile: profile) { result in
                DispatchQueue.main.async {
                    self?.onLoadingStateChange?(false)
                    
                    switch result {
                    case .success:
                        print("✅ Profile saved successfully")
                        self?.onSaveSuccess?()
                    case .failure(let error):
                        print("❌ Profile save error: \(error)")
                        self?.onError?(error.localizedDescription)
                    }
                }
            }
        }
    }
}
