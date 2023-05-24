//
//  Config.swift
//  FeedReaderTests
//
//  Created by Stan Gajda on 23/05/2023.
//

import Foundation
import Quick
import Nimble

class PollingConfiguration: QuickConfiguration {
    override class func configure(_ configuration: QCKConfiguration) {
        Injection.shared.setupTestURLSession()
        Nimble.PollingDefaults.timeout = .seconds(5)
        Nimble.PollingDefaults.pollInterval = .milliseconds(100)
    }
}
