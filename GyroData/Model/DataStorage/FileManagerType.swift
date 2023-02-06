//
//  FileManagerType.swift
//  GyroData
//
//  Created by summercat on 2023/01/31.
//

import Foundation

protocol FileManagerType {
    func urls(for directory: FileManager.SearchPathDirectory, in domainMask: FileManager.SearchPathDomainMask) -> [URL]
    func createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool, attributes: [FileAttributeKey : Any]?) throws
    func fileExists(atPath path: String) -> Bool
    func removeItem(at URL: URL) throws
}

extension FileManager: FileManagerType { }
