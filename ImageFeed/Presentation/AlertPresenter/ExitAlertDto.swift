struct ExitAlertDto: AlertDto {
    let actions: [AlertAction] = [.exit(actionText: "Да"), .doNothing(actionText: "Нет")]
    let headerTitle = "Пока, пока!"
    var message: String { "Уверены что хотите выйти?" }
}
