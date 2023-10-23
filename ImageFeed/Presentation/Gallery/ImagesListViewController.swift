import UIKit
import Swinject

// MARK: - ImagesListViewController

final class ImagesListViewController: BaseUIViewController {
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private let imagesListService: ImagesListService
    private let contentView: ImagesListTableUIView
    private let diResolver: Resolver
    private var imageTableObserver: NSObjectProtocol?

    init(diResolver: Resolver, imagesListService: ImagesListService) {
        self.imagesListService = imagesListService
        self.diResolver = diResolver
        contentView = ImagesListTableUIView()

        super.init(nibName: nil, bundle: nil)

        self.imagesListService.controller = self
        self.contentView.setDelegates(tableDataSource: self, tableDelegate: self)
        tabBarItem = UITabBarItem(title: nil, image: UIImage.mainTabImage, selectedImage: nil)
        subscribeOnTableUpdate()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.initOnDidLoad()
    }

    func setToken(_ token: String) {
        let requestBuilder = diResolver.resolve(RequestBuilder.self, argument: token)!
        imagesListService.setRequestBuilder(requestBuilder)
    }

    func fetchPhotosNextPage() {
        imagesListService.fetchPhotosNextPage()
    }

    func reloadRow(at index: Int) {
        contentView.reloadRow(at: index)
    }

    private func subscribeOnTableUpdate() {

        imageTableObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.DidChangeNotification, object: nil, queue: .main
        ) { [weak self] data in
            print("Table update")
            guard let self else { return }
            if let addedIndexes = data.userInfo?["addedIndexes"] as? Range<Int> {
                print("Table update \(addedIndexes)")
                self.contentView.updateTableViewAnimated(addedIndexes: addedIndexes)
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        imagesListService.imagesCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)

        guard let imageListCell = cell as? ImagesListCell else {
            assertionFailure("unknown cell")
            return UITableViewCell()
        }

        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }

    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        cell.controller = self
        let cellModel = imagesListService.imageCellModel(byIndex: indexPath.row)
        cell.configureCell(with: cellModel)
    }
}

// MARK: - UITableViewDelegate

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = diResolver.resolve(SingleImageViewController.self)

        guard let viewController else { return }

        let imageModel = imagesListService.imageCellModel(byIndex: indexPath.row)
        viewController.setModel(imageCellModel: imageModel)
        present(viewController, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        imagesListService.imageHeight(byIndex: indexPath.row, containerWidth: tableView.bounds.width) + Const.cellIndent
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row > imagesListService.imagesCount - 3 {
            imagesListService.fetchPhotosNextPage()
        }
    }
}

// MARK: - ImagesListCellDelegate

extension ImagesListViewController: ImagesListCellDelegate {
    func likeButtonClicked(_ cell: ImagesListCell) {
        guard let index = contentView.rowIndex(for: cell) else { return }
        imagesListService.toggleLike(byIndex: index)
    }
}
