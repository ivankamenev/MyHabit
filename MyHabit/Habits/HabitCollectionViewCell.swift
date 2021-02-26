//
//  HabitCollectionViewCell.swift
//  MyHabit
//
//  Created by  Ivan Kamenev on 26.02.2021.
//

import UIKit

class HabitCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var repeatedLabel: UILabel!
    @IBOutlet weak var didItButton: UIButton!
    
    public var progressCell: ProgressCollectionViewCell?
    
    public var habit: Habit = Habit(name: "Test", date: Date(), color: .orange){
        didSet(value) {
            nameLabel.text = habit.name
            nameLabel.textColor = habit.color
            timeLabel.text = habit.dateString
            repeatedLabel.text = "Подряд: \(habit.trackDates.count)"
            didItButton.isSelected = habit.isAlreadyTakenToday
            didItButton.tintColor = habit.color
        }
    }
    
    @IBAction func didItButtonTouched(_ sender: Any) {
        if !habit.isAlreadyTakenToday {
            didItButton.isSelected = !didItButton.isSelected
            HabitsStore.shared.track(habit)
            if let progressCell = self.progressCell {
                progressCell.percents = HabitsStore.shared.todayProgress
            }
        }
    }
}
