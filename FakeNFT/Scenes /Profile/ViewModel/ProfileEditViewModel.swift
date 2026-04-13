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
    
    func saveProfile(_ profile: ProfileUpdate, profileId: String)
}

final class ProfileEditViewModel: ProfileEditViewModelProtocol {
    var onSaveSuccess: (() -> Void)?
    var onLoadingStateChange: ((Bool) -> Void)?
    var onError: ((String) -> Void)?
    
    private let profileService: ProfileService
    
    init(profileService: ProfileService) {
        self.profileService = profileService
    }
    
    func saveProfile(_ profile: ProfileUpdate, profileId: String) {
        onLoadingStateChange?(true)
        
        profileService.updateProfile(id: profileId, profile: profile) { [weak self] result in
            DispatchQueue.main.async {
                self?.onLoadingStateChange?(false)
                
                switch result {
                case .success:
                    self?.onSaveSuccess?()
                case .failure(let error):
                    self?.onError?(error.localizedDescription)
                }
            }
        }
    }
}
