//
//  MainViewCell.swift
//  ToDoList
//
//  Created by Алексей on 04.09.2025.
//

import UIKit
import SnapKit

//MARK: - MainCell
final class MainCell: UITableViewCell {
    private var isCompletedButtonClick = false
    var completedClosure: ((Bool) -> Void)?

    //MARK: - Views
    private let backView: UIView = {
        let backView = UIView()
        backView.backgroundColor = .black
        return backView
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return titleLabel
    }()
    
    private let todoLabel: UILabel = {
        let todoLabel = UILabel()
        todoLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        todoLabel.numberOfLines = 2
        return todoLabel
    }()
    
    private let dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        dateLabel.textColor = BaseColor.hex_F4F4F4_05
        return dateLabel
    }()
    
    private lazy var completedButton: UIButton = {
        let completedButton = UIButton()
        completedButton.addTarget(self, action: #selector(completedButtonClick), for: .touchUpInside)
        completedButton.layer.borderWidth = 1
        completedButton.imageView?.contentMode = .scaleAspectFit
        completedButton.contentHorizontalAlignment = .fill
        completedButton.contentVerticalAlignment = .fill
        return completedButton
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 6
        return stackView
    }()
    
    //MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setting Cell
    func configureCell(with todo: Todo?) {
        titleLabel.text = todo?.title
        todoLabel.text = todo?.todo
        dateLabel.text = todo?.date?.convertDateToString()
        isCompletedButtonClick = todo?.completed ?? false
        configureButton()
    }
    
    private func addSubViews() {
        contentView.addSubview(backView)
        backView.addSubview(completedButton)
        backView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(todoLabel)
        stackView.addArrangedSubview(dateLabel)
    }
    
    //MARK: - Constraints
    private func setConstraints() {
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        completedButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(20)
            make.size.equalTo(24)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(12)
            make.leading.equalTo(completedButton.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(20)
        }
    }
    
    //MARK: - Setting Button
    private func configureButton() {
        completedButton.setImage(isCompletedButtonClick ? UIImage(systemName: "checkmark.circle") : UIImage(systemName: "circle"), for: .normal)
        completedButton.tintColor = isCompletedButtonClick ? BaseColor.hex_FED702 : BaseColor.hex_4D555E
        titleLabel.textColor = isCompletedButtonClick ? BaseColor.hex_F4F4F4_05 : BaseColor.hex_F4F4F4
        todoLabel.textColor = isCompletedButtonClick ? BaseColor.hex_F4F4F4_05 : BaseColor.hex_F4F4F4
        
        guard let text = titleLabel.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        let range = (text as NSString).range(of: text)
        if isCompletedButtonClick {
            attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: range)
        } else {
            attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: range)
        }
        titleLabel.attributedText = attributedString
    }
    
    @objc private func completedButtonClick() {
        isCompletedButtonClick.toggle()
        configureButton()
        completedClosure?(isCompletedButtonClick)
    }
}
