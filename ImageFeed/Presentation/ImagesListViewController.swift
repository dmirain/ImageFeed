import UIKit

class ImagesListViewController: UIViewController {
    private let model: ImageFeedModel

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    @IBOutlet private var tableView: UITableView!

    required init?(coder: NSCoder) {
        model = ImageFeedModel()
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(
            top: Const.firsCellTopIndent,
            left: 0,
            bottom: Const.firsCellTopIndent,
            right: 0
        )
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.imagesCount
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
        let rowState = model.rowState(byIndex: indexPath.row)
        cell.setRowState(to: rowState)
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        model.imageHeight(byIndex: indexPath.row, containerWidth: tableView.bounds.width) + Const.cellIndent
    }
}
