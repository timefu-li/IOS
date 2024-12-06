//
//  Models.swift
//  IOS
//
//  Created by Curt Spark on 04/12/2024.
//

import SwiftUI
import Foundation

// Extension to color that allows us to figure out whether foreground text of a background should be black or white for readability
extension Color {
    func luminance() -> Double {
        // Convert SwiftUI Color to UIColor
        let uiColor = UIColor(self)
        
        // Extract RGB values
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: nil)
        
        // Compute luminance.
        return 0.2126 * Double(red) + 0.7152 * Double(green) + 0.0722 * Double(blue)
    }
    
    func isLight() -> Bool {
        return luminance() > 0.5
    }
    
    func adaptedTextColor() -> Color {
        return isLight() ? Color.black : Color.white
    }
}

struct BackendColor: Codable, Identifiable, Hashable {
    let red: UInt8
    let green: UInt8
    let blue: UInt8
    let id: UUID? = UUID()

    init(red: UInt8, green: UInt8, blue: UInt8) {
        self.red = red
        self.green = green
        self.blue = blue
    }

    public func toSwiftColor() -> Color {
        return Color(red: Double(self.red) / 255.0, green: Double(self.green) / 255.0, blue: Double(self.blue) / 255.0)
    }

    public static func toBackendColor(swiftcolor: Color) -> BackendColor {
        var swiftcolor_R: CGFloat = 0
        var swiftcolor_G: CGFloat = 0
        var swiftcolor_B: CGFloat = 0
        var swiftcolor_A: CGFloat = 0
        UIColor(swiftcolor).getRed(&swiftcolor_R, green: &swiftcolor_G, blue: &swiftcolor_B, alpha: &swiftcolor_A)
        return BackendColor(red: UInt8(swiftcolor_R * 255.0), green: UInt8(swiftcolor_G * 255.0), blue: UInt8(swiftcolor_B * 255.0))
    }
}

struct BackendError: Codable, Identifiable {
    let error: Bool
    let reason: String
    let id: UUID? = UUID()

    init(error: Bool, reason: String) {
        self.error = error
        self.reason = reason
    }
}

struct CategoryModel: Codable, Identifiable, Hashable {
    let name: String?
    let emoji: String?
    let colour: BackendColor?
    let tasks: [TaskModel]?

    let id: UUID?

    init(name: String? = nil, emoji: String? = nil, colour: BackendColor? = nil, tasks: [TaskModel]? = nil, id: UUID? = nil) {
        self.name = name
        self.emoji = emoji
        self.colour = colour
        self.tasks = tasks

        self.id = id
    }
}

struct TaskModel: Codable, Identifiable, Hashable {
    let name: String?
    let category: CategoryModel?
    let completedtasks: [CompletedTaskModel]?

    let id: UUID?

    init(name: String? = nil, category: CategoryModel? = nil, completedtasks: [CompletedTaskModel]? = nil, id: UUID? = nil) {
        self.name = name
        self.category = category
        self.completedtasks = completedtasks

        self.id = id
    }
}

struct CompletedTaskModel: Codable, Identifiable, Hashable {
    let name: String?
    let task: TaskModel?
    let started: Date?
    let completed: Date?

    let id: UUID?

    init(name: String? = nil, task: TaskModel? = nil, started: Date? = nil, completed: Date? = nil, id: UUID? = nil) {
        self.name = name
        self.task = task
        self.started = started
        self.completed = completed

        self.id = id
    }
}
