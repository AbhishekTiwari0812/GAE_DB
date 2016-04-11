=====================================================README=======================================================================

Before we start transporting the script from MySQL to GAE datastore script, we need to set up the environment.
Steps:
	1.	Install Eclipse EE latest version (in the project Eclipse Mars has been used).
	2.	Install the Web Tools Platform(WTP) tools in Eclipse.(During startup, the WTP plugin looks for the expected Web Tools 		Platform (WTP) runtime instance.)
	3.	If the WTP runtime instance is not found, a new one is created. The WTP instance is automatically configured to use the 	default Java Runtime Environment and default Google App Engine SDK.
	4.  Install the Google App Engine SDK along with other necessary tools for GAE sdk to work.
	5.  Now open a new web application by clicking on the Google logo appearing in the top left corner in the IDE.
	6.	Last but not the least, make sure the JRE version 1.7 is being used. Google SDK doesn't support JRE 1.8
	(For detailed instructions: https://cloud.google.com/appengine/docs/java/webtoolsplatform#configuration)
	Finally, we are all set to start doing the actual part.
=================================================================================================================================

Class DAL is the data access layer. In this class all the queries have been implemented. This class directly communicates with the  datastore.

All the default classes Public class ClassObjects are similar to the table user in the provided script. (Attribute data type for some of the columns in the script are not same though)


Parts finished and working:-
All the insert statements are complete.

getMapper() has been implemented for User and OneTimeAuth.
getMapper returns a map of attribute names and their values of the object. Used for implementing insert statements.
For other classes, one can use the same way of implementing the getMapper method. 

setProperty() is complete for all the classes.
This method sets the entity properties of a particular object.

search() is implemented for all the entities. (Not tested yet)
This method finds the unique key of the entities stored in the data-store.
===========================================================================================================================

To show that the project is working, I have implemented a new user insert statement, attributes of which are hard coded in the Test1Servlet.insert_user method.
To check the working, run the web app, go to http://localhost/8888 and click on the link click me! to execute the create_user() method. Now one can check the new entity in the data-store GUI for which should be on the link http://localhost/8888/_ah/admin
=================================================================================================================================
The project has been built/tested in Eclipse Mars with JRE 1.8 (although JRE 1.7 should be used!) on windows x64.
=================================================================================================================================
