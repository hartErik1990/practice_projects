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

import Vapor
import APNS
import Fluent

extension Request.APNS {
  func send<Notification>(_ notification: Notification, to device: Device)
    -> EventLoopFuture<Void> where Notification: APNSwiftNotification {
      guard let pushToken = device.pushToken else {
        return self.eventLoop.makeSucceededFuture(())
      }

      return send(notification, to: pushToken)
  }

  func send<Notification>(_ notification: Notification, toChannel channel: String, on db: Database)
    -> EventLoopFuture<Void> where Notification: APNSwiftNotification {
      send(notification, toChannels: [channel], on: db)
  }

  func send<Notification>(_ notification: Notification, toChannels channels: [String], on db: Database)
    -> EventLoopFuture<Void> where Notification: APNSwiftNotification {
      Device.pushTokens(for: channels, on: db)
        .flatMap { deviceTokens in
          deviceTokens.map {
            self.send(notification, to: $0)
          }.flatten(on: self.eventLoop)
      }
  }
}

extension Request.APNS {
  func send(_ payload: APNSwiftPayload, to device: Device) -> EventLoopFuture<Void> {
    guard let pushToken = device.pushToken else {
      return self.eventLoop.makeSucceededFuture(())
    }

    return send(payload, to: pushToken)
  }

  func send(_ payload: APNSwiftPayload, toChannel channel: String, on db: Database)
    -> EventLoopFuture<Void> {
      send(payload, toChannels: [channel], on: db)
  }
  ///  .private(filePath: "/path/to/key.p8"),
  func send(_ payload: APNSwiftPayload, toChannels channels: [String], on db: Database)
    -> EventLoopFuture<Void> {
      Device.pushTokens(for: channels, on: db)
        .flatMap { deviceTokens in
          deviceTokens.map {
            self.send(payload, to: $0)
          }.flatten(on: self.eventLoop)
      }
  }
}
