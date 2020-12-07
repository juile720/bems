package com.ean.db;
import java.sql.*;

public class DBservice{
	
	public  static DBserver server;
	
	public DBservice(){
		System.out.println("1. Trying to bringup DBserver.....");
		server = new DBserver();
		startServer();
	}
	
	public void startServer(){
		try{
			server.startUp();
		}catch(Exception e){
			System.out.println("server not started\n"+e.getMessage());
		}
	
	}
	
	public void stopServer(){
		try{
			server.shutDown();
		}catch(Exception e){
			System.out.println("server not stopped\n"+e.getMessage());
		}
	}
	
	public static Connection getConnection(){		
		try{			
			Connection conn = server.getConnection();			
			return conn;
		}catch(Exception e){
			System.out.println("no Connections !!!\n"+e.getMessage());
		}
		return null;
	}

	public static void releaseConnection(Connection conn){
		server.releaseConnection(conn);
	}

}
