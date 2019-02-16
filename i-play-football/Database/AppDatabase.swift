import Foundation
import GRDB

struct AppDatabase {
    
    static func openDatabase(atPath path: String) throws -> DatabaseQueue {
        let dbQueue = try DatabaseQueue(path: path)
        try migrator.migrate(dbQueue)
        return dbQueue
    }
    
    static var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()

        migrator.registerMigration("createSchedules") { db in
            try db.create(table: "schedule") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("startTime", .date).notNull()
                t.column("title", .text).notNull()
                t.column("endTime", .date).notNull()
                t.column("note", .text)
                t.column("categoryColor", .text).notNull()
            }
        }
        
        migrator.registerMigration("createPlayers") { db in
            try db.create(table: "player") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("firstName", .text).notNull()
                t.column("lastName", .text).notNull()
                t.column("dateOfBirth", .date)
                t.column("notes", .text)
                t.column("preferredPosition", .text)
                t.column("profilePicture", .blob)
            }
        }
        
        migrator.registerMigration("createTeams") { db in
            try db.create(table: "team") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("name", .text).notNull()
                t.column("coach", .text).notNull()
                t.column("colour", .text)
                t.column("notes", .text)
            }
        }
        return migrator
    }
}
