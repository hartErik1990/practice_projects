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

import UIKit
import UserNotifications

class NotificationsSettingsViewController: UITableViewController {
  var airports = [Airport]()
  var selectedAirports = [String]()

  var currentDevice: Device? {
    Device.current()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: DetailTableViewCell.reuseIdentifier)
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                       style: .plain,
                                                       target: self,
                                                       action: #selector(cancel))
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save",
                                                        style: .done,
                                                        target: self,
                                                        action: #selector(save))
    
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
      print("Granted notifications?", granted)
      DispatchQueue.main.async {
        UIApplication.shared.registerForRemoteNotifications()
      }
    }
      Task {
          try await fetchAirports()
      }
  }
  
  @objc private func cancel() {
    dismiss(animated: true)
  }
  
    @objc private func save() async throws {
        guard var device = currentDevice else {
            return
        }
        
        device.channels = selectedAirports
        try await device.save()
        await MainActor.run { [weak self] in
            self?.dismiss(animated: true)
        }
        //      //{ success in
        //        await MainActor.run { [weak self] in
        //            if success {
        //            } else {
        //                //show alert
        //            }
        //
        //        }
        
        //}
    }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    airports.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.reuseIdentifier) as! DetailTableViewCell
    
    let airport = airports[indexPath.row]
    cell.textLabel?.text = airport.iataCode
    cell.detailTextLabel?.text = airport.longName
    
    if currentDevice?.channels.contains(airport.iataCode) == true {
      cell.accessoryType = .checkmark
    } else {
      cell.accessoryType = .none
    }
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    guard let cell = tableView.cellForRow(at: indexPath) else {
      return
    }
    
    let airport = airports[indexPath.row]
    
    if let existingIndex = selectedAirports.firstIndex(of: airport.iataCode) {
      selectedAirports.remove(at: existingIndex)
      cell.accessoryType = .none
    } else {
      selectedAirports.append(airport.iataCode)
      cell.accessoryType = .checkmark
    }
  }
  
    private func fetchAirports() async throws {
        let url = URL(string: "\(serverURL)/airports")!
        let urlRequst = URLRequest(url: url)
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequst, delegate: nil)
            guard let response = response as? HTTPURLResponse else {
                return
            }
            if response.statusCode < 300 {
                let decoder = JSONDecoder()
                let airports = try decoder.decode([Airport].self, from: data)
                self.airports = airports
                await MainActor.run { [weak self] in
                    guard let self = self else { return }
                    self.tableView.reloadData()
                }
            } else {
                fatalError("status code above 299")
            }
        } catch {
            throw error
        }
    }
}
