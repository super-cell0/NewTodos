//
//  TodosTableViewController.swift
//  Todos
//
//  Created by 贝蒂小熊 on 2022/3/6.
//

import UIKit

//persent/ dismiss
//push/ pop

class TodosTableViewController: UITableViewController {

    var todos: [Todo] = [
        Todo(name: "贝蒂小熊", checked: false),
        Todo(name: "hello world", checked: false),
        Todo(name: "12138", checked: false),
        Todo(name: "🎃", checked: true)
    ]
    
    //全局的row
    var row = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        editButtonItem.image = UIImage(systemName: "highlighter")
        
        tableView.separatorInset.left = 50
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if isEditing {
            editButtonItem.image = nil
            editButtonItem.title = "完成"
        } else {
            editButtonItem.image = UIImage(systemName: "highlighter")
            editButtonItem.title = nil
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kreuseIdentifierID, for: indexPath) as! TodoTableViewCell
        
        cell.checkBoxButton.isSelected = todos[indexPath.row].checked
        cell.todoLabel.text = todos[indexPath.row].name
        //等同于上
//        if todos[indexPath.row].checked {
//            cell.todoLabel.textColor = .tertiaryLabel
//        } else {
//            cell.todoLabel.textColor = .label
//        }
        
        //选中按钮过后做的事
//        if !isEditing {
//            cell.checkBoxButton.addAction(UIAction(handler: { action in
//                //self.todos[indexPath.row].checked = !self.todos[indexPath.row].checked
        
//                self.todos[indexPath.row].checked.toggle()
//                cell.checkBoxButton.isSelected = self.todos[indexPath.row].checked
//                cell.todoLabel.textColor = self.todos[indexPath.row].checked ? .tertiaryLabel : .label
//            }), for: .touchUpInside)
//        }
        
        cell.checkBoxButton.tag = indexPath.row
        cell.checkBoxButton.addTarget(self, action: #selector(tagCheck), for: .touchUpInside)
        
        return cell
    }
    
    @objc func tagCheck(checkBoxButton: UIButton) {
        let row = checkBoxButton.tag
        todos[row].checked.toggle()
        checkBoxButton.isSelected = todos[row].checked
        let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as! TodoTableViewCell
        cell.todoLabel.textColor = todos[row].checked ? .tertiaryLabel : .label
        
    }
    
    
    //编辑跳转
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
//        if indexPath.row == 0 {
//            navigationController?.pushViewController(addTodoTableViewController, animated: true)
//        } else if indexPath.row == 1 {
//
//        }
        
//        let addTodoTableViewController = storyboard!.instantiateViewController(withIdentifier: "AddTodoTableViewControllerID") as! AddTodoTableViewController
//        navigationController?.pushViewController(addTodoTableViewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }

    // MARK: Navigation 反向传值从AddTodoTableViewController传到TodoTableViewController的name
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "addTodoSegue" {
            
            let vc = segue.destination as! AddTodoTableViewController
            vc.delegate = self
        } else if segue.identifier == "editTodoSegue" {
            let vc = segue.destination as! AddTodoTableViewController
            let cell = sender as! TodoTableViewCell
            
            vc.delegate = self
            //通过cell找对应的indexPath
            row = tableView.indexPath(for: cell)!.row
            //通过indexPath找对应的cell
            //tableView.cellForRow(at: indexPath) as! TodoTableViewCell
            vc.name = todos[row].name
        }
    }
    
    ////增删改查-删
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            
        }
    }
    
    //排序
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //        var arr = [ 1, 2, 3, 4]
        //        arr.remove(at: 2)
        //        arr.insert(43, at: 0)
        //
        //        print(arr)
        let todosToRemove = todos[sourceIndexPath.row]
        todos.remove(at: sourceIndexPath.row)
        todos.insert(todosToRemove, at: destinationIndexPath.row)
        
        tableView.reloadData()
        //print(todos)
    }
    
    //编辑状态下左边的按钮样式
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if !isEditing {
            return .delete
        } else {
            return .none
        }
        
        //return isEditing ? .none : .delete
    }
    
    //上面方法返回none的时候编辑状态下的缩进
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }

}

extension TodosTableViewController:AddTodoTableViewControllerDelegate {
    
    //增删改查-增
    func didAdd(name: String) {
        todos.append(Todo(name: name, checked: false))
        
        tableView.insertRows(at: [IndexPath(row: todos.count - 1, section: 0)], with: .automatic)
        //print(name)
    }
    
    //增删改查-改
    func didEdit(name: String) {
        todos[row].name = name
        
//        let indexPath = IndexPath(row: row, section: 0)
//        let cell = tableView.cellForRow(at: indexPath) as! TodoTableViewCell
//        cell.todoLabel.text = todos[row].name
        tableView.reloadData()
    }
}
