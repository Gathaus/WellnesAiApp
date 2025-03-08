import Foundation

struct UserSettings: Codable {
    var notificationsEnabled: Bool
    var darkModeEnabled: Bool
    var reminderTime: Date
    var languageCode: String

    init(notificationsEnabled: Bool = true,
         darkModeEnabled: Bool = false,
         reminderTime: Date = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date())!,
         languageCode: String = "tr") {

        self.notificationsEnabled = notificationsEnabled
        self.darkModeEnabled = darkModeEnabled
        self.reminderTime = reminderTime
        self.languageCode = languageCode
    }
}