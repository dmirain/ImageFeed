protocol AlertDto {
    var headerTitle: String { get }
    var actionTitle: String { get }
    var message: String { get }
    var action: AlertAction { get }
}
