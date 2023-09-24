import Foundation

protocol NetworkClient {
    func fetch(request: URLRequest) async throws -> Data
}

enum NetworkError: Error {
    case connectError(error: URLError)
    case codeError(code: Int)
    case emptyData
    case parseError
    case unknownError(error: Error)

    func asText() -> String {
        switch self {
        case let .connectError(error):
            return "Ошибка соединения: \(error.localizedDescription)"
        case let .codeError(code):
            return "Сервер ответил ошибкой: \(code)"
        case .emptyData:
            return "Сервер не прислал данные"
        case .parseError:
            return "Ошибка разбора данных"
        case let .unknownError(error):
            return "Неизвестная ошибка: \(error.localizedDescription)"
        }
    }
}

struct NetworkClientImpl: NetworkClient {
    func fetch(request: URLRequest) async throws -> Data {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            if let response = response as? HTTPURLResponse,
                response.statusCode < 200 || response.statusCode >= 300 {
                throw NetworkError.codeError(code: response.statusCode)
            }

            return data
        } catch let error as URLError {
            throw NetworkError.connectError(error: error)
        }
    }
}
