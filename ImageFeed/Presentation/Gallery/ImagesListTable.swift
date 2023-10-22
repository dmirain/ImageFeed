import UIKit

final class ImagesListTableUIView: UIView {
    lazy var tableView: UITableView = {
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
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDelegates(tableDataSource: UITableViewDataSource, tableDelegate: UITableViewDelegate) {
        tableView.dataSource = tableDataSource
        tableView.delegate = tableDelegate
    }
    
    func updateTableRowsCount(addedIndexes: Range<Int>) {
        tableView.performBatchUpdates {
            let indexPaths = addedIndexes.map { i in
                IndexPath(row: i, section: 0)
            }
            tableView.insertRows(at: indexPaths, with: .automatic)
        } completion: { _ in }
    }
}
