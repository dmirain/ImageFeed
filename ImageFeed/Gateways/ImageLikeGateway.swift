import Foundation

final class ImageLikeGateway {
    private let httpClient: NetworkClient
    private let requestHelper: RequestHelper

    private var tasks: [ImageDto: URLSessionTask] = [:]

    init(httpClient: NetworkClient, requestHelper: RequestHelper) {
        self.httpClient = httpClient
        self.requestHelper = requestHelper
    }

    func toggleLike(image: ImageDto, to createLike: Bool, handler: @escaping (Bool) -> Void) {
        guard getLock(image) else { return }

        let request = createLike ? requestSetLike(image: image) : requestDelLike(image: image)

        let task = httpClient.fetch(from: request) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success:
                handler(true)
            case .failure:
                handler(false)
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
        requestHelper.makeApiRequest(
            path: "/photos/\(image.id)/like",
            params: [],
            method: "POST"
        )
    }

    func requestDelLike(image: ImageDto) -> URLRequest {
        requestHelper.makeApiRequest(
            path: "/photos/\(image.id)/like",
            params: [],
            method: "DELETE"
        )
    }
}
