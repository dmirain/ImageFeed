struct ErrorAlertDto: AlertDto {
    private let error: NetworkError

    let action: AlertAction = .reset
    let headerTitle = "Что-то пошло не так("
    let actionTitle = "Попробовать ещё раз"
    var message: String { "Не удалось войти в систему.\n\(error.asText())." }

    init(error: NetworkError) {
        self.error = error
    }
}