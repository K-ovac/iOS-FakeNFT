final class ServicesAssembly {

    private let networkClient: NetworkClient

    init(
        networkClient: NetworkClient,
    ) {
        self.networkClient = networkClient
    }
    
    var collectionsService: CollectionsService {
        CollectionsServiceImpl(
            networkClient: networkClient
        )
    }
    
    var profileService: ProfileService {
        ProfileServiceImpl(networkClient: networkClient)
    }
}
