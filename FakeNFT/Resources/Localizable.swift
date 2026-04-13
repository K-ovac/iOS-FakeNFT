//
//  Localizable.swift
//  FakeNFT
//
//  Created by Воробьева Юлия on 05.04.2026.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized(with arguments: CVarArg...) -> String {
        return String(format: self.localized(), arguments: arguments)
    }
}

enum LocalizableKeys {
    
    // MARK: - TabBar
    static let tabProfile = "Tab.profile".localized()
    static let tabCatalog = "Tab.catalog".localized()
    static let tabCart = "Tab.cart".localized()
    static let tabStatistics = "Tab.statistics".localized()
    
    // MARK: - Catalog
    static let catalogOpenNft = "Catalog.openNft".localized()
    static let catalogSortTitle = "Catalog.sort.title".localized()
    static let catalogSortByName = "Catalog.sort.byName".localized()
    static let catalogSortByNftCount = "Catalog.sort.byNftCount".localized()
    static let catalogSortCancel = "Catalog.sort.cancel".localized()
    
    //
    static let refreshControlTitle = "RefreshControl.title".localized()
    
    // MARK: - Nft Collection
    
    static let collectionAuthor = "Collection.author".localized()
    
    // MARK: - Common Errors
    static let errorTitle = "Error.title".localized()
    static let errorNetwork = "Error.network".localized()
    static let errorUnknown = "Error.unknown".localized()
    static let errorRepeat = "Error.repeat".localized()
    static let errorCancel = "Error.cancel".localized()
    
    // MARK: - Profile
    static let profileMyNft = "Profile.myNft".localized()
    static let profileFavorites = "Profile.favorites".localized()
    
    // MARK: - Favorites Screen
    static let favoritesEmpty = "Favorites.empty".localized()
    static let favoritesRemoveConfirmationTitle = "Favorites.removeConfirmationTitle".localized()
    static let favoritesRemove = "Favorites.remove".localized()
    static let favoritesCancel = "Favorites.cancel".localized()
    
    static func favoritesRemoveConfirmationMessage(with nftName: String) -> String {
        return String(format: "Favorites.removeConfirmationMessage".localized(), nftName)
    }
    
    // MARK: - My NFTs Screen
    static let myNftsEmpty = "MyNFTs.empty".localized()
    static let fromAuthor = "MyNFT.fromAuthor".localized()
    
    // MARK: - Sort Options
    static let sortTitle = "Sort.title".localized()
    static let sortByPrice = "Sort.byPrice".localized()
    static let sortByRating = "Sort.byRating".localized()
    static let sortByName = "Sort.byName".localized()
    static let sortCancel = "Sort.cancel".localized()
    
    // MARK: - Edit Profile Screen
    static let editProfileTitle = "EditProfile.title".localized()
    static let editProfileName = "EditProfile.name".localized()
    static let editProfileDescription = "EditProfile.description".localized()
    static let editProfileWebsite = "EditProfile.website".localized()
    static let editProfileNamePlaceholder = "EditProfile.namePlaceholder".localized()
    static let editProfileWebsitePlaceholder = "EditProfile.websitePlaceholder".localized()
    static let editProfileSave = "EditProfile.save".localized()
    static let editProfilePhotoTitle = "EditProfile.photoTitle".localized()
    static let editProfileChangePhoto = "EditProfile.changePhoto".localized()
    static let editProfileDeletePhoto = "EditProfile.deletePhoto".localized()
    static let editProfileCancel = "EditProfile.cancel".localized()
    static let editProfileDeleteConfirmationTitle = "EditProfile.deleteConfirmationTitle".localized()
    static let editProfileDeleteConfirmationMessage = "EditProfile.deleteConfirmationMessage".localized()
    static let editProfilePhotoURLTitle = "EditProfile.photoURLTitle".localized()
    static let editProfilePhotoURLPlaceholder = "EditProfile.photoURLPlaceholder".localized()
    static let editProfilePhotoURLInvalid = "EditProfile.photoURLInvalid".localized()
    static let editProfileImageLoadError = "EditProfile.imageLoadError".localized()
    static let editProfileExitConfirmationTitle = "EditProfile.exitConfirmationTitle".localized()
    static let editProfileExitConfirmationStay = "EditProfile.exitConfirmationStay".localized()
    static let editProfileExitConfirmationExit = "EditProfile.exitConfirmationExit".localized()
    static let editProfileNameRequired = "EditProfile.nameRequired".localized()
    
    // MARK: - Error Messages
    static let errorRemoveFailed = "Error.removeFailed".localized()
    static let errorUpdateFailed = "Error.updateFailed".localized()
    
    // MARK: - Price Label
    static let priceTitle = "Price.title".localized()
}
