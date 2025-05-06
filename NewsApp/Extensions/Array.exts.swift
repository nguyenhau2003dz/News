//
//  Array.exts.swift
//  News
//
//  Created by Hậu Nguyễn on 6/5/25.
//
import Foundation
extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
