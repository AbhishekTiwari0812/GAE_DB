package com.abhishek.test1;

import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;
import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;

public class DAL {
	DatastoreService ds;

	// initializing the data-store.
	DAL() {
		ds = DatastoreServiceFactory.getDatastoreService();
	}

	/*
	 * returns the modified Entity with all the properties set.
	 * 
	 * @param e the reference to new entity created.
	 * 
	 * @param m the(property,value) pair for that entity.
	 * 
	 * @return modified entity
	 */
	static Entity setProperty(Entity e, Map<String, Object> m) {
		Iterator<Entry<String, Object>> it = m.entrySet().iterator();
		// setting all the attributes of the entity.
		while (it.hasNext()) {
			Map.Entry<String, Object> pair = (Entry<String, Object>) it.next();
			e.setProperty(pair.getKey(), "" + pair.getValue());
		}
		return e;
	}

	/*
	 * Insert statements. Generic method for all insert queries in the given
	 * script.
	 * 
	 * @param Entity : the entity to be inserted
	 * 
	 * @return :true if successful, false on failure
	 */
	boolean insert_entity(Entity e) {
		boolean isDuplicate = false;
		// TODO: check for duplicates.
		if (!isDuplicate) { // insert if entity not a duplicate
			ds.put(e);
		} else {
			// TODO: print log for duplicates
			p("Duplicate entity");
		}

		return !isDuplicate;
	}

	/*
	 * returns entity from the data-store. make sure that the entity already
	 * exists.
	 * 
	 * @param EntityType The type of entity trying to search
	 * 
	 * @param EntityId The unique id of the entity being searched
	 * 
	 * @return Entity object being searched
	 * 
	 */
	Entity search(String EntityType, String EntityId) {
		// make sure that the entity exists in the data-store already
		// helper for the update entity in the data-store
		Key key = KeyFactory.createKey(EntityType, EntityId);
		Entity e = new Entity(EntityType, key);
		return e;
	
	}

	// used for printing errors.
	private void p(String string) {
		System.out.println("" + string);

	}

}