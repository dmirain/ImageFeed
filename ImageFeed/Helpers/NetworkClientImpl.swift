import Foundation

protocol NetworkClient {
    func fetchObject<T: Decodable>(
        from request: URLRequest,
        as dtoType: T.Type,
        handler: @escaping (Result<T, NetworkError>) -> Void
    ) -> URLSessionTask
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
    func fetchObject<T: Decodable>(
        from request: URLRequest,
        as dtoType: T.Type,
        handler: @escaping (Result<T, NetworkError>) -> Void
    ) -> URLSessionTask {
        fetch(from: request) { result in
            switch result {
            case let .success(data):
                if let object = data.fromJson(to: dtoType) {
                    handler(.success(object))
                } else {
                    handler(.failure(NetworkError.parseError))
                }
            case let .failure(error):
                handler(.failure(error))
            }
        }
    }

    private func fetch(
        from request: URLRequest,
        handler: @escaping (Result<Data, NetworkError>) -> Void
    ) -> URLSessionTask {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Проверяем, пришла ли ошибка
            if let error {
                if let error = error as? URLError {
                    handler(.failure(.connectError(error: error)))
                } else {
                    handler(.failure(.unknownError(error: error)))
                }
                return
            }

            // Проверяем, что нам пришёл успешный код ответа
            if let response = response as? HTTPURLResponse,
                response.statusCode < 200 || response.statusCode >= 300 {
                handler(.failure(.codeError(code: response.statusCode)))
                return
            }

            // Возвращаем данные
            guard let data else {
                handler(.failure(.emptyData))
                return
            }

            handler(.success(data))
        }

        task.resume()
        return task
    }
}
