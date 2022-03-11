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
import UIKit

extension Device {
  static func current() -> Device? {
    guard let data = FileManager.default.contents(atPath: currentDeviceURL.path) else {
      return nil
    }

    return try! JSONDecoder().decode(Device.self, from: data)
  }

  static func saveNew() {
    let updateDevice = UpdateDevice(system: .iOS, osVersion: UIDevice.current.systemVersion)
    save(with: updateDevice)
  }

  func save(completion: ((Bool) -> Void)? = nil) {
    let updateDevice = UpdateDevice(id: id,
                                    pushToken: pushToken,
                                    system: system,
                                    osVersion: osVersion,
                                    channels: channels)
    Device.save(with: updateDevice, completion: completion)
  }

  private static func save(with updateDevice: UpdateDevice, completion: ((Bool) -> Void)? = nil) {
    URLSession.shared.jsonDecodableDataTask(of: Device.self, url: URL(string: "\(serverURL)/devices/update")!, httpMethod: "PUT", body: try? JSONEncoder().encode(updateDevice)) {
      switch $0 {
      case .success(let device):
        print("Device updated successfully: \(device)")
        device.persist()
        completion?(true)
      case .failure(let error):
        print("Failure updating device: \(error)")
        completion?(false)
      }
    }
  }

  private func persist() {
    let data = try! JSONEncoder().encode(self)
    try! data.write(to: Device.currentDeviceURL)
  }

  private static var currentDeviceURL: URL {
    getDocumentsDirectory().appendingPathComponent("CurrentDevice.swift")
  }

  private static func getDocumentsDirectory() -> URL {
    FileManager.default
      .urls(for: .documentDirectory, in: .userDomainMask)
      .first!
  }
}
