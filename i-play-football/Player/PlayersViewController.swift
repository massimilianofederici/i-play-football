import Foundation
import UIKit

class PlayersViewController: UITableViewController {
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    let persistence = PlayerPersistence()
    
    lazy var players: [Player] = { [unowned self] in
        return loadPlayers()
        }()
    
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
            persistence.delete(player: &self.players[indexPath.row])
            self.reload()
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
            detailsController.player = players[selection]
        default:
            print(identifier as Any)
        }
    }
    
    @IBAction func cancelChanges(unwindSegue: UIStoryboardSegue) {
        self.players = self.loadPlayers();
        self.tableView.reloadData()
    }
    
    @IBAction func saveOrUpdate(unwindSegue: UIStoryboardSegue) {
        let detailsController:PlayerDetailsViewController = unwindSegue.source as! PlayerDetailsViewController
        persistence.save(player: &detailsController.player!)
        reload()
    }
    
    private func loadPlayers() -> [Player] {
        return self.persistence.findAll();
    }
    
    private func reload() {
        #warning("fix using observers")
        DispatchQueue.main.async {
            self.players = self.loadPlayers();
            self.tableView.reloadData()
        }
    }
}
