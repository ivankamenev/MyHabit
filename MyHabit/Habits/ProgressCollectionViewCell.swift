//
//  ProgressCollectionViewCell.swift
//  MyHabit
//
//  Created by  Ivan Kamenev on 26.02.2021.
//

import UIKit

class ProgressCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    
    public var percents: Float = HabitsStore.shared.todayProgress {
        didSet(value) {
            percentsShow()
        }
    }
    
    private func percentsShow() {
        progressView.progress = percents
        progressLabel.text = "\(Int(percents*100))%"
    }
    
    override func layerWillDraw(_ layer: CALayer) {
        percentsShow()
    }
}

