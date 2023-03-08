//
//  FileManager-DocumentsDirectory.swift
//  BucketList
//
//  Created by Nick Pavlov on 3/7/23.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
