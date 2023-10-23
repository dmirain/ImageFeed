struct ErrorAlertDto: AlertDto {
    private let error: NetworkError

    let actions: [AlertAction] = [.reset(actionText: "Попробовать ещё раз")]
    let headerTitle = "Что-то пошло не так("
    var message: String { "Не удалось войти в систему.\n\(error.asText())." }

    init(error: NetworkError) {
        self.error = error
    }
}
