//
//  ExpirationDateField.swift
//  Libralize-iOS
//
//  Created by Libralize on 07/10/2021.
//

import Foundation

class ExpirationDateField: View {
    
    var onTextChange: ((String) -> Void)?
    
    var expiredDate: String? {
        get {
            textfield.text
        }
        set {
            textfield.text = newValue
        }
    }
    
    private lazy var textfield: UITextField = {
        let textfield = UITextField()
        textfield.makeSize(height: 44)
        textfield.placeholder = "MM / YY"
        textfield.borderStyle = .roundedRect
        textfield.inputView = datePicker
        textfield.delegate = self
        return textfield
    }()
    
    private lazy var datePicker: MonthYearPicker = {
        let datePicker = MonthYearPicker()
        datePicker.onDateSelected = { [weak self] (month, year) in
            let year = year % 100
            let text = String(format: "%2d / %2d", month, year)
            self?.textfield.text = text
            self?.onTextChange?(text)
        }
        return datePicker
    }()
    
    override func makeUI() {
        super.makeUI()
        addSubview(textfield)
        textfield.makeEdgesEqualToSuperview()
    }
    
    override func becomeFirstResponder() -> Bool {
        textfield.becomeFirstResponder()
    }
}

extension ExpirationDateField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let month = datePicker.month
        let year = datePicker.year % 100
        let text = String(format: "%2d / %2d", month, year)
        self.textfield.text = text
        self.onTextChange?(text)
    }
}


class MonthYearPicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var months = [String]()
    var years = [Int]()
    
    var month = Calendar.current.component(.month, from: Date()) {
        didSet {
            selectRow(month - 1, inComponent: 0, animated: false)
        }
    }
    
    var year = Calendar.current.component(.year, from: Date()) {
        didSet {
            if let firstYearIndex = years.firstIndex(of: year) {
                selectRow(firstYearIndex, inComponent: 1, animated: true)
            }
        }
    }
    
    var onDateSelected: ((_ month: Int, _ year: Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetup()
    }
    
    func commonSetup() {
        // population years
        var year = Calendar(identifier: .gregorian).component(.year, from: Date())
        var years: [Int] = []
        if years.count == 0 {
            for _ in 1...20 {
                years.append(year)
                year += 1
            }
        }
        self.years = years
        
        // population months with localized names
        var months: [String] = []
        var month = 0
        for _ in 1...12 {
            months.append(DateFormatter().monthSymbols[month].capitalized)
            month += 1
        }
        self.months = months
        
        delegate = self
        dataSource = self
        
        let currentMonth = Calendar(identifier: .gregorian).component(.month, from: Date())
        selectRow(currentMonth - 1, inComponent: 0, animated: false)
        onDateSelected?(currentMonth, year)
    }
    
    // Mark: UIPicker Delegate / Data Source
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return months[row]
        case 1:
            return "\(years[row])"
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return months.count
        case 1:
            return years.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let month = selectedRow(inComponent: 0) + 1
        let year = years[selectedRow(inComponent: 1)]
        if let block = onDateSelected {
            block(month, year)
        }
        
        self.month = month
        self.year = year
    }
}
