//
//  CocoaLumberjackIntegration.swift
//  Testing
//
//  Created by Vlada Calic on 16/09/2020.
//

import CocoaLumberjackSwift
import Foundation

class CocoaLumberjackIntegration: Logging {
  init() {
    DDLog.sharedInstance.add(DDTTYLogger.sharedInstance!)
  }

  func doLog(_ level: LogLevel, _ message: String, file: StaticString, line: UInt) {
    switch level {
    case .debug:
      DDLogDebug(message, file: file, line: line)
    case .info:
      DDLogInfo(message, file: file, line: line)
    case .warn:
      DDLogWarn(message, file: file, line: line)
    case .error:
      DDLogError(message, file: file, line: line)
    }
  }
}
