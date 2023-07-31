import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"

    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var likeButon: UIButton!
    @IBOutlet private weak var cellImage: UIImageView!

    func configureCell(with cellModel: ImageCellModel) {
        let image = cellModel.liked ? Const.likeImage : Const.unlikeImage
        dateLabel.text = cellModel.date.dateString
        likeButon.setTitle("", for: .normal)
        likeButon.setImage(image, for: .normal)
        cellImage.image = cellModel.image
    }
}
