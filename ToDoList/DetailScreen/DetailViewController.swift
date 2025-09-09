//
//  DetailViewController.swift
//  ToDoList
//
//  Created by Алексей on 05.09.2025.
//

import UIKit
import SnapKit

//MARK: - DetailViewControllerProtocol
protocol DetailViewControllerProtocol: AnyObject {
    func configureDetail(with todo: Todo?)
}

//MARK: - DetailViewController
final class DetailViewController: UIViewController, DetailViewControllerProtocol {
    var presenter: DetailPresenterProtocol?
    
    //MARK: - Views
    private let backView: UIView = {
        let backView = UIView()
        backView.backgroundColor = .black
        return backView
    }()
    
    private let titleTextView: UITextView = {
        let titleTextView = UITextView()
        titleTextView.font = .systemFont(ofSize: 34, weight: .bold)
        titleTextView.textColor = BaseColor.hex_F4F4F4
        titleTextView.backgroundColor = .black
        return titleTextView
    }()
    
    private let dateLabel: UILabel = {
        let dateLabel = UILabel()
        let date = Date()
        dateLabel.text = date.convertDateToString()
        dateLabel.textColor = BaseColor.hex_F4F4F4_05
        dateLabel.font = .systemFont(ofSize: 12, weight: .regular)
        return dateLabel
    }()
    
    private let todoTextView: UITextView = {
        let descriptionTextView = UITextView()
        descriptionTextView.font = .systemFont(ofSize: 16, weight: .regular)
        descriptionTextView.textColor = BaseColor.hex_F4F4F4
        descriptionTextView.backgroundColor = .black
        return descriptionTextView
    }()
    
    //MARK: - DetailViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        setConstraints()
        presenter?.viewDidLoaded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter?.saveData(titleTextView: titleTextView.text, todoTextView: todoTextView.text)
    }
    
    //MARK: - Setting
     func configureDetail(with todo: Todo?) {
        if let todo {
            titleTextView.text = todo.title
            dateLabel.text = todo.date?.convertDateToString()
            todoTextView.text = todo.todo
        }
    }
    
    private func addSubViews() {
        view.addSubview(backView)
        backView.addSubview(titleTextView)
        backView.addSubview(dateLabel)
        backView.addSubview(todoTextView)
    }
    
    //MARK: - Constraints
    private func setConstraints() {
        backView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        titleTextView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleTextView.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(20)
        }
        
        todoTextView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.greaterThanOrEqualTo(backView.snp.height)
        }
    }
}
