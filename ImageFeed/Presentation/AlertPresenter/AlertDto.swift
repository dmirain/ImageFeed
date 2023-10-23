protocol AlertDto {
    var headerTitle: String { get }
    var message: String { get }
    var actions: [AlertAction] { get }
}
