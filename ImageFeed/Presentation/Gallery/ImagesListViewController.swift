import UIKit
import Swinject

// MARK: - ImagesListViewController

protocol ImagesListViewControllerDelegate: AnyObject {
    func reloadRow(at index: Int)
    func updateTableViewAnimated(addedIndexes: Range<Int>)
}

final class ImagesListViewController: BaseUIViewController {
    private let diResolver: Resolver
    private let presenter: ImagesListViewPresenter
    private let contentView: ImagesListTableUIView
    private var isTableInit = false

    init(diResolver: Resolver, presenter: ImagesListViewPresenter, contentView: ImagesListTableUIView) {
        self.diResolver = diResolver
        self.presenter = presenter
        self.contentView = contentView

        super.init(nibName: nil, bundle: nil)

        self.presenter.delegate = self
        self.contentView.setDelegates(tableDataSource: self, tableDelegate: self)
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
}

// MARK: - ImagesListViewControllerDelegate

extension ImagesListViewController: ImagesListViewControllerDelegate {
    func fetchPhotosNextPage() {
        presenter.fetchPhotosNextPage()
    }

    func reloadRow(at index: Int) {
        contentView.reloadRow(at: index)
    }

    func updateTableViewAnimated(addedIndexes: Range<Int>) {
        if !isTableInit { return }
        contentView.updateTableViewAnimated(addedIndexes: addedIndexes)
    }
}

// MARK: - UITableViewDataSource

extension ImagesListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isTableInit = true
        return presenter.imagesCount
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
        let image = presenter.image(byIndex: indexPath.row)
        cell.configureCell(with: image)
    }
}

// MARK: - UITableViewDelegate

extension ImagesListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = diResolver.resolve(SingleImageViewController.self)

        guard let viewController else { return }

        let image = presenter.image(byIndex: indexPath.row)
        viewController.setImage(image: image)
        present(viewController, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        presenter.imageHeight(byIndex: indexPath.row, containerWidth: tableView.bounds.width) + Const.cellIndent
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter.rowWillDisplay(index: indexPath.row)
    }
}

// MARK: - ImagesListCellDelegate

extension ImagesListViewController: ImagesListCellDelegate {
    func likeButtonClicked(_ cell: ImagesListCell) {
        guard let index = contentView.rowIndex(for: cell) else { return }
        presenter.toggleLike(byIndex: index)
    }
}
