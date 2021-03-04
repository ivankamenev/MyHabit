//
//  HabitCollectionViewCell.swift
//  MyHabit
//
//  Created by  Ivan Kamenev on 26.02.2021.
//

import UIKit

class HabitCollectionViewCell: UICollectionViewCell {
    
    var onHabitTracked: (() -> Void)?
    
    var habit: Habit? {
        didSet {
            guard let habit = habit else { return }
            
            nameLabel.text = habit.name
            nameLabel.textColor = habit.color
            timeLabel.text = habit.dateString
            repeatedLabel.text = "Подряд: \(habit.trackDates.count)"
            didItButton.isSelected = habit.isAlreadyTakenToday
            didItButton.tintColor = habit.color
        }
    }
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var repeatedLabel: UILabel!
    @IBOutlet private weak var didItButton: UIButton!
    
    @IBAction func didItButtonTouched(_ sender: Any) {
        guard let habit = habit else { return }
        
        if !habit.isAlreadyTakenToday {
            didItButton.isSelected = !didItButton.isSelected
            HabitsStore.shared.track(habit)
            
            onHabitTracked?()
            
        }
    }
}
