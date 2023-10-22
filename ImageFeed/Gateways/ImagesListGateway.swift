import Foundation

final class ImagesListGateway {
    private let httpClient: NetworkClient
    private var task: URLSessionTask?
    var requestBuilder: RequestBuilder?

    init(httpClient: NetworkClient) {
        self.httpClient = httpClient
    }

    func fetchImagesPage(page: Int, handler: @escaping (Result<[ImageDto], NetworkError>) -> Void) {
        guard requestBuilder != nil else {
            handler(.failure(.authFaild))
            return
        }

        guard isLockedForNext() else { return }
        
        task = httpClient.fetchObject(
            from: request(page: page),
            as: [ImageItemResponse].self
        ) { [weak self] result in
            guard let self else { return }

            switch result {
            case let .success(response):
                let result = response
                    .map { ImageDto.fromImageItemResponse($0) }
                    .filter { $0.largeImageURL != nil && $0.thumbImageURL != nil }
                
                handler(.success(result))
            case let .failure(error):
                handler(.failure(error))
            }

            self.unlockForNext()
        }
    }
}

private extension ImagesListGateway {
    func isLockedForNext() -> Bool {
        assert(Thread.isMainThread)
        return task == nil
    }

    func unlockForNext() {
        task = nil
    }

    func request(page: Int) -> URLRequest {
        requestBuilder!.makeRequest(
            path: "/photos",
            params: [URLQueryItem(name: "page", value: String(page))],
            method: "GET"
        )
    }
}
