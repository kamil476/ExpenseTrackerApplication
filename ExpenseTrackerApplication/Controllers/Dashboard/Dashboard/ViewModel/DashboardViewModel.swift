//
//  DashboardViewModel.swift
//  ExpenseTrackerApplication
//
//  Created by Kamil Kakar on 28/03/2025.
//

import Foundation

class DashboardViewModel {
    
    var expenses: [Expense] = []
    var incomes: [Income] = []
    
    // MARK: - Properties for Total Calculation
    var totalIncome: Double {
        return calculateTotalIncome()
    }
    
    var totalExpenses: Double {
        return calculateTotalExpenses()
    }
    
    var accountBalance: Double {
        return totalIncome - totalExpenses
    }
    
    // MARK: - Functions to Calculate Totals
    func calculateTotalIncome() -> Double {
        return incomes.reduce(0) { result, income in
            return result + income.incomeAmount
        }
    }
    
    func calculateTotalExpenses() -> Double {
        return expenses.reduce(0) { result, expense in
            return result + expense.expenseAmount
        }
    }
    
    // MARK: - Fetch Expenses and Incomes
    func loadExpensesAndIncomes() {
        // Fetch today's expenses and incomes using CoreDataManager
        if let fetchedExpenses = CoreDataManager.shared.fetchTodayExpense() {
            expenses = fetchedExpenses
        }
        if let fetchedIncomes = CoreDataManager.shared.fetchTodayIncome() {
            incomes = fetchedIncomes
        }
    }
}
