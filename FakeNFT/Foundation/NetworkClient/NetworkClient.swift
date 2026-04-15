import Foundation

enum NetworkClientError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case parsingError
}

protocol NetworkClient {
    @discardableResult
    func send(request: NetworkRequest,
              completionQueue: DispatchQueue,
              onResponse: @escaping (Result<Data, Error>) -> Void) -> NetworkTask?

    @discardableResult
    func send<T: Decodable>(request: NetworkRequest,
                            type: T.Type,
                            completionQueue: DispatchQueue,
                            onResponse: @escaping (Result<T, Error>) -> Void) -> NetworkTask?
}

extension NetworkClient {

    @discardableResult
    func send(request: NetworkRequest,
              onResponse: @escaping (Result<Data, Error>) -> Void) -> NetworkTask? {
        send(request: request, completionQueue: .main, onResponse: onResponse)
    }

    @discardableResult
    func send<T: Decodable>(request: NetworkRequest,
                            type: T.Type,
                            onResponse: @escaping (Result<T, Error>) -> Void) -> NetworkTask? {
        send(request: request, type: type, completionQueue: .main, onResponse: onResponse)
    }
}

struct DefaultNetworkClient: NetworkClient {
    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = URLSession.shared,
         decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }

    @discardableResult
    func send(
        request: NetworkRequest,
        completionQueue: DispatchQueue,
        onResponse: @escaping (Result<Data, Error>) -> Void
    ) -> NetworkTask? {
        let onResponse: (Result<Data, Error>) -> Void = { result in
            completionQueue.async {
                onResponse(result)
            }
        }
        guard let urlRequest = create(request: request) else { return nil }
        
        print("📤 Sending request to: \(urlRequest.url?.absoluteString ?? "unknown")")
        print("📤 HTTP Method: \(urlRequest.httpMethod ?? "unknown")")
        print("📤 Headers: \(urlRequest.allHTTPHeaderFields ?? [:])")
        if let httpBody = urlRequest.httpBody, let bodyString = String(data: httpBody, encoding: .utf8) {
            print("📤 Body: \(bodyString)")
        }

        let task = session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print("❌ Network error: \(error)")
                onResponse(.failure(NetworkClientError.urlRequestError(error)))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("❌ Invalid response")
                onResponse(.failure(NetworkClientError.urlSessionError))
                return
            }

            print("📥 Response status code: \(response.statusCode)")
            
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("📥 Response body: \(responseString)")
            }

            guard 200 ..< 300 ~= response.statusCode else {
                print("❌ HTTP error: \(response.statusCode)")
                onResponse(.failure(NetworkClientError.httpStatusCode(response.statusCode)))
                return
            }

            if let data = data {
                onResponse(.success(data))
                return
            } else {
                print("❌ No data received")
                onResponse(.failure(NetworkClientError.urlSessionError))
                return
            }
        }

        task.resume()

        return DefaultNetworkTask(dataTask: task)
    }

    @discardableResult
    func send<T: Decodable>(
        request: NetworkRequest,
        type: T.Type,
        completionQueue: DispatchQueue,
        onResponse: @escaping (Result<T, Error>) -> Void
    ) -> NetworkTask? {
        return send(request: request, completionQueue: completionQueue) { result in
            switch result {
            case let .success(data):
                self.parse(data: data, type: type, onResponse: onResponse)
            case let .failure(error):
                onResponse(.failure(error))
            }
        }
    }

    // MARK: - Private

    private func create(request: NetworkRequest) -> URLRequest? {
        guard let endpoint = request.endpoint else {
            assertionFailure("Empty endpoint")
            return nil
        }
        
        print("🌐 Creating request: \(request.httpMethod.rawValue) \(endpoint)")
        
        var urlRequest = URLRequest(url: endpoint)
        urlRequest.httpMethod = request.httpMethod.rawValue
        
        let token = RequestConstants.token
        urlRequest.addValue(token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        print("🔑 Token added: \(token)")

        if let headers = request.headers {
            for (key, value) in headers {
                urlRequest.addValue(value, forHTTPHeaderField: key)
                print("📋 Custom header: \(key): \(value)")
            }
        }

        if let dto = request.dto {
            let parameters = dto.asDictionary()
            
            if !parameters.isEmpty {
                var components = URLComponents()
                components.queryItems = parameters.map {
                    URLQueryItem(name: $0.key, value: $0.value)
                }
                urlRequest.httpBody = components.query?.data(using: .utf8)
                urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                print("📦 Sending as URL-encoded with parameters: \(parameters)")
            }
        } else {
            print("📦 No body")
        }

        return urlRequest
    }

    private func parse<T: Decodable>(data: Data, type _: T.Type, onResponse: @escaping (Result<T, Error>) -> Void) {
        do {
            let response = try decoder.decode(T.self, from: data)
            print("✅ Successfully parsed response")
            onResponse(.success(response))
        } catch {
            print("❌ Parsing error: \(error)")
            if let string = String(data: data, encoding: .utf8) {
                print("Raw data: \(string)")
            }
            onResponse(.failure(NetworkClientError.parsingError))
        }
    }
}
