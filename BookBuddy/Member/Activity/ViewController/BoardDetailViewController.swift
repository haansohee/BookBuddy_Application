//
//  BoardDetailViewController.swift
//  BookBuddy
//
//  Created by 한소희 on 12/21/23.
//

import Foundation
import UIKit

final class BoardDetailViewController: UIViewController {
    private let boardDetailView = BoardDetailView()
    private let viewModel = BoardDetailVieWModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBoardDetailView()
        setLayoutConstraintsBoardDetailView()
        setBoard()
    }
    
    init(boardWrittenInformation: BoardWrittenInformation) {
        viewModel.setBoardWrittenInformation(boardWrittenInformation)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BoardDetailViewController {
    private func configureBoardDetailView() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(boardDetailView)
        boardDetailView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setLayoutConstraintsBoardDetailView() {
        NSLayoutConstraint.activate([
            boardDetailView.topAnchor.constraint(equalTo: self.view.topAnchor),
            boardDetailView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            boardDetailView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            boardDetailView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    private func setBoard() {
        guard let information = viewModel.boardWrittenInformation else { return }
        self.title = information.nickname
        boardDetailView.setLabel(information)
    }
}
