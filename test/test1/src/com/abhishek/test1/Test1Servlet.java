package com.abhishek.test1;

import java.io.IOException;
import java.sql.Time;
import java.util.Map;

import javax.servlet.http.*;

import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Query;
import com.google.appengine.api.datastore.Query.FilterOperator;

//TODO: query 2: counting entities is not done

@SuppressWarnings("serial")
public class Test1Servlet extends HttpServlet {
	static DAL dal;

	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		// create a data access layer
		dal = new DAL();
		insert_user();
		p("Total number of users in the data-store is:" + this.count(User.kind));
		resp.setContentType("text/plain");
		resp.getWriter().println(
				"Hello there!\nAll the data hard coded in the project has been saved in the local GAE datastore."
						+ "\nTo see the changes, go to http://localhost:[port_number]/_ah/admin\nDefault port number usually is 8888\n");

	}

	// Examples of the queries:::
	void insert_user() {
		// first we need to create a user.
		User a = new User();
		a.email = "myemailid@domain.some";
		a.first_name = "Abhishek";
		a.middle_name = "Kumar";
		a.last_name = "Tiwari";
		a.last_login = System.currentTimeMillis();
		a.login = "my_user_name";
		a.passwd = "my_password";
		a.gender = 'M';
		a.upd_ts = new Time(0);
		a.photo_path = "this/is/my/pic/path";
		a.is_external = false;
		a.failed_logins = 4;
		a.verified = true;
		// now get a key value pairs
		Map<String, Object> m = a.getMapper();
		// Create an Data-store entity
		Entity e = a.create_user_entity(m);
		// insert this entity to the local data-store.
		dal.insert_entity(e);
	}

	@SuppressWarnings("deprecation")
	/*
	 * returns the number of entities in the data-store of type "kind"
	 * 
	 * @param kind:Kind of the entity
	 * 
	 * @return totalEntities: number of entities in the data-store of type kind
	 */
	long count(String kind) {
		long count = 0;
		// TODO: finish this.
		return count;
	}

	// just for printing stuff easily.
	private void p(String string) {
		System.out.println("" + string);
	}
}
