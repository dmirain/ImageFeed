import UIKit

protocol ImagesListCellDelegate: AnyObject {
    func likeButtonClicked(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    weak var controller: ImagesListCellDelegate?
    
    private lazy var cellImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .ypBlack
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var gradient: UIView = {
        // Костыль, иначе layer создаётся с нулевыми размерами и градиента нет :(
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 9999999999999, height: 30))
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.ypBlackA20.cgColor]
        view.layer.insertSublayer(gradient, at: 0)
        
        return view
    }()
    
    private lazy var likeButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(UIImage.redHeart, for: .normal)
        view.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 44),
            view.heightAnchor.constraint(equalToConstant: 44)
        ])
        return view
    }()
    
    private lazy var dateLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = view.font.withSize(13)
        view.textColor = UIColor.ypWhite
        return view
    }()

    // Почему-то если просто менять цвет у selectedBackgroundView, то он не меняется :(
    private lazy var bgColorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.ypBlack
        selectedBackgroundView = bgColorView
        
        contentView.addSubview(cellImage)
        cellImage.addSubview(gradient)
        contentView.addSubview(dateLabel)
        contentView.addSubview(likeButton)
        
        NSLayoutConstraint.activate([
            cellImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            cellImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
            cellImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            cellImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            
            gradient.trailingAnchor.constraint(equalTo: cellImage.trailingAnchor),
            gradient.leadingAnchor.constraint(equalTo: cellImage.leadingAnchor),
            gradient.bottomAnchor.constraint(equalTo: cellImage.bottomAnchor),
            
            dateLabel.trailingAnchor.constraint(lessThanOrEqualTo: cellImage.trailingAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: cellImage.leadingAnchor, constant: 8),
            dateLabel.bottomAnchor.constraint(equalTo: cellImage.bottomAnchor, constant: -8),
            
            likeButton.leadingAnchor.constraint(greaterThanOrEqualTo: cellImage.leadingAnchor),
            likeButton.topAnchor.constraint(equalTo: cellImage.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: cellImage.trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with cellModel: ImageDto) {
        let image = cellModel.isLiked ? Const.likeImage : Const.unlikeImage
        likeButton.setImage(image, for: .normal)
        dateLabel.text = cellModel.createdAt?.dateString ?? "дата не указана"
        cellImage.kf.setImage(with: cellModel.thumbImageURL, placeholder: UIImage.imageStub)
    }
    
    @objc func likeButtonClicked() {
        controller?.likeButtonClicked(self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
}
