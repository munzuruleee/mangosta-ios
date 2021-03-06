//
//  RoomsRepository.swift
//  Mangosta
//
//  Created by Sergio E. Abraham on 9/26/16.
//  Copyright © 2016 Inaka. All rights reserved.
//

import Foundation

class RoomRepository: CRUDRepository {
	
	typealias EntityType = Room
	let backend = NSURLSessionBackend.MongooseREST()
	let name = "rooms"
	
	// To create a room use create
	
	// To return room's details use findByID
	
	
	func addUserToRoom(entity: EntityType, userJID : String) -> Future<EntityType, JaymeError> {
		let path = self.name + "/" + entity.id + "/users"
		let parameter : [String: AnyObject]? = ["name":userJID]
		return self.backend.futureForPath(path, method: .POST, parameters: parameter)
			.andThen { DataParser().dictionaryFromData($0.0) }
			.andThen { EntityParser().entityFromDictionary($0) }
	}
	
	// Removes a user from the room
	
	func deleteUserFromRoom(entity: EntityType, userJID : String) -> Future<Void, JaymeError> {
		let path = self.name + "/" + entity.id + "/" + userJID
		return self.backend.futureForPath(path, method: .DELETE, parameters: nil)
			.map { _ in return }
	}
	
	func getMessagesFromRoom(id: EntityType.IdentifierType, limit: NSNumber?, before: NSNumber?) -> Future<[Message], JaymeError> {
		let path = self.name + "/" + id + "/messages"
		var parameters : [String : AnyObject]? = nil
		if let limit = limit {
			parameters!["limit"] = limit.integerValue
		}
		if let before = before {
			parameters!["before"] = before.longValue
		}
		return self.backend.futureForPath(path, method: .GET, parameters: parameters)
			.andThen { DataParser().dictionariesFromData($0.0) }
			.andThen { EntityParser().entitiesFromDictionaries($0) }
	}
	
	func sendMessageToRoom(entity: EntityType, messageBody: String) -> Future<EntityType, JaymeError> {
		let path = self.name + "/" + entity.id + "/messages"
		let parameter : [String : AnyObject]? = ["body":messageBody]
		return self.backend.futureForPath(path, method: .POST, parameters: parameter)
			.andThen { DataParser().dictionaryFromData($0.0) }
			.andThen { EntityParser().entityFromDictionary($0) }
	}
}
