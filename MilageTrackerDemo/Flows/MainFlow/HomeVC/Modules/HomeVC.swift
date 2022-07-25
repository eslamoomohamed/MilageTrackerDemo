//
//  HomeVC.swift
//  MilageTrackerDemo
//
//  Created by eslam mohamed on 16/07/2022.
//

import UIKit

class HomeVC: UIViewController,StoryboardLoad {
    
    weak var coordinator: HomeVCCoordinator?
    var pushVC: ((String,Bool,TripCellViewModel?) -> Void)?
    var viewModel: IHomeViewModel?
    @IBOutlet weak var tripsTableView: UITableView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        confiureTripsTableView()
        configureViewModel()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel?.fetchTripsFromCoreData()
    }
    
    private func configureView(){
        view.backgroundColor = .white
    }
    
    private func confiureTripsTableView(){
        self.tripsTableView.backgroundColor = .white
        self.tripsTableView.delegate = self
        self.tripsTableView.dataSource = self
    }
    
    private func configureViewModel(){
        viewModel = HomeViewModel()
    }
    
    private func bindViewModel(){
        updateViewWithData()
    }
    
    private func updateViewWithData(){
        viewModel?.updateTableViewClosure = { DispatchQueue.main.async { self.tripsTableView.reloadData() } }
    }
    


    @IBAction func pushMap(_ sender: Any) {
        pushVC?("MapVC",false,nil)
    }
    
}


extension HomeVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellVM = viewModel?.getTripCellViewModel(at: indexPath)
        pushVC?("MapVC",true,cellVM)
    }
    
}

extension HomeVC: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getNumberOfCells() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath) as UITableViewCell
        let cellVM = viewModel?.getTripCellViewModel(at: indexPath)
        let title = cellVM?.tripName ?? "trip"
        cell.textLabel?.text = "\(title) \(indexPath.row)"
        return cell
    }
    
    
}
