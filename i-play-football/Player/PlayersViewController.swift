import Foundation
import UIKit
import GRDB

class PlayersViewController: UITableViewController {
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    private var dbListener: TransactionObserver?
    
    private var players: [Player] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        dbListener = try! ValueObservation
            .trackingAll(Player.orderByName())
            .start(in: dbQueue) {self.players = $0}
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlainCell", for: indexPath)
        cell.textLabel?.text = players[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let _ = try! dbQueue.write { db in
                try players[indexPath.row].delete(db)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier
        let next : UINavigationController = segue.destination as! UINavigationController
        let detailsController:PlayerDetailsViewController = next.topViewController as! PlayerDetailsViewController
        switch identifier {
        case "addPlayer":
            detailsController.player = Player(firstName: "", lastName: "", dateOfBirth: nil, preferredPosition: nil, profilePicture: nil, notes: "", id: nil)
        case "playerDetails":
            let selection: Int! = self.tableView.indexPathForSelectedRow?.row
            detailsController.player = try! dbQueue.read {db in
                try Player.fetchOne(db, key: players[selection].id!)
            }
        default:
            print(identifier as Any)
        }
    }
    
    @IBAction func cancelChanges(unwindSegue: UIStoryboardSegue) {
    }
    
    @IBAction func saveOrUpdate(unwindSegue: UIStoryboardSegue) {
        let detailsController:PlayerDetailsViewController = unwindSegue.source as! PlayerDetailsViewController
        try! dbQueue.write { db in
            try detailsController.player?.save(db)
        }
    }
    
}
