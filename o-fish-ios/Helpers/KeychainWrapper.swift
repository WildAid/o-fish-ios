//
//  KeychainManager.swift
//  
//  Created on 7/23/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import LocalAuthentication

struct Credentials {
    var username: String
    var password: String
}

struct KeychainError: Error {
    var status: OSStatus

    var localizedDescription: String {
        return SecCopyErrorMessageString(status, nil) as String? ?? "Unknown error."
    }
}

class KeychainWrapper {

    static let shared = KeychainWrapper()
    private let server = Constants.realmAppId
    private enum BiometricType {
        case touch
        case face
        case none
    }

    func addCredentials(_ credentials: Credentials) -> Error? {
        var errorIn: Error?
        do {
            try addCredentials(credentials, server: server)
            print("Credentials were added.")
        } catch {
            if let keychainError = error as? KeychainError {
                errorIn = keychainError
            }
        }

        return errorIn
    }

    func readCredentials() -> (error: Error?, credentials: Credentials?) {
        var errorIn: Error?
        var credentials: Credentials?
        do {
            credentials = try readCredentials(server: server)
            print("Credentials were read.")
        } catch {
            if let keychainError = error as? KeychainError {
                errorIn = keychainError
            }
        }
        return (errorIn, credentials)
    }

    func removeCredentials() -> Error? {
        var errorIn: Error?
        do {
            try deleteCredentials(server: server)
            print("Credential were removed. Server: \(server)")
            return nil
        } catch {
            if let error = error as? KeychainError {
                errorIn = error
            }
        }
        return errorIn
    }

    private func addCredentials(_ credentials: Credentials, server: String) throws {

        let account = credentials.username
        guard let password = credentials.password.data(using: String.Encoding.utf8) else {
            return
        }

        let access = SecAccessControlCreateWithFlags(nil,
                                                     kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly,
                                                     .userPresence,
                                                     nil) // Ignore any error.

        let context = LAContext()
        context.touchIDAuthenticationAllowableReuseDuration = Settings.shared.reuseDuration

        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrAccount as String: account,
                                    kSecAttrServer as String: server,
                                    kSecAttrAccessControl as String: access as Any,
                                    kSecUseAuthenticationContext as String: context,
                                    kSecValueData as String: password]

        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else { throw KeychainError(status: status) }
    }

    private func readCredentials(server: String) throws -> Credentials {
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrServer as String: server,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnAttributes as String: true,
                                    kSecUseOperationPrompt as String: NSLocalizedString("Access your login and password on the keychain",
                                                                                       comment: ""),
                                    kSecReturnData as String: true]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess else { throw KeychainError(status: status) }

        guard let existingItem = item as? [String: Any],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: String.Encoding.utf8),
            let account = existingItem[kSecAttrAccount as String] as? String
            else {
                throw KeychainError(status: errSecInternalError)
        }

        return Credentials(username: account, password: password)
    }

    private func deleteCredentials(server: String) throws {
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrServer as String: server]

        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess else { throw KeychainError(status: status) }
    }

    func getPictureName() -> String {
        let bioType = getBiometricType()
        switch bioType {
        case .touch:
            return "hand.point.right.fill" // TODO Wll be changed on "touchid" after release SFSymbols 2.0
        case .face:
            return "faceid"
        case .none:
            return ""
        }
    }

    private func getBiometricType() -> BiometricType {
        let authenticationContext = LAContext()
        _ = authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch authenticationContext.biometryType {
        case .faceID:
            return .face
        case .touchID:
            return .touch
        default:
            return .none
        }
    }
}
