package com.abhishek.test1;

import java.sql.Time;
import java.util.HashMap;
import java.util.Map;
import com.google.appengine.api.datastore.Entity;

class User {
	public static final String kind = "User";
	static long user_id = 1; // primary key
	String email;
	String login;
	String passwd;
	String first_name;
	String last_name;
	String middle_name;
	char gender;
	Time upd_ts;
	String photo_path;
	boolean is_external;
	long last_login;
	short failed_logins;
	boolean verified;

	// changes the class attributes to a key value pair
	// Helper for DAL functions
	Map<String, Object> getMapper() {
		Map<String, Object> m = new HashMap<String, Object>();
		m.put("email", this.email);
		m.put("login", this.login);
		m.put("passwd", this.passwd);
		m.put("first_name", this.first_name);
		m.put("last_name", this.last_name);
		m.put("middle_name", this.middle_name);
		m.put("gender", "" + this.gender);
		m.put("upd_ts", "" + this.upd_ts);
		m.put("photo_path", this.photo_path);
		m.put("is_external", this.is_external);
		m.put("last_login", this.last_login);
		m.put("failed_login", this.failed_logins);
		m.put("verified", this.verified);
		return m;
	}

	/*
	 * returns a new entity with a new entity id and all properties set
	 * 
	 * @param m set of all properties of the user, (all the columns in the MySQL
	 * script).
	 * 
	 * @return new_entity
	 */
	Entity create_user_entity(Map<String, Object> m) {
		// TODO: assert not null for attributes mentioned in the script
		Entity new_entity = new Entity("User", ("" + user_id));
		if (m != null) {
			user_id++;
			DAL.setProperty(new_entity, m);
		}
		return new_entity;
	}

}

class Content {
	static long content_id; // primary key
	String content_type;
	String url;
	String title;
	String user_id;
	String is_private;
	String description;
	String upd_ts;
	String tags;

	Entity create_content_entity(Map<String, Object> m) {
		// TODO: assert not null for attributes mentioned in the script
		Entity new_entity = new Entity("content", "" + content_id);
		content_id++;
		DAL.setProperty(new_entity, m);
		return new_entity;
	}

}

class Trails {
	static long trail_id = 1; // primary key
	String title;
	String is_private;
	String user_id;
	String upd_ts;
	String tags;

	Entity create_content_entity(Map<String, Object> m) {
		Entity new_entity = new Entity("trail", ("" + trail_id));
		if (m != null) {
			trail_id++;
			DAL.setProperty(new_entity, m);
		}
		return new_entity;
	}
}

class TrailItems {
	static long item_id = 1;
	String trail_id;
	String content_id;
	String seq_no;
	String upd_ts;

	Entity create_item_entity(Map<String, Object> m) {

		Entity new_entity = new Entity("item", "" + item_id);
		if (m != null) {
			item_id++;
			DAL.setProperty(new_entity, m);
		}
		return new_entity;
	}
}

class Comments {
	static long comment_id = 1;
	String author;
	String comment;
	String level;
	String trail_id;
	String item_id;
	String subject;
	String in_reply_to;
	String tags;
	String upd_ts;
	String ins_ts;

	Entity create_comment_entity(Map<String, Object> m) {
		Entity new_entity = new Entity("comment", "" + comment_id);
		if (m != null) {
			comment_id++;
			DAL.setProperty(new_entity, m);
		}
		return new_entity;
	}
}

class Analytics {
	static long analytics_id = 1;
	static final String Kind = "Analytics";
	String action;
	String user_id;
	String trail_id;
	String trail_item_id;
	String comment_id;
	String action_ts;

	Entity create_analytics_entity(Map<String, Object> m) {
		Entity new_entity = new Entity("analytics", "" + analytics_id);
		if (m != null) {
			analytics_id++;
			DAL.setProperty(new_entity, m);
		}
		return new_entity;
	}
}

class Questions {
}

class AnswerOptions {
}

class Assessments {
}

class AssessmentQuestions {
}

class AssessmentSubmissions {
}

class AuditLogs {
}

class OneTimeAuth {
	static long auth_id = 1;
	String user_id;
	String uuid_part;
	String expires_on;
	String ins_ts;

	// changes the class attributes to a key value pair
	// Helper for DAL functions
	Map<String, Object> getMapper() {
		Map<String, Object> m = new HashMap<String, Object>();
		m.put("user_id", this.user_id);
		m.put("uuid_part", this.uuid_part);
		m.put("expires_on", this.expires_on);
		m.put("ins_ts", this.ins_ts);
		return m;
	}

	/*
	 * returns a new entity with a new entity id and all properties set
	 * 
	 * @param m set of all properties of the user, (all the columns in the MySQL
	 * script).
	 * 
	 * @return new_entity
	 */

	Entity create_analytics_entity(Map<String, Object> m) {
		Entity new_entity = new Entity("OneTimeAuth", "" + auth_id);
		if (m != null) {
			auth_id++;
			DAL.setProperty(new_entity, m);
		}
		return new_entity;
	}

}

class Roles {
}

class SubmissionResponses {
}

class Subscriptions {
}

class TrailAssessments {
}

class UserRoles {
}
