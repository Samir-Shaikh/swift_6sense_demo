//
//  ViewController.swift
//  Swift_6sense_demo
//
//  Created by Sam on 16/03/21.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Variables
    var arrData = [DataModel]()
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialConfig()
    }
    
    //MARK: Private Methods
    private func initialConfig(){
        
        //add data
        if RealMHelper.shared.getDataFromDB().count == 0{
            
            RealMHelper.shared.addDataIntoDB()
        }
        
        //get data
        self.arrData = RealMHelper.shared.getDataFromDB()
       
        //register
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

extension ViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = arrData[indexPath.row]
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        cell.selectionStyle = .none
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.textAlignment = .right
        cell.textLabel?.text = model.textStr
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = arrData[indexPath.row]
        self.view.makeToast("Surah: \(model.surahNo) Ayah: \(model.ayahNo)")
    }
}


