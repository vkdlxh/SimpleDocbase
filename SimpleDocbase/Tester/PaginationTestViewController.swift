//
//  PaginationTestViewController.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/11/18.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import UIKit
import SVProgressHUD

class PaginationTestViewController: UIViewController {
    
    let domain = UserDefaults.standard.object(forKey: "selectedDomain") as! String
    var memos = [Memo]()
    
    //Pagination
    var isDataLoading:Bool=false
    var pageNum: Int = 1

    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SVProgressHUD.show()
        ACAMemoRequest.init().memoPagination(domain: domain, pageNum: pageNum) { memos in
            if let memos = memos {
                self.memos = memos
            }
            self.pageNum += 1
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                self.tableView.reloadData()
            }
        }
    }

}

extension PaginationTestViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowConut = memos.count
        return rowConut
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TestCell", for: indexPath)
        let setting = memos[indexPath.row].title
        cell.textLabel?.text = setting
        return cell
    }
    
}


extension PaginationTestViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging")
        isDataLoading = false
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollViewDidEndDragging")
        if scrollView == tableView {
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
                if !isDataLoading{
                    SVProgressHUD.show()
                    isDataLoading = true
                    ACAMemoRequest.init().memoPagination(domain: domain, pageNum: pageNum) { memos in
                        if let memos = memos {
                            self.memos += memos
                        }
                        self.pageNum += 1
                        DispatchQueue.main.async {
                            SVProgressHUD.dismiss()
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }

}
