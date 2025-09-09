//
//  ContextViewControler.swift
//  ToDoList
//
//  Created by Алексей on 07.09.2025.
//

import UIKit
import SnapKit

//MARK: - ContextViewControler
final class ContextViewController: UIViewController {
    
    //MARK: - Views
    private var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .white
        return titleLabel
    }()
    
    private var todoLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = .systemFont(ofSize: 12, weight: .regular)
        descLabel.textColor = .white
        descLabel.numberOfLines = 0
        return descLabel
    }()
    
    private var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.font = .systemFont(ofSize: 12, weight: .regular)
        dateLabel.textColor = .white
        dateLabel.layer.opacity = 0.5
        return dateLabel
    }()
    
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 6
        return stack
    }()
    
    //MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        setConstraints()
        setupView()
    }
    
    //MARK: - Setting 
    func configureCell(with todo: Todo?) {
        titleLabel.text = todo?.title
        todoLabel.text = todo?.todo
        dateLabel.text = todo?.date?.convertDateToString()
    }
    
    private func setupView() {
        view.backgroundColor = BaseColor.hex_272729
        let targetSize = CGSize(width: view.bounds.width, height: UIView.layoutFittingCompressedSize.height)
        let fittingHeight = view.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel).height
        preferredContentSize = CGSize(width: 0, height: fittingHeight)
    }
    
    private func addSubViews() {
        view.addSubview(stack)
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(todoLabel)
        stack.addArrangedSubview(dateLabel)
    }
    
    // MARK: - Constraints
    private func setConstraints() {
        stack.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(12)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
}
