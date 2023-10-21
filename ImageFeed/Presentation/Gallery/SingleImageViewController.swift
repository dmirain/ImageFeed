import UIKit

final class SingleImageViewController: BaseUIViewController {
    private let contentView: SingleImageView
    private var imageCellModel: ImageCellModel?
    
    init() {
        contentView = SingleImageView()
        super.init(nibName: nil, bundle: nil)
        contentView.delegate = self
        
        modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        contentView.rescaleAndCenterImageInScrollView()
    }
    
    func setModel(imageCellModel: ImageCellModel) {
        self.imageCellModel = imageCellModel
        contentView.setImage(image: imageCellModel.image)
    }
    
}

extension SingleImageViewController: SingleImageViewDelegate {
    func backButtonClicked() {
        dismiss(animated: true, completion: nil)
    }
    
    func shareButtonClicked() {
        guard let image = imageCellModel?.image else { return }

        let activityViewController = UIActivityViewController(
            activityItems: [image], applicationActivities: nil
        )
        present(activityViewController, animated: true, completion: nil)
    }
}


