//
//  AddIncomeViewController.swift
//  ExpenseTrackerApplication
//
//  Created by Kamil Kakar on 13/03/2025.

import UIKit

class AddIncomeViewController: UIViewController {
    
    // MARK: - UI COMPONENTS
    private let fieldsView: UIView = {
        let bottomview = UIView()
        bottomview.backgroundColor = .white
        bottomview.layer.cornerRadius = 30
        bottomview.layer.shadowColor = UIColor.black.cgColor
        bottomview.layer.shadowOpacity = 0.2
        bottomview.layer.shadowOffset = CGSize(width: 0, height: -3)
        bottomview.layer.shadowRadius = 5
        bottomview.translatesAutoresizingMaskIntoConstraints = false
        return bottomview
    }()
    private let categoryFieldView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 14
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray5.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var descriptionFieldView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 14
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray5.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let descriptiontextField: UITextField = {
        let txt = UITextField()
        txt.placeholder = "Enter description"
        txt.font = UIFont.systemFont(ofSize: 16)
        txt.textColor = .black
        txt.borderStyle = .none
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    private let amountSpent: UITextField = {
        let txt = UITextField()
        txt.font = UIFont.boldSystemFont(ofSize: 40)
        txt.textColor = .white
        txt.borderStyle = .none
        txt.text = "0"
        txt.keyboardType = .numberPad
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    private let walletFieldView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 14
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray5.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let attachmentFieldView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 14
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray5.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Select Category"
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let walletLabel: UILabel = {
        let label = UILabel()
        label.text = "Select Wallet"
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let attachmentLabel: UILabel = {
        let label = UILabel()
        label.text = "Add Attachment"
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let categoryDropdown: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.layer.backgroundColor = .none
        tableView.layer.cornerRadius = 10
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.systemGray5.cgColor
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    private let walletDropdown: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.layer.backgroundColor = .none
        tableView.layer.cornerRadius = 10
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.systemGray5.cgColor
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    private let continueButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Continue", for: .normal)
        btn.backgroundColor = UIColor(hex: "7F3DFF")
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        btn.layer.cornerRadius = 25
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        return btn
    }()
    private let leftArrowButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "arrowLeft"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    private let cancelButton: UIButton = {
        let closeButton = UIButton()
        closeButton.setTitle("Close", for: .normal)
        closeButton.addTarget(AddExpenseViewController.self, action: #selector (closeBottomSheet), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        return closeButton
    }()
    private let crossButtonForImage: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "crossIcon"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        print("target to crossButtonForImage")
        btn.addTarget(AddExpenseViewController.self, action: #selector(removeAttachment), for: .touchUpInside)
        btn.isHidden = true
        return btn
    }()
    private let bottomSheetView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: -3)
        view.layer.shadowRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let attachmentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let dropDownArrow = CustomImageView(imageName: "arrowDropDown")
    private let attachmentPin = CustomImageView(imageName: "attachmentPin")
    private let dropDownArrowWallet = CustomImageView(imageName: "arrowDropDown")
    private let categoryOptions = ["Food", "Transport", "Shopping", "Entertainment", "Donations", "Bills", "Repairs", "Fuel"]
    private let walletOptions = ["EasyPaisa"]
    private let titleLabel = CustomLabel(text: "Income", textColor: .white, font: UIFont.systemFont(ofSize: 20, weight: .bold))
    private let askAmount = CustomLabel(text: "How much?", textColor: .systemGray5, font: UIFont.systemFont(ofSize: 16, weight: .semibold))
    private let currencyLabel = CustomLabel(text: "Rs.", textColor: .white, font: UIFont.systemFont(ofSize: 35, weight: .semibold))
    
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "00A86B")
        setupView()
        setupDropdowns()
    }
    
    // MARK: - FUNCTIONS
    private func setupView(){
        view.addSubview(fieldsView)
        view.addSubview(leftArrowButton)
        view.addSubview(titleLabel)
        view.addSubview(askAmount)
        view.addSubview(continueButton)
        view.addSubview(amountSpent)
        view.addSubview(currencyLabel)
        fieldsView.addSubview(continueButton)
        fieldsView.addSubview(categoryFieldView)
        fieldsView.addSubview(descriptionFieldView)
        fieldsView.addSubview(walletFieldView)
        fieldsView.addSubview(categoryDropdown)
        fieldsView.addSubview(walletDropdown)
        fieldsView.addSubview(attachmentFieldView)
        categoryFieldView.addSubview(categoryLabel)
        walletFieldView.addSubview(walletLabel)
        categoryFieldView.addSubview(dropDownArrow)
        walletFieldView.addSubview(dropDownArrowWallet)
        attachmentFieldView.addSubview(attachmentLabel)
        attachmentFieldView.addSubview(attachmentPin)
        fieldsView.addSubview(attachmentImageView)
        attachmentImageView.addSubview(crossButtonForImage)
        descriptionFieldView.addSubview(descriptiontextField)
        
        let tapCategory = UITapGestureRecognizer(target: self, action: #selector(showCategoryDropdown))
        categoryFieldView.addGestureRecognizer(tapCategory)
        
        let tapWallet = UITapGestureRecognizer(target: self, action: #selector(showWalletDropdown))
        walletFieldView.addGestureRecognizer(tapWallet)
        
        let tapAttachment = UITapGestureRecognizer(target: self, action: #selector(openAttachmentBottomSheet))
        attachmentFieldView.addGestureRecognizer(tapAttachment)
        
        NSLayoutConstraint.activate([
            categoryFieldView.leadingAnchor.constraint(equalTo: fieldsView.leadingAnchor, constant: 25),
            categoryFieldView.topAnchor.constraint(equalTo: fieldsView.topAnchor, constant: 30),
            categoryFieldView.heightAnchor.constraint(equalToConstant: 60),
            categoryFieldView.trailingAnchor.constraint(equalTo: fieldsView.trailingAnchor, constant: -25),
            
            descriptionFieldView.leadingAnchor.constraint(equalTo: fieldsView.leadingAnchor, constant: 25),
            descriptionFieldView.topAnchor.constraint(equalTo: categoryFieldView.bottomAnchor, constant: 17),
            descriptionFieldView.heightAnchor.constraint(equalToConstant: 60),
            descriptionFieldView.trailingAnchor.constraint(equalTo: fieldsView.trailingAnchor, constant: -25),
            
            walletFieldView.leadingAnchor.constraint(equalTo: fieldsView.leadingAnchor, constant: 25),
            walletFieldView.topAnchor.constraint(equalTo: descriptionFieldView.bottomAnchor, constant: 17),
            walletFieldView.heightAnchor.constraint(equalToConstant: 60),
            walletFieldView.trailingAnchor.constraint(equalTo: fieldsView.trailingAnchor, constant: -25),
            
            attachmentFieldView.leadingAnchor.constraint(equalTo: fieldsView.leadingAnchor, constant: 25),
            attachmentFieldView.topAnchor.constraint(equalTo: walletFieldView.bottomAnchor, constant: 17),
            attachmentFieldView.heightAnchor.constraint(equalToConstant: 60),
            attachmentFieldView.trailingAnchor.constraint(equalTo: fieldsView.trailingAnchor, constant: -25),
            
            dropDownArrow.topAnchor.constraint(equalTo: categoryFieldView.topAnchor, constant: 17),
            dropDownArrow.heightAnchor.constraint(equalToConstant: 30),
            dropDownArrow.trailingAnchor.constraint(equalTo: categoryFieldView.trailingAnchor, constant: -6),
            
            dropDownArrowWallet.topAnchor.constraint(equalTo: walletFieldView.topAnchor, constant: 17),
            dropDownArrowWallet.heightAnchor.constraint(equalToConstant: 30),
            dropDownArrowWallet.trailingAnchor.constraint(equalTo: walletFieldView.trailingAnchor, constant: -6),
            
            continueButton.centerXAnchor.constraint(equalTo: fieldsView.centerXAnchor),
            continueButton.bottomAnchor.constraint(equalTo: fieldsView.bottomAnchor, constant: -105),
            continueButton.heightAnchor.constraint(equalToConstant: 50),
            continueButton.widthAnchor.constraint(equalToConstant: 300),
            
            askAmount.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            askAmount.bottomAnchor.constraint(equalTo: fieldsView.topAnchor, constant: -100),
            
            currencyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            currencyLabel.bottomAnchor.constraint(equalTo: fieldsView.topAnchor, constant: -25),
            
            amountSpent.leadingAnchor.constraint(equalTo: currencyLabel.trailingAnchor, constant: 4),
            amountSpent.bottomAnchor.constraint(equalTo: fieldsView.topAnchor, constant: -8),
            amountSpent.topAnchor.constraint(equalTo: askAmount.bottomAnchor, constant: 10),
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            
            leftArrowButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            leftArrowButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            
            fieldsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            fieldsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            fieldsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            fieldsView.heightAnchor.constraint(equalToConstant: 500),
            fieldsView.widthAnchor.constraint(equalToConstant: 200),
            
            categoryLabel.centerYAnchor.constraint(equalTo: categoryFieldView.centerYAnchor),
            categoryLabel.leadingAnchor.constraint(equalTo: categoryFieldView.leadingAnchor, constant: 10),
            
            descriptiontextField.centerYAnchor.constraint(equalTo: descriptionFieldView.centerYAnchor),
            descriptiontextField.leadingAnchor.constraint(equalTo: descriptionFieldView.leadingAnchor, constant: 10),
            
            categoryDropdown.topAnchor.constraint(equalTo: categoryFieldView.bottomAnchor),
            categoryDropdown.leadingAnchor.constraint(equalTo: categoryFieldView.leadingAnchor),
            categoryDropdown.trailingAnchor.constraint(equalTo: categoryFieldView.trailingAnchor),
            categoryDropdown.heightAnchor.constraint(equalToConstant: 150),
            
            walletLabel.centerYAnchor.constraint(equalTo: walletFieldView.centerYAnchor),
            walletLabel.leadingAnchor.constraint(equalTo: walletFieldView.leadingAnchor, constant: 10),
            
            attachmentLabel.trailingAnchor.constraint(equalTo: attachmentFieldView.trailingAnchor, constant: -90),
            attachmentLabel.centerYAnchor.constraint(equalTo: attachmentFieldView.centerYAnchor),
            
            attachmentPin.topAnchor.constraint(equalTo: attachmentFieldView.topAnchor, constant: 15),
            attachmentPin.heightAnchor.constraint(equalToConstant: 30),
            attachmentPin.leadingAnchor.constraint(equalTo: attachmentFieldView.leadingAnchor, constant: 90),
            
            walletDropdown.centerYAnchor.constraint(equalTo: walletFieldView.centerYAnchor),
            walletDropdown.leadingAnchor.constraint(equalTo: walletFieldView.leadingAnchor),
            walletDropdown.trailingAnchor.constraint(equalTo: walletFieldView.trailingAnchor),
            walletDropdown.heightAnchor.constraint(equalToConstant: 150),
            
            attachmentImageView.leadingAnchor.constraint(equalTo: fieldsView.leadingAnchor, constant: 28),
            attachmentImageView.topAnchor.constraint(equalTo: walletFieldView.bottomAnchor, constant: 10),
            attachmentImageView.widthAnchor.constraint(equalToConstant: 100),
            attachmentImageView.heightAnchor.constraint(equalToConstant: 100),
            
            crossButtonForImage.topAnchor.constraint(equalTo: attachmentImageView.topAnchor, constant: 2),
            crossButtonForImage.trailingAnchor.constraint(equalTo: attachmentImageView.trailingAnchor, constant: -1),
            crossButtonForImage.widthAnchor.constraint(equalToConstant: 22),
            crossButtonForImage.heightAnchor.constraint(equalToConstant: 22),
        ])
    }
    private func setupDropdowns() {
        categoryDropdown.delegate = self
        categoryDropdown.dataSource = self
        walletDropdown.delegate = self
        walletDropdown.dataSource = self
    }
    private func openImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    private func setupBottomSheet() {
        bottomSheetView.addSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: bottomSheetView.topAnchor, constant: 20),
            cancelButton.centerXAnchor.constraint(equalTo: bottomSheetView.centerXAnchor)
        ])
    }
    private func createButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(hex: "7F3DFF")
        button.layer.cornerRadius = 8
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    // MARK: - ACTIONS/EVENT LISTENERS
    @objc private func openAttachmentBottomSheet() {
        view.addSubview(bottomSheetView)
        let cameraButton = createButton(title: "Take Photo", action: #selector(cameraTapped))
        let galleryButton = createButton(title: "Choose from Gallery", action: #selector(galleryTapped))
        let cancelButton = createButton(title: "Cancel", action: #selector(closeBottomSheet))
        
        let stackView = UIStackView(arrangedSubviews: [cameraButton, galleryButton, cancelButton])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        bottomSheetView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            bottomSheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomSheetView.heightAnchor.constraint(equalToConstant: 270),
            bottomSheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 300),
            
            stackView.centerXAnchor.constraint(equalTo: bottomSheetView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: bottomSheetView.centerYAnchor),
            stackView.widthAnchor.constraint(equalTo: bottomSheetView.widthAnchor, multiplier: 0.8),
        ])
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3) {
            self.bottomSheetView.transform = CGAffineTransform(translationX: 0, y: -380)
        }
    }
    @objc private func showCategoryDropdown() {
        categoryDropdown.isHidden.toggle()
    }
    @objc private func showWalletDropdown() {
        walletDropdown.isHidden.toggle()
    }
    @objc private func cameraTapped() {
        openImagePicker(sourceType: .camera)
        closeBottomSheet()
    }
    @objc private func galleryTapped() {
        openImagePicker(sourceType: .photoLibrary)
        closeBottomSheet()
    }
    @objc private func removeAttachment() {
        print("Removing attachment")
        attachmentImageView.image = nil
        crossButtonForImage.isHidden = true
        attachmentFieldView.isHidden = false
    }
    @objc private func closeBottomSheet() {
        UIView.animate(withDuration: 0.3, animations: {
            self.bottomSheetView.transform = CGAffineTransform(translationX: 0, y: 300)
        }) { _ in
            self.bottomSheetView.removeFromSuperview()
        }
    }
    @objc private func continueButtonTapped() {
        // Get data from text fields
        guard let incomeName = categoryLabel.text,
              let incomeAmountText = amountSpent.text,
              let incomeAmount = Double(incomeAmountText),
              let incomeDescription = descriptiontextField.text else {
            return
        }
        // Save expense data using CoreDataManager
        CoreDataManager.shared.saveIncome(incomeAmount: incomeAmount, incomeCategory: incomeName, incomeDate: Date(), incomeDetails: incomeDescription)
        // Dismiss the view controller
        showSuccessAlert()
        navigationController?.popViewController(animated: true)
    }
}

// MARK: -  TABLEVIEW METHODS
extension AddIncomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == categoryDropdown ? categoryOptions.count : walletOptions.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = tableView == categoryDropdown ? categoryOptions[indexPath.row] : walletOptions[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == categoryDropdown {
            categoryLabel.text = categoryOptions[indexPath.row]
            categoryDropdown.isHidden = true
        } else if tableView == walletDropdown {
            walletLabel.text = walletOptions[indexPath.row]
            walletDropdown.isHidden = true
        }
    }
}

// MARK: -  IMAGEPICKER METHODS
extension AddIncomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.editedImage] as? UIImage {
            attachmentImageView.image = selectedImage
        } else if let selectedImage = info[.originalImage] as? UIImage {
            attachmentImageView.image = selectedImage
        }
        crossButtonForImage.isHidden = false
        attachmentFieldView.isHidden = true
        print("Attachment selected")
        picker.dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

// MARK: -  TEXTFIELD DELEGATE
extension AddIncomeViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
