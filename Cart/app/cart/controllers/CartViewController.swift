//
//  CartViewController.swift
//  Cart
//
//  Created by Victor Noel Barrera on 7/3/22.
//

import UIKit
import SnapKit

class CartViewController: UIViewController {
    
    private struct Constant {
        static let totalHeight = CGFloat(48)
    }
    
    private let viewModel : CartViewModel
    
    private let loadingView = LoadingView()
    private let totalView = CartTotalView()
    private let tableView : UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.estimatedRowHeight = 48
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: "ProductTableViewCell")
        return tableView
    }()
    
    init(viewModel: CartViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    //MARK: Configuration
    private func configure() {
        configureUI()
        
        viewModel.didUpdateState = { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .loading:
                self.tableView.isHidden = true
                self.totalView.isHidden = true
                self.loadingView.isHidden = false
            case .products:
                self.loadingView.isHidden = true
                self.tableView.isHidden = false
                self.totalView.isHidden = false
                self.tableView.reloadData()
            case .error:
                // display error UI with possible retry button
                break
            }
        }
        
        viewModel.didUpdateTotal = { [weak self] in
            guard let self = self else { return }
            self.totalView.viewModel = self.viewModel.totalViewModel()
        }
        
        viewModel.fetch()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        tableView.dataSource = self
        
        [
            loadingView,
            totalView,
            tableView
        ].forEach({
            $0.isHidden = true
            view.addSubview($0)
        })
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(totalView.snp.top)
        }
        
        totalView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.height.equalTo(Constant.totalHeight)
        }
        
        loadingView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
    }
}

//MARK: - UITableViewDataSource
extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.reuseIdentifier, for: indexPath)
        
        if let produceCell = cell as? ProductTableViewCell {
            let index = indexPath.row
            produceCell.didUpdateCount = { [weak self] count in
                guard let self = self else { return }
                self.viewModel.update(count: count, index: index)
            }
            produceCell.viewModel = viewModel.productViewModel(index: indexPath.row)
        }
        
        return cell
    }
}
