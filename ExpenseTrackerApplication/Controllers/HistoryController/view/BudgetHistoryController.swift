//
//  ProfileController.swift
//  ExpenseTrackerApplication
//
//  Created by Kamil Kakar on 18/03/2025.
//

import UIKit

class BudgetHistoryController: UIViewController {
    
    var dataByDate: [(date: String, entries: [(type: String, data: Any)])] = [] // Holds both expenses and incomes under each date
    private let tableView = UITableView(frame: .zero, style: .grouped)
    var selectedFilter: String?
    var selectedSort: String?
    private let bottomSheetContainer = UIView()
    private var filterButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "filterIcon"), for: .normal)
        btn.layer.cornerRadius = 10
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOpacity = 0.2
        btn.layer.shadowOffset = CGSize(width: 1, height: 1)
        btn.layer.shadowRadius = 10
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(openFilterBottomSheet), for: .touchUpInside)
        return btn
    }()
    private let filterOptions = ["Income", "Expense", "Transfer"]
    private let sortOptions = ["Highest", "Lowest", "Newest", "Oldest"]
    
    private var selectedFilterButton: UIButton?
    private var selectedSortButton: UIButton?
    
    private let filterStack = UIStackView()
    private let sortStack = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
        setupFilter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Fetch data
        fetchData()
    }
    
    // MARK: - Fetch Expenses and Incomes
    private func fetchData() {
        var allEntries: [(String, Any)] = [] // Holds both expenses and incomes
        
        // Fetch expenses
        if let fetchedExpenses = CoreDataManager.shared.fetchAllExpenses() {
            for expense in fetchedExpenses {
                allEntries.append(("expense", expense))
            }
        }
        
        // Fetch incomes
        if let fetchedIncomes = CoreDataManager.shared.fetchAllIncomes() {
            for income in fetchedIncomes {
                allEntries.append(("income", income))
            }
        }
        
        // Group data by date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMMM-yyyy" // Format as "07-March-2025"
        
        let groupedData = Dictionary(grouping: allEntries) { entry -> String in
            if let expense = entry.1 as? Expense {
                return dateFormatter.string(from: expense.expenseDate ?? Date())
            } else if let income = entry.1 as? Income {
                return dateFormatter.string(from: income.incomeDate ?? Date())
            }
            return ""
        }
        
        dataByDate = groupedData.map { (date, entries) in
            return (date, entries)
        }.sorted { $0.date > $1.date } // Sort the dates in descending order
        
        tableView.reloadData()
    }
    
    private func setupFilter(){
        view.addSubview(filterButton)
        
        NSLayoutConstraint.activate([
        filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            filterButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            filterButton.heightAnchor.constraint(equalToConstant: 40),
            filterButton.widthAnchor.constraint(equalToConstant: 40),
        ])
    }
    private func setupTableView() {
        tableView.register(DashboardExpenseListTableView.self, forCellReuseIdentifier: "DashboardExpenseListTableView")
        tableView.register(DashboardIncomeListTableview.self, forCellReuseIdentifier: "DashboardIncomeListTableview")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
       
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -55),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
    }
    
    private func setupBottomSheet() {
        
        // Bottom sheet container
        bottomSheetContainer.backgroundColor = .white
        bottomSheetContainer.layer.cornerRadius = 16
        bottomSheetContainer.clipsToBounds = true
        bottomSheetContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomSheetContainer)
        
        let height: CGFloat = 350
        NSLayoutConstraint.activate([
            bottomSheetContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSheetContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomSheetContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
            bottomSheetContainer.heightAnchor.constraint(equalToConstant: height)
        ])
        
        // Start off-screen
        bottomSheetContainer.transform = CGAffineTransform(translationX: 0, y: height)
        
        setupBottomSheetContent()
    }
    private func setupBottomSheetContent() {
        let title = makeTitleLabel("Filter Transaction")
        let resetBtn = makeResetButton()

        let filterTitle = makeSectionTitle("Filter By")
        configureStackView(filterStack, with: filterOptions, action: #selector(filterTapped(_:)))

        let sortTitle = makeSectionTitle("Sort By")
        configureStackView(sortStack, with: sortOptions, action: #selector(sortTapped(_:)))

        let applyButton = makeApplyButton()

        let mainStack = UIStackView(arrangedSubviews: [
            title,
            resetBtn,
            filterTitle,
            filterStack,
            sortTitle,
            sortStack,
            applyButton
        ])
        
        mainStack.axis = .vertical
        mainStack.spacing = 16
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        bottomSheetContainer.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: bottomSheetContainer.topAnchor, constant: 20),
            mainStack.leadingAnchor.constraint(equalTo: bottomSheetContainer.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: bottomSheetContainer.trailingAnchor, constant: -20),
            mainStack.bottomAnchor.constraint(lessThanOrEqualTo: bottomSheetContainer.bottomAnchor, constant: -20)
        ])
    }
    @objc func dismissBottomSheet() {
        UIView.animate(withDuration: 0.5, animations: {
            self.bottomSheetContainer.frame.origin.y = self.view.frame.height
        })
    }

        
        @objc private func filterTapped(_ sender: UIButton) {
            select(button: sender, in: filterStack)
            selectedFilter = sender.titleLabel?.text
        }
        
        @objc private func sortTapped(_ sender: UIButton) {
            select(button: sender, in: sortStack)
            selectedSort = sender.titleLabel?.text
        }
        
        private func select(button: UIButton, in stack: UIStackView) {
            for case let btn as UIButton in stack.arrangedSubviews {
                btn.backgroundColor = .white
                btn.setTitleColor(.black, for: .normal)
            }
            button.backgroundColor = UIColor.systemPurple.withAlphaComponent(0.2)
            button.setTitleColor(.systemPurple, for: .normal)
        }
        
        private func configureStackView(_ stack: UIStackView, with items: [String], action: Selector) {
            stack.axis = .horizontal
            stack.spacing = 8
            stack.distribution = .fillEqually
            for item in items {
                let btn = UIButton(type: .system)
                btn.setTitle(item, for: .normal)
                btn.layer.borderColor = UIColor.lightGray.cgColor
                btn.layer.borderWidth = 1
                btn.layer.cornerRadius = 8
                btn.addTarget(self, action: action, for: .touchUpInside)
                stack.addArrangedSubview(btn)
            }
        }
        
        private func makeTitleLabel(_ text: String) -> UILabel {
            let lbl = UILabel()
            lbl.text = text
            lbl.font = UIFont.boldSystemFont(ofSize: 18)
            return lbl
        }
        
        private func makeSectionTitle(_ text: String) -> UILabel {
            let lbl = UILabel()
            lbl.text = text
            lbl.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            return lbl
        }
        
        private func makeResetButton() -> UIButton {
            let btn = UIButton(type: .system)
            btn.setTitle("Reset", for: .normal)
            btn.setTitleColor(.systemPurple, for: .normal)
            btn.contentHorizontalAlignment = .right
            btn.addTarget(self, action: #selector(resetTapped), for: .touchUpInside)
            return btn
        }
        
        @objc private func resetTapped() {
            for case let btn as UIButton in filterStack.arrangedSubviews {
                btn.backgroundColor = .white
                btn.setTitleColor(.black, for: .normal)
            }
            for case let btn as UIButton in sortStack.arrangedSubviews {
                btn.backgroundColor = .white
                btn.setTitleColor(.black, for: .normal)
            }
            selectedFilter = nil
            selectedSort = nil
        }

        private func makeApplyButton() -> UIButton {
            let btn = UIButton(type: .system)
            btn.setTitle("Apply", for: .normal)
            btn.backgroundColor = .systemPurple
            btn.setTitleColor(.white, for: .normal)
            btn.layer.cornerRadius = 12
            btn.heightAnchor.constraint(equalToConstant: 50).isActive = true
            btn.addTarget(self, action: #selector(applyTapped), for: .touchUpInside)
            return btn
        }
        
        @objc private func applyTapped() {
            // You can pass filter + sort back via delegate or closure
            dismiss(animated: true, completion: nil)
        }
    @objc func openFilterBottomSheet() {
        setupBottomSheet()
        
        UIView.animate(withDuration: 0.3) {
            self.bottomSheetContainer.transform = .identity
        }
    }
    
    }


extension BudgetHistoryController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataByDate.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataByDate[section].entries.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataByDate[section].date
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entry = dataByDate[indexPath.section].entries[indexPath.row]
        
        if entry.type == "expense", let expense = entry.data as? Expense {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardExpenseListTableView", for: indexPath) as! DashboardExpenseListTableView
            cell.configureExpense(with: expense) // Configure cell with expense
            return cell
        } else if entry.type == "income", let income = entry.data as? Income {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardIncomeListTableview", for: indexPath) as! DashboardIncomeListTableview
            cell.configure(with: income) // Configure cell with income
            return cell
        }
        return UITableViewCell() // Return a default cell if none match
    }
}
