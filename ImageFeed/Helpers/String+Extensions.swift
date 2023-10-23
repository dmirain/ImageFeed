import Foundation

private let isoDateFormatter = {
    let formater = ISO8601DateFormatter()
    formater.formatOptions = [.withInternetDateTime]
    return formater
}()

extension String {
    func dateFromISO() -> Date? { isoDateFormatter.date(from: self) }
}
