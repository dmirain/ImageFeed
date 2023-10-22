struct OpenImageAlertDto: AlertDto {
    let actions: [AlertAction] = [.reset(actionText: "Попробовать ещё раз"), .exit(actionText: "Отмена")]
    let headerTitle = "Что-то пошло не так :("
    let message = "Не удалось загрузить картинку"
}
