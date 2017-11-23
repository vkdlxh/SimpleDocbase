//
//  MemoListViewController.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/11/01.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import UIKit
import SVProgressHUD

class MemoListViewController: UIViewController {
    
    // MARK: Properties
    var groupName: String = ""
    let domain = UserDefaults.standard.object(forKey: "selectedTeam") as? String
    var memos = [Memo]()
    var refreshControl: UIRefreshControl!
    //Pagination
    var isDataLoading:Bool = false
    var pageNum: Int = 1
    let perPage: Int = 20

    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = groupName
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addTapped(sender:)))
        refreshControlAction()
        
        SVProgressHUD.show(withStatus: "更新中")
        if let domain = domain {
            ACAMemoRequest().getMemoList(domain: domain, group: groupName, pageNum: pageNum, perPage: perPage) { memos in
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
    
    // MARK: Internal Methods
    @objc func addTapped(sender: UIBarButtonItem) {
        performSegue(withIdentifier: "GoWriteMemoSegue", sender: self)
    }
    
    func refreshControlAction() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "引っ張って更新")
        self.refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.tableView.addSubview(refreshControl)
    }
    
    @objc func refresh() {
        pageNum = 1
        if let domain = domain {
            ACAMemoRequest().getMemoList(domain: domain, group: groupName, pageNum: pageNum, perPage: perPage) { memos in
                if let memos = memos {
                    self.memos = memos
                }
            }
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoDetailMemoSegue" {
            if let destination = segue.destination as? DetailMemoAndCommentViewController {
                if let selectedIndex = self.tableView.indexPathForSelectedRow?.row {
                    destination.memo = memos[selectedIndex]
                }
            }
        } else if segue.identifier == "GoWriteMemoSegue" {
            if let destination = segue.destination as? UINavigationController {
                if let tagetController = destination.topViewController as? WriteMemoViewController {
                    tagetController.delegate = self
                }
            }
        }
    }
}


// MARK: Extensions
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
        cell.bodyLabel.text = memo.body

        var tags: [String] = []
        for i in 0..<memo.tags.count{
           tags.append(memo.tags[i].name)
        }
        cell.tagLabel.text = tags.joined(separator: ", ")
        
        let imageURL = URL(string: memo.user.profile_image_url)
        let imageURLData = try? Data(contentsOf: imageURL!)
        cell.profileImageView.image = UIImage(data: imageURLData!)
        
        return cell
    }
    
}


extension MemoListViewController: WriteMemoViewControllerDelegate {
    
    func writeMemoViewSubmit() {

        dismiss(animated: true, completion: nil)
            
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }

    }
}

extension MemoListViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging")
        isDataLoading = false
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollViewDidEndDragging")
        if scrollView == tableView {
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
                if !isDataLoading{
                    SVProgressHUD.show(withStatus: "更新中")
                    isDataLoading = true
                    if let domain = domain {
                        ACAMemoRequest().getMemoList(domain: domain, group: groupName, pageNum: pageNum, perPage: perPage) { memos in
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
    
}

