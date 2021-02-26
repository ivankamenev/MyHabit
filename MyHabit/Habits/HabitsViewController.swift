//
//  HabitsViewController.swift
//  MyHabit
//
//  Created by  Ivan Kamenev on 26.02.2021.
//

import UIKit

private let progressCellreuseIdentifier = "progressCollectionViewCell"

private let habitCellReuseIdentifier = "habitCollectionViewCell"

class HabitsViewController: UICollectionViewController {
    
    
    @IBOutlet var colView: UICollectionView!
    
    private var progressCell: ProgressCollectionViewCell?

    override func viewDidLoad() {
        super.viewDidLoad()


        self.title = "Сегодня"
        
        colView.translatesAutoresizingMaskIntoConstraints = false
        colView.dataSource = self
        colView.delegate = self
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createHabitButtonPressed" {
            let controller = segue.destination as! HabitViewController
    
            controller.state = .create
            controller.colView = collectionView
        }
        else if segue.identifier == "showDates"
        {
            let controller = segue.destination as! HabitDetailViewController
            controller.habit = (sender as! HabitCollectionViewCell).habit
            controller.colView = collectionView
        }
    }

}

// MARK: UICollectionViewDataSource
extension HabitsViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (1 + HabitsStore.shared.habits.count)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 && indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: progressCellreuseIdentifier, for: indexPath) as! ProgressCollectionViewCell

            cell.percents = HabitsStore.shared.todayProgress
            progressCell = cell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: habitCellReuseIdentifier, for: indexPath) as! HabitCollectionViewCell

            cell.progressCell = self.progressCell
            cell.habit = HabitsStore.shared.habits[indexPath.item - 1]
            return cell
        }
    }

}

extension HabitsViewController: UICollectionViewDelegateFlowLayout {
    var topOffset: CGFloat {
        return 22
    }
    
    var offset: CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 && indexPath.item == 0 {
            return CGSize(width: collectionView.bounds.width-2*offset, height: 60)
        } else {
            return CGSize(width: collectionView.bounds.width-2*offset, height: 130)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return offset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return offset
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: topOffset, left: offset, bottom: .zero, right: offset)
    }
}
