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
import Foundation

class FlightsViewController: UITableViewController {
  var flights = [Flight]()

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "bell"),
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(showNotificationsSettings))
    tableView.allowsSelection = false
    tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: DetailTableViewCell.reuseIdentifier)

    fetchFlights()

    tableView.refreshControl = UIRefreshControl()
    tableView.refreshControl?.addTarget(self, action: #selector(fetchFlights), for: .valueChanged)
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    flights.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.reuseIdentifier) as! DetailTableViewCell

    let flight = flights[indexPath.row]
    cell.textLabel?.text = flight.flightNumber
    cell.detailTextLabel?.text = flight.arrivalAirport.longName

    return cell
  }

  @objc private func fetchFlights() {
    tableView.refreshControl?.beginRefreshing()
    URLSession.shared.jsonDecodableDataTask(of: [Flight].self, url: URL(string: "\(serverURL)/flights")!) { result in
      DispatchQueue.main.async {
        self.tableView.refreshControl?.endRefreshing()

        switch result {
        case .success(let flights):
          self.flights = flights
          self.tableView.reloadData()
        case .failure(let error):
          print(error)
        }
      }
    }
  }

  @objc private func showNotificationsSettings() {
    let navigationController = UINavigationController(rootViewController: NotificationsSettingsViewController())
    present(navigationController, animated: true)
  }
}
