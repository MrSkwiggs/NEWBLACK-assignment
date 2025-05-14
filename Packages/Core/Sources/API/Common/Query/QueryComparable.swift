//
//  QueryComparable.swift
//  Core
//
//  Created by Dorian on 13/05/2025.
//

import Foundation

public protocol QueryComparable: QueryFilterable, Comparable {}

extension String: QueryComparable {}
extension Int: QueryComparable {}
extension Double: QueryComparable {}
extension Date: QueryComparable {}
