//
//  APIHandler.swift
//  IOS
//
//  Created by Curt Spark on 04/12/2024.
//
import Foundation

struct APIHandler {

    public enum APIHandlerError: Error {
        case OK
        case urlCheckFail
        case urlRequestFail(reason: String)
        case decodeModelError(reason: String)
        case decodeBackendErrorResponseError
    }
    
    public enum HTTPMethod: String {
        case POST = "POST"
        case GET = "GET"
        case UPDATE = "UPDATE"
        case PATCH = "PATCH"
        case DELETE = "DELETE"
    }

    static private func attemptRequest(url: String, method: HTTPMethod, task: TaskModel? = nil, completedtask: CompletedTaskModel? = nil, category: CategoryModel? = nil) async throws(APIHandlerError) -> Data {
        guard let urlObject = URL(string: url) else {
            throw APIHandlerError.urlCheckFail
        }
        var request = URLRequest(url: urlObject)
        request.httpMethod = method.rawValue 
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Custom decoder to handle dates properly
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        if (task != nil) {
            request.httpBody = try? encoder.encode(task)
        }
        if (completedtask != nil) {
            request.httpBody = try? encoder.encode(completedtask)
        }
        if (category != nil) {
            request.httpBody = try? encoder.encode(category)
        }

        var requestOutcome: (Data: Data, URLResponse: URLResponse)
        do {
            requestOutcome = try await URLSession.shared.data(for: request)
        } catch {
            throw APIHandlerError.urlRequestFail(reason: error.localizedDescription)
        }

        return requestOutcome.Data
    }

    static public func newTask(task: TaskModel) async throws(APIHandlerError) -> TaskModel {
        let jsondata = try await attemptRequest(url: "http://127.0.0.1:8080/tasks", method: HTTPMethod.POST, task: task)
 
        guard let result: TaskModel = try? JSONDecoder().decode(TaskModel.self, from: jsondata) else {
            guard let resulterror: BackendError = try? JSONDecoder().decode(BackendError.self, from: jsondata) else {
                throw APIHandlerError.decodeBackendErrorResponseError
            }

            throw APIHandlerError.decodeModelError(reason: resulterror.reason)
        }

        return result
    }

    static public func newCategory(category: CategoryModel) async throws(APIHandlerError) -> CategoryModel {
        let jsondata = try await attemptRequest(url: "http://127.0.0.1:8080/categories", method: HTTPMethod.POST, category: category)
 
        guard let result: CategoryModel = try? JSONDecoder().decode(CategoryModel.self, from: jsondata) else {
            guard let resulterror: BackendError = try? JSONDecoder().decode(BackendError.self, from: jsondata) else {
                throw APIHandlerError.decodeBackendErrorResponseError
            }

            throw APIHandlerError.decodeModelError(reason: resulterror.reason)
        }

        return result
    }

    static public func newCompletedTask(completedtask: CompletedTaskModel) async throws(APIHandlerError) -> CompletedTaskModel {
        let jsondata = try await attemptRequest(url: "http://127.0.0.1:8080/completedtasks", method: HTTPMethod.POST, completedtask: completedtask)

        // Ensure dates can be decoded correctly
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
 
        guard let result: CompletedTaskModel = try? decoder.decode(CompletedTaskModel.self, from: jsondata) else {
            guard let resulterror: BackendError = try? decoder.decode(BackendError.self, from: jsondata) else {
                throw APIHandlerError.decodeBackendErrorResponseError
            }

            throw APIHandlerError.decodeModelError(reason: resulterror.reason)
        }

        return result
    }

    static public func getTasks() async throws(APIHandlerError) -> [TaskModel] {
        let jsondata = try await attemptRequest(url: "http://localhost:8080/tasks", method: HTTPMethod.GET)
 
        guard let result: [TaskModel] = try? JSONDecoder().decode([TaskModel].self, from: jsondata) else {
            guard let resulterror: BackendError = try? JSONDecoder().decode(BackendError.self, from: jsondata) else {
                throw APIHandlerError.decodeBackendErrorResponseError
            }

            throw APIHandlerError.decodeModelError(reason: resulterror.reason)
        }

        return result
    }

    static public func getCompletedTasks() async throws(APIHandlerError) -> [CompletedTaskModel] {
        let jsondata = try await attemptRequest(url: "http://localhost:8080/completedtasks", method: HTTPMethod.GET)

        // Ensure dates can be decoded correctly
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        guard let result: [CompletedTaskModel] = try? decoder.decode([CompletedTaskModel].self, from: jsondata) else {
            guard let resulterror: BackendError = try? JSONDecoder().decode(BackendError.self, from: jsondata) else {
                throw APIHandlerError.decodeBackendErrorResponseError
            }

            throw APIHandlerError.decodeModelError(reason: resulterror.reason)
        }

        //print(NSString(data: jsondata, encoding: String.Encoding.utf8.rawValue))
        //do {
        //    let decoder = JSONDecoder()
        //    decoder.dateDecodingStrategy = .iso8601
        //    let result: CompletedTaskModel = try decoder.decode(CompletedTaskModel.self, from: jsondata)
        //    return result
        //} catch {
        //    print("error! \(error)")
        //}

        return result
    }

    static public func updateCompletedTask(completedtask: CompletedTaskModel) async throws(APIHandlerError) -> CompletedTaskModel {
            var updatequery: String = ""
            if (completedtask.id == nil) {
                    throw APIHandlerError.decodeModelError(reason: "Missing ID for updating Completed Task.")
            }

            // TODO: This is quite manual, maybe you could do this via a case/switch or the like but it works for now
            if let name: String = completedtask.name {
                    updatequery += "?name=\(name)"
            }
            //if let task: TaskModel = completedtask.task {
            //        updatequery += "?task=\(task)"
            //}
            if let started: Date = completedtask.started {
                    updatequery += "?started=\(started.ISO8601Format())"
            }
            if let completed: Date = completedtask.completed {
                    updatequery += "?completed=\(completed.ISO8601Format())"
            }

            // Ensure dates can be decoded correctly
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

            // Update completed task
            let jsondata = try await attemptRequest(url: "http://127.0.0.1:8080/completedtasks/\(completedtask.id)\(updatequery)", method: HTTPMethod.PATCH)
            guard let result: CompletedTaskModel = try? decoder.decode(CompletedTaskModel.self, from: jsondata) else {
                    guard let resulterror: BackendError = try? decoder.decode(BackendError.self, from: jsondata) else {
                            throw APIHandlerError.decodeBackendErrorResponseError
                    }

                    throw APIHandlerError.decodeModelError(reason: resulterror.reason)
            }

            return result
    }

    static public func updateTask(task: TaskModel) async throws(APIHandlerError) -> TaskModel {
            var updatequery: String = ""
            if (task.id == nil) {
                    throw APIHandlerError.decodeModelError(reason: "Missing ID for updating Completed Task.")
            }

            // TODO: This is quite manual, maybe you could do this via a case/switch or the like but it works for now
            if let name: String = task.name {
                    updatequery += "?name=\(name)"
            }
            if let category: CategoryModel = task.category {
                    updatequery += "?category=\(category)"
            }
            
            // Ensure dates can be decoded correctly
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

            // Update task
            let jsondata = try await attemptRequest(url: "http://127.0.0.1:8080/tasks/\(task.id)\(updatequery)", method: HTTPMethod.PATCH)
            guard let result: TaskModel = try? decoder.decode(TaskModel.self, from: jsondata) else {
                    guard let resulterror: BackendError = try? decoder.decode(BackendError.self, from: jsondata) else {
                            throw APIHandlerError.decodeBackendErrorResponseError
                    }

                    throw APIHandlerError.decodeModelError(reason: resulterror.reason)
            }

            return result
    }


    static public func updateCategory(category: CategoryModel) async throws(APIHandlerError) -> CategoryModel {
            var updatequery: String = ""
            if (category.id == nil) {
                    throw APIHandlerError.decodeModelError(reason: "Missing ID for updating Category.")
            }

            // TODO: This is quite manual, maybe you could do this via a case/switch or the like but it works for now
            if let name: String = category.name {
                    updatequery += "?name=\(name)"
            }
            if let emoji: String = category.emoji {
                    updatequery += "?emoji=\(emoji)"
            }
            if let color: BackendColor = category.colour {
                    updatequery += "?color=\(color)"
            }
            
            // Ensure dates can be decoded correctly
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

            // Update category
            let jsondata = try await attemptRequest(url: "http://127.0.0.1:8080/categories/\(category.id)\(updatequery)", method: HTTPMethod.PATCH)
            guard let result: CategoryModel = try? decoder.decode(CategoryModel.self, from: jsondata) else {
                    guard let resulterror: BackendError = try? decoder.decode(BackendError.self, from: jsondata) else {
                            throw APIHandlerError.decodeBackendErrorResponseError
                    }

                    throw APIHandlerError.decodeModelError(reason: resulterror.reason)
            }

            return result
    }

    static public func newCurrentTask(task: TaskModel) async throws(APIHandlerError) -> CompletedTaskModel {
        let currenttask = try! await APIHandler.getCompletedTasks()[0]
        let updatedcompletedtaskmodel = CompletedTaskModel(completed: Date.now, id: currenttask.id)
        let newcompletedtask = CompletedTaskModel(name: task.name, task: task, started: Date.now)

        // Update current task to be finished
        try await updateCompletedTask(completedtask: updatedcompletedtaskmodel)

        // Add new current task
        let result: CompletedTaskModel = try! await APIHandler.newCompletedTask(completedtask: newcompletedtask)

        return result
    }

    static public func getCategories() async throws(APIHandlerError) -> [CategoryModel] {
        let jsondata = try await attemptRequest(url: "http://localhost:8080/categories", method: HTTPMethod.GET)
 
        guard let result: [CategoryModel] = try? JSONDecoder().decode([CategoryModel].self, from: jsondata) else {
            guard let resulterror: BackendError = try? JSONDecoder().decode(BackendError.self, from: jsondata) else {
                throw APIHandlerError.decodeBackendErrorResponseError
            }

            throw APIHandlerError.decodeModelError(reason: resulterror.reason)
        }

        return result
    }

}
