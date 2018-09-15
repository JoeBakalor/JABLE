//
//  ConnectionOptions.swift
//  JABLE
//
//  Created by Joe Bakalor on 9/12/18.
//

import Foundation

public struct ConnectionOptions{
    var shouldAttemptReconnection: Bool
    var reconnectionTimeout: TimeInterval?
    var connectionTimeout: TimeInterval?
    var retries = 0
}
