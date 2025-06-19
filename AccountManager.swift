import Foundation
import SwiftUI
import UIKit

struct UserAccount: Identifiable, Codable, Equatable {
    let id: UUID
    var email: String
    var password: String
    var userID: String
    var licensePlate: String
    var carMake: String
    var carType: String
    var profileImageData: Data?

    var profileImage: UIImage? {
        if let data = profileImageData {
            return UIImage(data: data)
        }
        return nil
    }

    init(id: UUID = UUID(), email: String, password: String, userID: String, licensePlate: String, carMake: String, carType: String, profileImage: UIImage?) {
        self.id = id
        self.email = email
        self.password = password
        self.userID = userID
        self.licensePlate = licensePlate
        self.carMake = carMake
        self.carType = carType
        self.profileImageData = profileImage?.jpegData(compressionQuality: 0.8)
    }
}

class AccountManager: ObservableObject {
    @Published var accounts: [UserAccount] = []
    @Published var currentUser: UserAccount?

    private let accountsKey = "savedAccounts"
    private let currentUserKey = "loggedInUser"

    init() {
        loadAccounts()
        loadCurrentUser()
    }

    func register(_ account: UserAccount) -> Bool {
        guard !accounts.contains(where: { $0.email == account.email }) else {
            return false
        }
        accounts.append(account)
        currentUser = account
        saveAccounts()
        saveCurrentUser()
        return true
    }

    func login(email: String, password: String) -> Bool {
        if let user = accounts.first(where: { $0.email == email && $0.password == password }) {
            currentUser = user
            saveCurrentUser()
            return true
        }
        return false
    }

    func logout() {
        currentUser = nil
        UserDefaults.standard.removeObject(forKey: currentUserKey)
    }

    func updateCurrentUser(_ updated: UserAccount) {
        if let idx = accounts.firstIndex(where: { $0.id == updated.id }) {
            accounts[idx] = updated
            currentUser = updated
            saveAccounts()
            saveCurrentUser()
        }
    }

    private func saveAccounts() {
        if let data = try? JSONEncoder().encode(accounts) {
            UserDefaults.standard.set(data, forKey: accountsKey)
        }
    }

    private func loadAccounts() {
        if let data = UserDefaults.standard.data(forKey: accountsKey),
           let loaded = try? JSONDecoder().decode([UserAccount].self, from: data) {
            accounts = loaded
        }
    }

    private func saveCurrentUser() {
        if let user = currentUser,
           let data = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(data, forKey: currentUserKey)
        }
    }

    private func loadCurrentUser() {
        if let data = UserDefaults.standard.data(forKey: currentUserKey),
           let user = try? JSONDecoder().decode(UserAccount.self, from: data) {
            currentUser = user
        }
    }
}
