//
//  ViewController.swift
//  SelectAndMutiSelectSwift
//
//  Created by offcn_c on 16/6/28.
//  Copyright © 2016年 offcn_c. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var listTableView: UITableView!
    var dataArray:NSMutableArray!
    let cellIdentifier = "cellIdentifier";
    var delteteIndexPaths:NSMutableArray!
    var selectArray:NSMutableArray!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUIAndData()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func initUIAndData(){
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        dataArray = NSMutableArray.init(capacity: 0)
        selectArray = NSMutableArray.init(capacity: 0)
        delteteIndexPaths = NSMutableArray.init(capacity: 0)
        
        listTableView = UITableView.init(frame: self.view.frame, style: .Plain);
        listTableView?.delegate = self;
        listTableView?.dataSource = self;
        listTableView.allowsMultipleSelectionDuringEditing = true;
        self.view.addSubview(listTableView!)
        
        for i in 0...10 {
            dataArray.addObject("row:\(i)")
        }
        
        let deleteButton = UIButton.init(type: .Custom)
        deleteButton.frame = CGRectMake(0, CGRectGetMaxY(self.view.frame) - 40, self.view.frame.width, 40)
        deleteButton .setTitle("删除", forState: .Normal);
        deleteButton.backgroundColor = UIColor.orangeColor();
        deleteButton .addTarget(self, action: #selector(ViewController.deleteButtonClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(deleteButton)
        
    }
    
    func deleteButtonClick(sender:UIButton) {
        dataArray .removeObjectsInArray(selectArray as [AnyObject])
        listTableView .deleteRowsAtIndexPaths(delteteIndexPaths as AnyObject as! [NSIndexPath], withRowAnimation: .Fade)
        delteteIndexPaths .removeAllObjects()
        selectArray.removeAllObjects()
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated);
        
        if listTableView.editing {
            self.editButtonItem().title = "Edit";
            listTableView.setEditing(false, animated: true)
        } else {
            self.editButtonItem().title = "Done";
            listTableView .setEditing(true, animated: animated)
        }
    }
    
    func cellForTableView(tableView: UITableView) -> UITableViewCell {
        let cellIdentifier = "Cell"
        if let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier){
            return cell
        } else {
            return UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController:UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray!.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = cellForTableView(tableView);
        cell.textLabel?.text = dataArray[indexPath.row] as? String;
        return cell;
    }
    

}

extension ViewController:UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath);
        if tableView.editing {
            if cell?.subviews.count > 3 {
                if let _ = cell?.subviews[3].subviews[0]{
                    let imageView:UIImageView = cell!.subviews[3].subviews[0] as! UIImageView
                    imageView.image = UIImage(named:"xz");
                    
                }
            }else {
                if let _ = cell?.subviews[2].subviews[0]{
                    let imageView:UIImageView = cell!.subviews[2].subviews[0] as! UIImageView
                    imageView.image = UIImage(named:"xz");
                    
                }
            }
        }
       
        selectArray.addObject(dataArray![indexPath.row])
        delteteIndexPaths.addObject(indexPath)
        
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        if selectArray.containsObject(dataArray[indexPath.row]) {
            selectArray.removeObject(dataArray[indexPath.row])
            delteteIndexPaths.removeObject(indexPath)
        }
    }

    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
    
        let likeAction = UITableViewRowAction(style: .Normal, title: "喜欢", handler:{ action, indexPath in
            
            print("点击了喜欢按钮");
            tableView.editing = false

        
        })
        
        let deleteAction = UITableViewRowAction(style: .Default, title: "删除", handler: { action, indexPath in
                self.dataArray.removeObjectAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        
        
        })
        return [likeAction,deleteAction]
        
        
    }

}
