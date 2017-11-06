//
//  MemoListViewController.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/11/01.
//  Copyright © 2017年 jeon sangjun. All rights reserved.
//

import UIKit

class MemoListTableViewCell: UITableViewCell {
    
    // MARK: IBOutlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
}

class MemoListViewController: UIViewController {
    
    // MARK: Properties
    let request: Request = Request()
    var groupName: String = ""
    let domain = UserDefaults.standard.object(forKey: "selectedDomain") as? String
    
    var memos = [Memo]()
    
    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        request.delegate = self
        if let domain = domain {
            request.MemoList(domain: domain, group: groupName)
        }
        
        navigationItem.title = groupName
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addTapped(sender:)))
    }
    
    @objc func addTapped(sender: UIBarButtonItem) {
        performSegue(withIdentifier: "WriteMemoSegue", sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "WriteMemoSegue" {
            if let destination = segue.destination as? WriteMemoViewController {
                
            }
        } else if segue.identifier == "DetailMemoSegue" {
            if let destination = segue.destination as? DetailMemoViewController {
                if let selectedIndex = self.tableView.indexPathForSelectedRow?.row {
                    destination.memos.append(memos[selectedIndex])
                }
            }
        }
    }
}


extension MemoListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return memos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MemoListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MemoCell", for: indexPath) as! MemoListTableViewCell
        
        let memo = memos[indexPath.row]
        
        cell.titleLabel.text = memo.title
        let imageURL = URL(string: memo.user.profile_image_url)
        let imageURLData = try? Data(contentsOf: imageURL!)
        cell.profileImageView.image = UIImage(data: imageURLData!)
        
        return cell
    }
    
}


extension MemoListViewController: RequestDelegate {

    func getMemoList(memos: Array<Any>) {
        if let paramMemo = memos as? [Memo] {
            self.memos = paramMemo
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }

    }
}

