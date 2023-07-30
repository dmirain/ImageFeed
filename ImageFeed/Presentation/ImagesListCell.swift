import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"

    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var likeButon: UIButton!
    @IBOutlet private var cellImage: UIImageView!

    func setRowState(to rowState: RowState) {
        let image = rowState.liked ? Const.likeImage : Const.unlikeImage
        dateLabel.text = rowState.date.dateString
        likeButon.setTitle("", for: .normal)
        likeButon.setImage(image, for: .normal)
        cellImage.image = rowState.image
    }
}
