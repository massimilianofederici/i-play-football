//
//  PlayersController.swift
//  i-play-football
//
//  Created by Massimiliano Federici on 12/01/2019.
//  Copyright © 2019 Massimiliano Federici. All rights reserved.
//

import Foundation
import UIKit

class PlayersViewController: UITableViewController {
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    let persistence = PlayersPersistence()
    
    lazy var players: [Player] = { [unowned self] in
        return loadPlayers()
        }()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlainCell", for: indexPath)
        cell.textLabel?.text = players[indexPath.row].name()
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier
        let next : UINavigationController = segue.destination as! UINavigationController
        let detailsController:PlayerDetailsViewController = next.topViewController as! PlayerDetailsViewController
        switch identifier {
        case "addPlayer":
            detailsController.player = Player.aPlayer()
        case "playerDetails":
            let selection: Int! = self.tableView.indexPathForSelectedRow?.row
            detailsController.player = players[selection]
        default:
            print(identifier as Any)
        }
    }
    
    @IBAction func cancelChanges(unwindSegue: UIStoryboardSegue) {
    }
    
    @IBAction func saveOrUpdate(unwindSegue: UIStoryboardSegue) {
        let detailsController:PlayerDetailsViewController = unwindSegue.source as! PlayerDetailsViewController
        detailsController.player.map{ p in
            p.isTransient() ? savePlayer(p) : updatePlayer(p)
        }
    }
    
    private func updatePlayer(_ player: Player) {
        DispatchQueue.main.async {
            self.players.removeAll(where: {p in p.id?.uuidString == player.id?.uuidString})
            self.players.append(player)
            self.persistence.save(self.players)
            self.players = self.loadPlayers()
            self.tableView.reloadData()
        }
    }
    
    private func savePlayer(_ player: Player) {
        DispatchQueue.main.async {
            self.players.append(player)
            self.persistence.save(self.players)
            self.players = self.loadPlayers();
            self.tableView.reloadData()
        }
    }

    private func loadPlayers() -> [Player] {
        return self.persistence.load().sorted();
    }
}
