//
//  KeychainError.swift
//  Core
//
//  Created by Dorian on 15/05/2025.
//

import Foundation

public extension KeyStore {
    /// A KeyStore that securely stores data in the Keychain
    static let keychain: KeyStore = {
        .init { key in
            var result: AnyObject?

            let state = SecItemCopyMatching(key.query(), &result)
            
            if state == errSecItemNotFound {
                return nil
            }

            guard state == errSecSuccess else {
                throw KeychainError.keyGetError
            }

            return result as? Data
        } set: { data, key in
            let status = SecItemAdd(key.query(for: data), nil)

            if status != errSecSuccess {
                guard status == errSecDuplicateItem else {
                    throw KeychainError.keySetError
                }

                guard SecItemUpdate(key.query(), key.dataAttribute(for: data)) == errSecSuccess else {
                    throw KeychainError.keyUpdateError
                }
            }
        } delete: { key in
            SecItemDelete(key.query())
        } clear: {
            [kSecClassGenericPassword, kSecClassInternetPassword, kSecClassCertificate, kSecClassKey, kSecClassIdentity].forEach {
                let status = SecItemDelete([
                    kSecClass: $0,
                    kSecAttrSynchronizable: kSecAttrSynchronizableAny
                ] as CFDictionary)
                if status != errSecSuccess && status != errSecItemNotFound {
                    //Error while removing class $0
                }
            }
        }
    }()
}

public extension KeyStore {
    enum KeychainError: Error {
        case keyUpdateError
        case keySetError
        case keyGetError
    }
}

fileprivate extension KeyStore.Key {

    func query(for data: Data? = nil) -> CFDictionary {
        var dictionary: [CFString: Any]
        dictionary = [
            kSecAttrService: identifier as CFString,
            kSecAttrAccount: provider as CFString,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ]

        if let data {
            dictionary[kSecValueData] = data
        }

        return dictionary as CFDictionary
    }

    func dataAttribute(for data: Data) -> CFDictionary {
        [kSecValueData: data] as CFDictionary
    }
}
