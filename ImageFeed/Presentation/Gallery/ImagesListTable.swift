import UIKit

protocol ImagesListTableUIView: UIView {
    func setDelegates(tableDataSource: UITableViewDataSource, tableDelegate: UITableViewDelegate)
    func initOnDidLoad()
    func reloadRow(at index: Int)
    func updateTableViewAnimated(addedIndexes: Range<Int>)
    func rowIndex(for cell: ImagesListCell) -> Int?
}

final class ImagesListTableUIViewImpl: UIView, ImagesListTableUIView {
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)

        view.backgroundColor = .ypBlack

        return view
    }()

    init() {
        super.init(frame: .zero)
        backgroundColor = .ypBlack

        addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setDelegates(tableDataSource: UITableViewDataSource, tableDelegate: UITableViewDelegate) {
        tableView.dataSource = tableDataSource
        tableView.delegate = tableDelegate
    }

    func initOnDidLoad() {
        // Какой-то костыль, иначе цвет скидывался на белый
        tableView.backgroundColor = .clear
    }
}

// MARK: - Table methods

extension ImagesListTableUIViewImpl {

    func reloadRow(at index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        tableView.reloadRows(at: [indexPath], with: .none)
    }

    func updateTableViewAnimated(addedIndexes: Range<Int>) {
        if addedIndexes.isEmpty { return }
        tableView.performBatchUpdates {
            let indexPaths = addedIndexes.map { index in
                IndexPath(row: index, section: 0)
            }
            tableView.insertRows(at: indexPaths, with: .automatic)
        } completion: { _ in
        }
    }

    func rowIndex(for cell: ImagesListCell) -> Int? {
        guard let indexPath = tableView.indexPath(for: cell) else { return nil }
        return indexPath.row
    }
}
