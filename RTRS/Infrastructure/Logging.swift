//
//  Logging.swift
//  Testing
//
//  Created by Vlada Calic on 16/09/2020.
//

import Foundation

protocol Logging {
  func doLog(_ level: LogLevel, _ message: String, file: StaticString, line: UInt)
}

extension Logging {
  func debug(_ message: String, file: StaticString = #file, line: UInt = #line) {
    doLog(.debug, message, file: file, line: line)
  }

  func info(_ message: String, file: StaticString = #file, line: UInt = #line) {
    doLog(.info, message, file: file, line: line)
  }

  func log(_ message: String, file: StaticString = #file, line: UInt = #line) {
    doLog(.info, message, file: file, line: line)
  }

  func warn(_ message: String, file: StaticString = #file, line: UInt = #line) {
    doLog(.warn, message, file: file, line: line)
  }

  func error(_ message: String, file: StaticString = #file, line: UInt = #line) {
    doLog(.error, message, file: file, line: line)
  }
}

enum LogLevel {
  case debug
  case info
  case warn
  case error
}
