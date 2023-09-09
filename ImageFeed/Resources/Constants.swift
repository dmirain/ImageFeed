import UIKit

struct Const {
    static let cellIndent: CGFloat = 8
    static let tableIndent: CGFloat = 16
    static let firsCellTopIndent = tableIndent - cellIndent
    static let likeImage = UIImage(named: "RedHeart")!
    static let unlikeImage = UIImage(named: "WhiteHeart")!

    static let accessKey = "7km4bSI2aPRq9Z7lHH-HkWFYnVfayjE8wZc1Ekm99f8"
    static let secretKey = "Jp85u8E0sOqqu1d58BgANZimPY_kRu694oSD1jJzL68"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com/")!
    static let authorizeURLString = "https://unsplash.com/oauth/authorize"
}
