import Foundation

final class ImageLikeGateway {
    private let httpClient: NetworkClient
    private var tasks: [ImageDto: URLSessionTask] = [:]

    private let requestBuilder: RequestBuilder

    init(httpClient: NetworkClient, requestBuilder: RequestBuilder) {
        self.httpClient = httpClient
        self.requestBuilder = requestBuilder
    }

    func toggleLike(image: ImageDto, to createLike: Bool, handler: @escaping (NetworkError?) -> Void) {
        guard getLock(image) else { return }

        let request = createLike ? requestSetLike(image: image) : requestDelLike(image: image)

        let task = httpClient.fetch(from: request) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success:
                handler(nil)
            case let .failure(error):
                handler(error)
            }

            self.unlockForNext(image)
        }

        tasks[image] = task
    }
}

private extension ImageLikeGateway {
    func getLock(_ image: ImageDto) -> Bool {
        assert(Thread.isMainThread)
        return !tasks.keys.contains(image)
    }

    func unlockForNext(_ image: ImageDto) {
        tasks.removeValue(forKey: image)
    }

    func requestSetLike(image: ImageDto) -> URLRequest {
        requestBuilder.makeRequest(
            path: "/photos/\(image.id)/like",
            params: [],
            method: "POST"
        )
    }

    func requestDelLike(image: ImageDto) -> URLRequest {
        requestBuilder.makeRequest(
            path: "/photos/\(image.id)/like",
            params: [],
            method: "DELETE"
        )
    }
}
