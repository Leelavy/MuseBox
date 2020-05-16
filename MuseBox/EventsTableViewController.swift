//
//  EventsTableViewController.swift
//  MuseBox
//
//  Created by admin on 11/05/2020.
//  Copyright © 2020 Lee Lavy. All rights reserved.
//

import UIKit

class EventsTableViewController: UITableViewController {
    
    var allEvents = [Event]()
    var selectedCell:Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        
        //        ModelEvents.StudentDataEvent.observe {
        //            self.refreshControl?.beginRefreshing()
        //            self.reloadData();
        //        }
        self.refreshControl?.beginRefreshing()
        reloadData();
    }
    
    @objc func reloadData(){
        Model.instance.getAllEvents { (recievedData:[Event]?) in
            if recievedData != nil {
                self.allEvents = recievedData!.reversed()
                self.tableView.reloadData()
            }
            self.refreshControl?.endRefreshing()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allEvents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:EventTableViewCell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventTableViewCell
        
        let event = allEvents[indexPath.row]
        
        cell.eventNameLabel.text = event.eventName
        cell.dateLabel.text = event.date
        cell.timeLabel.text = event.time
        
        cell.eventImg.image = UIImage(named:"imgPlaceholder")
        if event.eventImgUrl != ""{
            cell.eventImg.kf.setImage(with: URL(string: event.eventImgUrl!))
        }
        
        cell.layer.borderWidth = CGFloat(5)
        cell.layer.borderColor = tableView.backgroundColor?.cgColor
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ToEventInfoSegue"){
            let EventInfo:EventInfoViewController = segue.destination as! EventInfoViewController
            EventInfo.event = selectedCell
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCell = allEvents[indexPath.row]
        performSegue(withIdentifier: "ToEventInfoSegue", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 274
    }
    
    
}
