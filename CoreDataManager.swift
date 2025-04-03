//
//  CoreDataManager.swift
//  ExpenseTrackerApplication
//
//  Created by Kamil Kakar on 19/03/2025.
//

import Foundation
import CoreData

class CoreDataManager {

    // Singleton instance
    static let shared = CoreDataManager()
    // Managed Object Context
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    // Persistent Container
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        return container
    }()
    
    // MARK: - Save Budget
    func saveBudget(budgetDate: Date, budgetCategory: String, budgetAmount: Double, currentSpent: Double, budgetImage: String) {
        // Create a new object
        let budgetEntity = Budget(context: context)
        // Set the properties of the entity
        budgetEntity.budgetAmount = budgetAmount
        budgetEntity.budgetDate = budgetDate
        budgetEntity.budgetCategory = budgetCategory
        budgetEntity.currentSpent = currentSpent
        // Save to persist the data
        saveContext()
    }
    
    // MARK: - Save Category
    func saveCategory(categoryName: String) {
        // Create a new object
        let categoryEntity = Category(context: context)
        // Set the properties of the entity
        categoryEntity.categoryName = categoryName
        // Save to persist the data
        saveContext()
    }
    
    // MARK: - Save Expense
    func saveExpense(expenseAmount: Double, expenseCategory: String, expenseDate: Date, expenseDetails: String, isIncome: Bool) {
        // Create a new object
        let expenseEntity = Expense(context: context)
        // Set the properties of the entity
        expenseEntity.expenseAmount = expenseAmount
        expenseEntity.expenseCategory = expenseCategory
        expenseEntity.expenseDate = expenseDate
        expenseEntity.expenseDetails = expenseDetails
        expenseEntity.isIncome = isIncome
        // Save to persist the data
        saveContext()
    }
    
    // MARK: - Save Income
    func saveIncome(incomeAmount: Double, incomeCategory: String, incomeDate: Date, incomeDetails: String) {
        // Create a new object
        let incomeEntity = Income(context: context)
        // Set the properties of the entity
        incomeEntity.incomeAmount = incomeAmount
        incomeEntity.incomeCategory = incomeCategory
        incomeEntity.incomeDate = incomeDate
        incomeEntity.incomeDetails = incomeDetails
        // Save to persist the data
        saveContext()
    }
    
    // MARK: - Fetch Budget
    func fetchBudget() -> [Budget]? {
        let fetchRequest: NSFetchRequest<Budget> = Budget.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch budgets: \(error)")
            return nil
        }
    }
    
    // MARK: - Fetch Category
    func fetchBudget() -> [Category]? {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch drinks: \(error)")
            return nil
        }
    }
    
    // MARK: - Fetch Expense
    func fetchBudget() -> [Expense]? {
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch drinks: \(error)")
            return nil
        }
    }
    
    // MARK: - Fetch Income
    func fetchBudget() -> [Income]? {
        let fetchRequest: NSFetchRequest<Income> = Income.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch drinks: \(error)")
            return nil
        }
    }
    func fetchTodayExpense() -> [Expense]? {
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        let calendar = Calendar.current
        let todayStart = calendar.startOfDay(for: Date()) // Current din ka start time
        fetchRequest.predicate = NSPredicate(format: "expenseDate >= %@", todayStart as NSDate) // Filter
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch today's drinks: \(error)")
            return nil
        }
    }
    func fetchTodayIncome() -> [Income]? {
        let fetchRequest: NSFetchRequest<Income> = Income.fetchRequest()

        let calendar = Calendar.current
        let todayStart = calendar.startOfDay(for: Date()) // Current din ka start time
        fetchRequest.predicate = NSPredicate(format: "incomeDate >= %@", todayStart as NSDate) // Filter
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch today's drinks: \(error)")
            return nil
        }
    }
    
    // MARK: - Save Context
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }
}
