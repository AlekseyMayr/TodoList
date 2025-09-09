//
//  MainFooterView.swift
//  ToDoList
//
//  Created by Алексей on 04.09.2025.
//

import UIKit
import SnapKit

//MARK: - FooterView
final class FooterView: UIView {
    var buttonClosure: (() -> Void)?
    var todoCount: Int?
    
    //MARK: - Views
    private let backView: UIView = {
        let backView = UIView()
        backView.backgroundColor = BaseColor.hex_272729
        return backView
    }()
    
    private let footerLabel: UILabel = {
        let footerLabel = UILabel()
        footerLabel.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        footerLabel.textColor = BaseColor.hex_F4F4F4
        return footerLabel
    }()
    
    private lazy var addTodoButton: UIButton = {
        let addTodoButton = UIButton()
        addTodoButton.addTarget(self, action: #selector(addTodoButtonClick), for: .touchUpInside)
        addTodoButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        addTodoButton.tintColor = BaseColor.hex_FED702
        addTodoButton.imageView?.contentMode = .scaleAspectFit
        addTodoButton.contentHorizontalAlignment = .fill
        addTodoButton.contentVerticalAlignment = .fill
        return addTodoButton
    }()
    
    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setting FooterView
    private func addSubViews() {
        addSubview(backView)
        backView.addSubview(footerLabel)
        backView.addSubview(addTodoButton)
    }
    
    func configureFooter() {
        footerLabel.text = "\(todoCount ?? 0) Задач"
    }
    
    @objc private func addTodoButtonClick() {
        buttonClosure?()
    }
    
    //MARK: - Constraints
    private func setConstraints() {
        backView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(83)
        }
        
        footerLabel.snp.makeConstraints { make in
            make.centerX.equalTo(backView.snp.centerX)
            make.top.equalToSuperview().offset(20.5)
        }
        
        addTodoButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(13)
            make.trailing.equalToSuperview().inset(20)
            make.trailing.equalToSuperview()
            make.size.equalTo(28)
        }
    }
}
