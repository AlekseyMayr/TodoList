//
//  ViewController.swift
//  ToDoList
//
//  Created by Алексей on 03.09.2025.
//

import UIKit
import SnapKit
import CoreData

//MARK: - MainViewController
final class MainViewController: UIViewController {
    var presenter: MainPresenterProtocol?
    private var fetchedResultsController: NSFetchedResultsController<Todo>?
    private var selectedIndex: IndexPath?
    
    //MARK: - Views
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
   private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: BaseColor.hex_F4F4F4_05])
        definesPresentationContext = true
        let micImage = UIImage(systemName: "mic.fill")?.withTintColor(BaseColor.hex_F4F4F4_05, renderingMode: .alwaysOriginal)
        searchController.searchBar.setImage(micImage, for: .bookmark, state: .normal)
        searchController.searchBar.showsBookmarkButton = true
        searchController.searchBar.searchTextField.leftView?.tintColor = BaseColor.hex_F4F4F4_05
        searchController.searchBar.searchTextField.backgroundColor = BaseColor.hex_272729
        if let clearButton = searchController.searchBar.searchTextField.value(forKey: "clearButton") as? UIButton {
            clearButton.setImage(UIImage(systemName: "xmark.circle.fill")?.withTintColor(BaseColor.hex_F4F4F4_05, renderingMode: .alwaysOriginal), for: .normal)
        }
        return searchController
    }()
    
    private lazy var contextMenu: UIMenu = {
        let edit = UIAction(title: "Редактировать", image: UIImage(named: "edit")) { [weak self] _ in
            guard let index = self?.selectedIndex else { return }
            let todo = self?.fetchedResultsController?.object(at: index)
            self?.presenter?.showDetailScreen(data: todo, count: self?.fetchedResultsController?.sections?[0].objects?.count)
        }
        let share = UIAction(title: "Поделиться", image: UIImage(named: "export")) { _ in }
        let delete = UIAction(title: "Удалить", image: UIImage(named: "trash"), attributes: .destructive) { [weak self] _ in
            guard let index = self?.selectedIndex else { return }
            let todo = self?.fetchedResultsController?.object(at: index)
            self?.presenter?.deleteTodo(todo: todo) { result in
                switch result {
                case .success(()):
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("Unresolved error \(error.localizedDescription)")
                }
            }
        }
        let imageMenu = UIMenu(children: [edit, share, delete])
        return imageMenu
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .black
        tableView.register(MainCell.self, forCellReuseIdentifier: "MainCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = BaseColor.hex_F4F4F4_05
        tableView.separatorInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        tableView.tableHeaderView = UIView()
        return tableView
    }()
    
    private lazy var footerView: FooterView = {
        let footerView = FooterView()
        footerView.configureFooter()
        return footerView
    }()
    
    private lazy var customHeaderView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 360, height: 56)
        let label = UILabel()
        label.text = "Задачи"
        label.frame = CGRect(x: 0, y: -5, width: 123, height: 41)
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = BaseColor.hex_F4F4F4
        view.addSubview(label)
        return view
    }()
    
    //MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter?.viewDidLoaded()
    }
    
    // MARK: - Setting
    private func configureBackButton() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Назад")
        navigationItem.backBarButtonItem?.tintColor = BaseColor.hex_FED702
    }
    
    private func setupView() {
        presenter?.createFrc(searchText: nil) { [weak self] result in
            switch result {
            case .success(let frc):
                self?.fetchedResultsController = frc
                self?.fetchedResultsController?.delegate = self
                self?.tableView.reloadData()
            case .failure(let error):
                print("Unresolved error \(error.localizedDescription)")
            }
        }
        configureBackButton()
        navigationItem.searchController = searchController
        addSubViews()
        setConstraints()
    }
    
    private func addSubViews() {
        view.addSubview(backView)
        backView.addSubview(tableView)
        backView.addSubview(footerView)
    }
    
    // MARK: - Constraints
    private func setConstraints() {
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(footerView.snp.top)
        }
        
        footerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(83)
        }
    }
}

// MARK: - UITableView Delegates, UITableView DataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath) as? MainCell else { return UITableViewCell() }
        let id = Int(fetchedResultsController?.fetchedObjects?.last?.id ?? 0)
        footerView.todoCount = fetchedResultsController?.fetchedObjects?.count
        footerView.buttonClosure = { [weak self] in
            self?.presenter?.showDetailScreen(data: nil, count: id)
        }
        footerView.configureFooter()
        let todo = fetchedResultsController?.object(at: indexPath)
        cell.configureCell(with: todo)
        cell.completedClosure = { [weak self] bool in
            self?.presenter?.updateCompleted(todo: todo, newCompleted: bool) { result in
                switch result {
                case .success(()):
                    print("Изменения сохранены")
                case .failure(let error):
                    print("Unresolved error \(error.localizedDescription)")
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.showDetailScreen(data: fetchedResultsController?.object(at: indexPath), count: fetchedResultsController?.fetchedObjects?.count)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter?.deleteTodo(todo: fetchedResultsController?.object(at: indexPath)) { result in
                switch result {
                case .success(()):
                    tableView.reloadData()
                case .failure(let error):
                    print("Unresolved error \(error.localizedDescription)")
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        selectedIndex = indexPath
        return UIContextMenuConfiguration { [weak self] in
            let menu = ContextViewController()
            menu.configureCell(with: self?.fetchedResultsController?.object(at: indexPath))
            return menu
        } actionProvider: { [weak self] _ in
            return self?.contextMenu
        }
    }
}

//MARK: - UIScrollViewDelegate
extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position >= -100 {
            navigationItem.titleView = nil
            navigationItem.title = "Задачи"
        } else {
            navigationItem.titleView = customHeaderView
            navigationItem.title = nil
        }
    }
}

//MARK: - NSFetchedResultsControllerDelegate
extension MainViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        case .move:
            if let indexPath = indexPath, let newIndexPath = newIndexPath {
                tableView.moveRow(at: indexPath, to: newIndexPath)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        default:
            break
        }
    }
        
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        tableView.endUpdates()
        footerView.todoCount = fetchedResultsController?.fetchedObjects?.count
        footerView.configureFooter()
    }
}

//MARK: - UISearchResultsUpdating
extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        presenter?.setSearching(isActive: searchController.isActive)
        filterContentForSearchText(searchController.searchBar.text ?? "")
    }
    
    func filterContentForSearchText(_ searchText: String) {
        presenter?.createFrc(searchText: searchText) { [weak self] result in
            switch result {
            case .success(let frc):
                self?.fetchedResultsController = frc
                self?.fetchedResultsController?.delegate = self
                self?.tableView.reloadData()
            case .failure(let error):
                print("Unresolved error \(error.localizedDescription)")
            }
        }
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.searchTextField.textColor = BaseColor.hex_F4F4F4
    }
}
