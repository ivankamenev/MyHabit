//
//  HabitDetailViewController.swift
//  MyHabit
//
//  Created by  Ivan Kamenev on 26.02.2021.
//

import UIKit

class HabitDetailViewController: UITableViewController {

    var habit: Habit?
    
    private let reuseIdentifier = "HabitDetailsTableViewCell"

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HabitsStore.shared.dates.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! HabitDetailsTableViewCell
        cell.dateLabel.text = HabitsStore.shared.trackDateString(forIndex: indexPath.row)
        cell.accessoryType = HabitsStore.shared.habit(habit!, isTrackedIn: HabitsStore.shared.dates[indexPath.row]) ? .checkmark : .none
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "АКТИВНОСТЬ"
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editHabitButtonPressed" {
            let controller = segue.destination as! HabitViewController
    
            controller.state = .edit
            controller.habit = habit
            
            controller.onDismiss = { [weak self] in
                if let vc =  self?.navigationController?.viewControllers[0] as? HabitsViewController {
                    vc.isUpdateNeeded = !vc.isUpdateNeeded
                self?.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}
