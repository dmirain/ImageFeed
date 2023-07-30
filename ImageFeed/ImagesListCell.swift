import UIKit

private let likeImage = UIImage(named: "RedHeart")
private let unlikeImage = UIImage(named: "WhiteHeart")

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"

    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var likeButon: UIButton!
    @IBOutlet private var cellImage: UIImageView!

    func setRowState(to rowState: RowState) {
        dateLabel.text = rowState.date.dateString
        likeButon.setTitle("", for: .normal)
        likeButon.setImage(
            rowState.liked ? likeImage : unlikeImage,
            for: .normal
        )
        cellImage.image = rowState.image
    }
}

struct RowState {
    let date: Date
    let liked: Bool
    let image: UIImage
}
