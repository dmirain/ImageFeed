import UIKit
import Swinject

// MARK: - ImagesListViewController

final class ImagesListViewController: BaseUIViewController {
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private let imagesListService: ImagesListService
    private let contentView: ImagesListTableUIView
    private let diResolver: Resolver
    private var imageTableObserver: NSObjectProtocol?
    private var isTableInit = false

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

    func fetchPhotosNextPage() {
        imagesListService.fetchPhotosNextPage()
    }

    func reloadRow(at index: Int) {
        contentView.reloadRow(at: index)
    }

    private func subscribeOnTableUpdate() {
        imageTableObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification, object: nil, queue: .main
        ) { [weak self] data in
            guard let self else { return }

            if !isTableInit { return }

            if let addedIndexes = data.userInfo?["addedIndexes"] as? Range<Int> {
                self.contentView.updateTableViewAnimated(addedIndexes: addedIndexes)
            }
        }
    }
}

// MARK: - UITableViewDataSource

// Методы, которые таблица вызывает, что бы получить данные
extension ImagesListViewController: UITableViewDataSource {

    // Обязательный метод, который узнаёт у нас сколько у нас строк в данных.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isTableInit = true
        return imagesListService.imagesCount
    }

    // Метод в котором таблица понимает, какую ячейку использовать.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)

        guard let imageListCell = cell as? ImagesListCell else {
            assertionFailure("unknown cell")
            return UITableViewCell()
        }

        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }

    // Мой метод, который конфигурирует ячейку. Вызывается на 83 строке
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        cell.controller = self
        let cellModel = imagesListService.imageCellModel(byIndex: indexPath.row)
        cell.configureCell(with: cellModel)
    }
}

// MARK: - UITableViewDelegate

// Методы обработчики событий от таблички
extension ImagesListViewController: UITableViewDelegate {
    // Дёргается при нажатии на строку. Тут мы переходим к контроллеру с большой фоткой
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = diResolver.resolve(SingleImageViewController.self)

        guard let viewController else { return }

        let imageModel = imagesListService.imageCellModel(byIndex: indexPath.row)
        viewController.setModel(imageCellModel: imageModel)
        present(viewController, animated: true)
    }

    // Дёргается, когда табличка хочет понять высоту ячейки
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        imagesListService.imageHeight(byIndex: indexPath.row, containerWidth: tableView.bounds.width) + Const.cellIndent
    }

    // Дёргается для каждой ячейки, когда она показывается пользователю.
    // Тут мы понимаем, что пользователь почти долистал до конца и надо грузить ещё данныке
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
