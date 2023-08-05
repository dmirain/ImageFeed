import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    private var gradientInited = false

    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var likeButon: UIButton!
    @IBOutlet private weak var gradientView: UIView!
    @IBOutlet private weak var cellImage: UIImageView!

    func configureCell(with cellModel: ImageCellModel) {
        let image = cellModel.liked ? Const.likeImage : Const.unlikeImage
        dateLabel.text = cellModel.date.dateString
        likeButon.setTitle("", for: .normal)
        likeButon.setImage(image, for: .normal)
        cellImage.image = cellModel.image
        
        if !gradientInited {
            let gradient = CAGradientLayer()
            gradient.frame = gradientView.bounds
            gradient.colors = [UIColor.clear.cgColor, UIColor.ypBlackA20.cgColor]
            gradientView.layer.insertSublayer(gradient, at: 0)
            gradientView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 16)

            gradientInited.toggle()
        }
    }
}
