////
////  AddIncomeViewModel.swift
////  ExpenseTrackerApplication
////
////  Created by Kamil Kakar on 24/03/2025.
////
//
//import UIKit
//
//class AddIncomeViewModel {
//    
//    var categoryOptions = ["Food", "Transport", "Shopping", "Entertainment", "Donations", "Bills", "Repairs", "Fuel"]
//    var walletOptions = ["EasyPaisa"]
//    
//    var selectedCategory: String?
//    var selectedWallet: String?
//    var incomeAmount: Double = 0
//    var incomeDescription: String = ""
//    
//    var selectedAttachment: UIImage?
//    
//    // MARK: - Actions
//    func saveIncome(incomeAmount: Double, incomeCategory: String, incomeDescription: String) {
//        // Save the income data using CoreDataManager (or any other manager)
//        CoreDataManager.shared.saveIncome(incomeAmount: incomeAmount, incomeCategory: incomeCategory, incomeDate: Date(), incomeDetails: incomeDescription)
//    }
//
//    func handleAttachmentSelection(selectedImage: UIImage) {
//        self.selectedAttachment = selectedImage
//    }
//    
//    func handleCategorySelection(index: Int) {
//        self.selectedCategory = categoryOptions[index]
//    }
//    
//    func handleWalletSelection(index: Int) {
//        self.selectedWallet = walletOptions[index]
//    }
//    
//    func removeAttachment() {
//        self.selectedAttachment = nil
//    }
//    
//    func handleContinueButtonTapped(incomeAmountText: String?, descriptionText: String?, onSuccess: () -> Void) {
//        guard let incomeAmountText = incomeAmountText,
//              let incomeAmount = Double(incomeAmountText),
//              let incomeDescription = descriptionText else {
//            return
//        }
//        self.incomeAmount = incomeAmount
//        self.incomeDescription = incomeDescription
//        self.saveIncome(incomeAmount: incomeAmount, incomeCategory: selectedCategory ?? "", incomeDescription: incomeDescription)
//        onSuccess()
//    }
//}
