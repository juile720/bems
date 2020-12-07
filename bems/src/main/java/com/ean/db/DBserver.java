package com.ean.db;
import java.sql.*;
import java.util.*;

public class DBserver{

	private Properties props;
/*
 * 
	private String driverClass		= "com.microsoft.sqlserver.jdbc.SQLServerDriver";
	private String driverUrl		= "jdbc:sqlserver://localhost:1433;databaseName=nfsdta;user=sa;password=1234";
	private String databaseUser	= "sa";
	private String databasePasswd		= "1234";
*/

	private String driverClass			= "oracle.jdbc.driver.OracleDriver";
	private String driverUrl			= "jdbc:oracle:thin:@eantech:1521:eandb";
	private String databaseUser			= "BEMSDB";
	private String databasePasswd		= "BEMSDB";
	
//	private String driverClass		= "com.mysql.jdbc.Driver";
//	private String driverUrl		= "jdbc:mysql://121.78.85.251:3306/wpt_db";
//	private String databaseUser	= "wpt_db_user";
//	private String databasePasswd		= "wpt_pass";

	private boolean isStarted = false;

	// connection pool
	private ConnectionPool2 connectionPool2;

	// constructor
	public DBserver() {
		loadProperties();
		try{
			Class.forName (driverClass);
		}catch(Exception e){}
	}

	public void loadProperties(){
	}

	public void startUp() throws Exception {
		if ( isRunning() ) {
			return;
		}

		try {
			connectionPool2 =
				new ConnectionPool2(driverUrl, databaseUser,  databasePasswd,1, 50,true, 10000);
			System.out.println("3. Connection Pooling completed !!!");
		} catch ( Exception ex ) {
			System.err.println( "3. ConnectionPool  Error!" +  ex);
		}

		isStarted = true;
	}

	// shut down
	public void shutDown() throws Exception{
		if ( !isRunning() ) {
			return;
		}
		isStarted = false;
	}

	// is started
	public boolean isRunning() {
		return isStarted;
	}

	//properties report
	public String reportProperties(){
		String props= "<Table border=1 width=90%>" +
					"<tr><td>DB Driver <td>" + driverClass +
					"<tr><td>DB Url <td>" + driverUrl +
					"<tr><td>DB ID<td>" + databaseUser +
				 	"</Table>" ;
		return props;
	}

	// status report
	public String reportStatus() {
		//return( connectionPool.reportStatus() );
		return connectionPool2.reportStatus();
	}

	public Connection getConnection () throws Exception{
		return connectionPool2.getConnection();
	}

	public void releaseConnection (Connection conn) {
		try{
		connectionPool2.releaseConnection(conn);
		}catch(Exception e){System.out.println(e);}
	}

}