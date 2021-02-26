//
//  HabitDetailViewController.swift
//  MyHabit
//
//  Created by  Ivan Kamenev on 26.02.2021.
//

import UIKit

class HabitDetailViewController: UITableViewController {

    let reuseIdentifier = "HabitDetailsTableViewCell"
    public var habit: Habit? = nil
    public var colView: UICollectionView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return HabitsStore.shared.dates.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! HabitDetailsTableViewCell
        let maxI = HabitsStore.shared.dates.count - 1
        cell.dateLabel.text = HabitsStore.shared.trackDateString(forIndex: maxI-indexPath.row)
        cell.accessoryType = HabitsStore.shared.habit(habit!, isTrackedIn: HabitsStore.shared.dates[indexPath.row]) ? .checkmark : .none
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "АКТИВНОСТЬ"    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editHabitButtonPressed" {
            let controller = segue.destination as! HabitViewController
    
            controller.state = .edit
            controller.habit = habit
            controller.colView = colView
            controller.navController = self.navigationController
        }
    }
}
