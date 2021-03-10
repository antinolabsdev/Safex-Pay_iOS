//
//  EmiCellTable.swift
//  Safex-Pay
//
//  Created by Sandeep on 31/10/20.
//

import UIKit

protocol EmiCellTableProtocol {
    func reloadMainTable()
    func sendEppInstalmentMonths(months: String,amount: String)
}


class EmiCellTable: UITableViewCell {
    @IBOutlet weak var tableView: UITableView!
    var lastOpenedSection:Int?
    var delegate: EmiCellTableProtocol?
    var eppData = [Epp]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTableView()
    }
    
    func setupTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "EmiCell", bundle: safexBundle), forCellReuseIdentifier: "EmiCell")
        self.tableView.register(UINib(nibName: "EmiHeaderCell", bundle: safexBundle), forCellReuseIdentifier: "EmiHeaderCell")
    }
}

extension EmiCellTable: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.eppData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == lastOpenedSection{
            return 2
        }else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmiHeaderCell") as! EmiHeaderCell
            let data = eppData[indexPath.section]
            if indexPath.section == self.lastOpenedSection{
                cell.setSelectionImg(isExpanded: true)
            }else{
                cell.setSelectionImg(isExpanded: false)
            }
            cell.setdata(amount: data.monthlyEmi ?? "", numOfMonths: data.months ?? "", ROI: data.roi ?? "", img: "")
            cell.tag = indexPath.section
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmiCell") as! EmiCell
            let data = eppData[indexPath.section]
            cell.setData(data: data)
            cell.selectionStyle = .none
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 44
        }else{
            return 122
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if let months = eppData[indexPath.section].months, let amount = eppData[indexPath.section].monthlyEmi{
                self.delegate?.sendEppInstalmentMonths(months: months,amount: amount)
            }
            self.lastOpenedSection = indexPath.section
            self.delegate?.reloadMainTable()
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: indexPath.section), at: .top, animated: true)
            self.tableView.reloadData()
        }
    }
}
