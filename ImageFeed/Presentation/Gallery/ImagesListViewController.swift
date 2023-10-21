import UIKit
import Swinject

// MARK: - ImagesListViewController

final class ImagesListViewController: BaseUIViewController {
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private let imageFeedModel: ImageFeedModel
    private let contentView: ImagesListTableUIView
    private let diResolver: Resolver
    
    init(diResolver: Resolver, imageFeedModel: ImageFeedModel) {
        self.imageFeedModel = imageFeedModel
        self.diResolver = diResolver
        contentView = ImagesListTableUIView()
        
        super.init(nibName: nil, bundle: nil)
        
        contentView.setDelegates(tableDataSource: self, tableDelegate: self)
        tabBarItem = UITabBarItem(title: nil, image: UIImage.mainTabImage, selectedImage: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Какой-то костыль, иначе цвет скидывался на белый
        contentView.tableView.backgroundColor = .clear
    }
}

// MARK: - UITableViewDataSource

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        imageFeedModel.imagesCount
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
        let cellModel = imageFeedModel.imageCellModel(byIndex: indexPath.row)
        cell.configureCell(with: cellModel)
    }
}

// MARK: - UITableViewDelegate

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = diResolver.resolve(SingleImageViewController.self)
        
        guard let viewController else { return }
        
        let imageModel = imageFeedModel.imageCellModel(byIndex: indexPath.row)
        viewController.setModel(imageCellModel: imageModel)
        present(viewController, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        imageFeedModel.imageHeight(byIndex: indexPath.row, containerWidth: tableView.bounds.width) + Const.cellIndent
    }

//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) { }
}

// MARK: - ImagesListCellDelegate

extension ImagesListViewController: ImagesListCellDelegate {
    func likeButtonClicked(_ cell: ImagesListCell) {
        print(cell)
    }
}
