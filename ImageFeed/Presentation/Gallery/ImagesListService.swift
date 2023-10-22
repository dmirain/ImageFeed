import UIKit

final class ImagesListService {
    weak var controller: ImagesListViewController?
    private let imageListGateway: ImagesListGateway
    private var images: [ImageDto] = []
    private var nextPage: Int = 1
    
    var imagesCount: Int { images.count }

    init(imageListGateway: ImagesListGateway) {
        self.imageListGateway = imageListGateway
    }
    
    func setRequestBuilder(_ builder: RequestBuilder) {
        self.imageListGateway.requestBuilder = builder
    }
    
    func fetchPhotosNextPage() {
        print("loadNextPage")
        self.imageListGateway.fetchImagesPage(page: nextPage) { [weak self] result in
            guard let self else { return }

            switch result {
            case let .success(data):
                DispatchQueue.main.async {
                    self.addPageData(data: data)
                }
            case let .failure(error):
                print(error)
                break  //TODO обработать ошибку
            }
        }
    }
    
    private func addPageData(data: [ImageDto]) {
        print("addPageData")
        let oldCount = imagesCount
        images.append(contentsOf: data)
        nextPage += 1
        let newCount = imagesCount
        
        controller?.updateTableViewAnimated(addedIndexes: (oldCount..<newCount))
    }
    
    func imageHeight(byIndex index: Int, containerWidth: CGFloat) -> CGFloat {
        let image = imageCellModel(byIndex: index)
        return image.size.height * containerWidth / image.size.width
    }

    func imageCellModel(byIndex index: Int) -> ImageDto {
        images[index]
    }
    
    func toggleLike(byIndex index: Int) {
        print(images[index].id)
    }
}
