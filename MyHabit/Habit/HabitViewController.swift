//
//  HabitViewController.swift
//  MyHabit
//
//  Created by  Ivan Kamenev on 26.02.2021.
//

import UIKit

class HabitViewController: UIViewController {

    var onDismiss: (() -> Void)?
    var cancelAction: (() -> Void)?
    let currentTime: Date = Date()
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeDatePicker: UIDatePicker!
    @IBOutlet weak var deleteHabitButton: UIButton!
    
    private let defaultName: String? = ""
    private let defaultColor: UIColor? = UIColor(named: "Color_161_22_204")
    private let defaultHabitColor: UIColor? = UIColor(named: "Color_255_159_79")
    
    public var state: State = .create
    public var habit: Habit?

        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let habit = habit {
            nameTextField.text = habit.name
            colorView.backgroundColor = habit.color
            timeDatePicker.date = habit.date
        } else {
            nameTextField.text = defaultName
            colorView.backgroundColor = defaultColor
            timeDatePicker.date = currentTime
        }
        timeLabel.setColorForPart(wholeText: timeDatePicker.date.timeToHabitString(), coloredPartText: timeDatePicker.date.timeToString(), colorOfPart: defaultColor!)
        
        switch state {
        case .create:
            navItem.title = "Создать"
            deleteHabitButton.isEnabled = false
            deleteHabitButton.alpha = 0
        default: 
            navItem.title = "Править"
            deleteHabitButton.alpha = 1
            deleteHabitButton.isEnabled = true
        }

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapBackground))
        contentView.addGestureRecognizer(tapGesture)
        
        let tapColorGesture = UITapGestureRecognizer(target: self, action: #selector(tapColorAction))
        colorView.addGestureRecognizer(tapColorGesture)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @IBAction func closeButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true) { [weak self] in
            self?.cancelAction?()
        }
        
    }
    

    @IBAction func deleteHabitButtonTap(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Удалить привычку", message: "Вы хотите удалить привычку \(habit!.name)?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)

        let deleteAction = UIAlertAction(title: "Удалить", style: .default) { [self] action in
            if let index = HabitsStore.shared.habits.firstIndex(of: habit!) {
                HabitsStore.shared.habits.remove(at: index)
                self.dismiss(animated: true) { [weak self] in
                    self?.onDismiss?()
                }
                
            }
        }
            
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        switch state {
        case .create:

            habit = Habit(name: nameTextField.text!,
                          date: timeDatePicker.date,
                          color: colorView.backgroundColor!)
            
            HabitsStore.shared.habits.append(habit!)
        default:

            habit!.name = nameTextField.text!
            habit!.date = timeDatePicker.date
            habit!.color = colorView.backgroundColor!
            
            HabitsStore.shared.save()
        }

        self.dismiss(animated: true) { [weak self] in
            self?.onDismiss?()
        }
    }
    

    @IBAction func timeDatePickerChanged(_ sender: Any) {
 
        timeLabel.setColorForPart(wholeText: timeDatePicker.date.timeToHabitString(), coloredPartText: timeDatePicker.date.timeToString(), colorOfPart: defaultColor!)
    }
    
    
    
    // MARK: Keyboard actions
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {

            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + view.safeAreaInsets.bottom, right: 0)
            scrollView.contentInset = contentInsets
            scrollView.verticalScrollIndicatorInsets = contentInsets
            }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.verticalScrollIndicatorInsets = .zero
    }
    
    // MARK: Actions
    @objc private func tapBackground() {
        hideKeyboard()
    }
    
    @objc private func tapColorAction() {
        showUIColorPickerViewController()
    }

    func hideKeyboard() {
        view.endEditing(true)
    }
    
    func showUIColorPickerViewController() {
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        colorPicker.selectedColor = colorView.backgroundColor!
        colorPicker.title = "Задайте цвет привычки"
        present(colorPicker, animated: true, completion: nil)
    }
}

extension HabitViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        colorView.backgroundColor = viewController.selectedColor
    }
}

extension NSMutableAttributedString{
    func setColorForPart(_ textToFind: String?, with color: UIColor) {

        let range:NSRange?
        if let text = textToFind{
            range = self.mutableString.range(of: text, options: .caseInsensitive)
        }else{
            range = NSMakeRange(0, self.length)
        }
        if range!.location != NSNotFound {
            addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range!)
        }
    }
}

extension UILabel {
    func setColorForPart(wholeText: String?, coloredPartText: String?, colorOfPart: UIColor) {
        if let wholeText = wholeText {
            let string: NSMutableAttributedString = NSMutableAttributedString(string: wholeText)
            string.setColorForPart(coloredPartText, with: colorOfPart)
            attributedText = string
        } else {
            attributedText = nil
        }
        
    }
}

extension Date {
    public func dateToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru")
        dateFormatter.dateFormat = "dd MMMM yyyy"
        return dateFormatter.string(from: self)
    }
    
    public func timeToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
    
    public func timeToHabitString() -> String {
        "Каждый день в " + timeToString()
    }
}

