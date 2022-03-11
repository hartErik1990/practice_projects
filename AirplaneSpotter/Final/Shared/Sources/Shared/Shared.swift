/// Copyright (c) 2020 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation

public struct UpdateDevice: Codable {
  public let id: UUID?
  public let pushToken: String?
  public let system: Device.System
  public let osVersion: String
  public let channels: [String]?

  public init(id: UUID? = nil, pushToken: String? = nil, system: Device.System, osVersion: String, channels: [String]? = nil) {
    self.id = id
    self.pushToken = pushToken
    self.system = system
    self.osVersion = osVersion
    self.channels = channels
  }
}

public struct Device: Codable {
  public enum System: String, Codable {
    case iOS
    case android
  }

  public let id: UUID
  public let system: System
  public var osVersion: String
  public var pushToken: String?
  public var channels: [String]

  public init(id: UUID, system: System, osVersion: String, pushToken: String?, channels: [String]) {
    self.id = id
    self.system = system
    self.osVersion = osVersion
    self.pushToken = pushToken
    self.channels = channels
  }
}


public struct Airport: Codable {
  public let id: UUID
  public let iataCode: String
  public let longName: String

  public init(id: UUID, iataCode: String, longName: String) {
    self.id = id
    self.iataCode = iataCode
    self.longName = longName
  }
}

struct Flight: Codable {
  public let id: UUID
  public let arrivalAirport: Airport
  public let flightNumber: String

  public init(id: UUID, arrivalAirport: Airport, flightNumber: String) {
    self.id = id
    self.arrivalAirport = arrivalAirport
    self.flightNumber = flightNumber
  }
}
