package com.ean.db;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import java.util.Enumeration;
import java.util.Properties;
import java.util.Vector;

public final class ConnectionPool2 {

    // Print debug information to System.err.
    private static final boolean debug = true;

    // Storage for the unused connections.
    private Vector free;

    static final String jdbcclass = "oracle.jdbc.driver.OracleDriver";
 // Storage for the allocated connections.
    private Vector used;


    // Connection information.

    private String url; 
    private String user;
    private String password;
    private Properties info;

    // Initial Connections
    private int initialCons = 0;

    // Maximum number of concurrent connections allowed.
    private int maxCons = 0;

    // The number of connection that have been created.
    private int numCons = 0;

    // Whether to block until a connection is free when maxCons are in use.
    private boolean block;

    // Timeout waiting for a connection to be released when blocking.
    private long timeout;

    // Whether we should re-use connections or not
    private boolean reuseCons = true;

    public ConnectionPool2(String url, String user, String password,
			  int initialCons, int maxCons, boolean block,
			  long timeout) throws SQLException {

	this.url = url;
	this.user = user;
	this.password = password;
	this.initialCons = initialCons;
	this.maxCons = maxCons;
	this.block = block;
	this.timeout = timeout;

	// maxCons has precedence over initialCons
        if (maxCons > 0 && maxCons < initialCons)
	    initialCons = maxCons;

	// Create vectors large enough to store all the connections we make now.
	free = new Vector(initialCons);
	used = new Vector(initialCons);

	// Create some connections.
	while (numCons < initialCons){
	    addConnection();
	}

    }

    public String reportStatus(){
    	String report = "use : "+used.size() + "       free : "+free.size();
    	return report;
    }


    public synchronized void closeAll() {

	// Close unallocated connections
	Enumeration cons = ((Vector)free.clone()).elements();
	while (cons.hasMoreElements()) {
	    Connection con = (Connection)cons.nextElement();

	    free.removeElement(con);
	    numCons--;

	    try {
		con.close();
	    } catch (SQLException e) {
		// The Connection appears to be broken anyway, so we will ignore it
	    }
	}

	cons = ((Vector)used.clone()).elements();
	while (cons.hasMoreElements()) {
	    Connection con = (Connection)cons.nextElement();

	    used.removeElement(con);

	}
    }

    public boolean getBlock() {
	return block;
    }


    public Connection getConnection()
	throws SQLException {
	return getConnection(this.block, timeout);
    }


public synchronized Connection getConnection(boolean block, long timeout)
throws SQLException {

  if (free.isEmpty()) {

    // None left, do we create more?
    if (maxCons <= 0 || numCons < maxCons) {
      addConnection();
    }
    else if (block) {
      try {
	long start = System.currentTimeMillis();
	do {
	  wait(timeout);
	  if (timeout > 0) {
	    timeout -= System.currentTimeMillis() - start;
	    if (timeout == 0) {
	      timeout -= 1;
	    }
	  }
	} while (timeout >= 0 && free.isEmpty() && maxCons > 0 && numCons >= maxCons);
      } catch (InterruptedException e) {
	 }
      // Did anyone release a connection while we were waiting?
      if (free.isEmpty()) {
	if (maxCons <= 0 || numCons < maxCons) {
	  addConnection();
	} else {
	  throw new SQLException("Timeout waiting for a connection to be released");
	}
      }
    } else {
      // No connections left and we don't wait for more.
      throw new SQLException("Maximum number of allowed connections reached");
    }
  }
  // If we get this far at least one connection is available.
  Connection con;

  synchronized (used) {

    con = (Connection)free.lastElement();
    // Move this connection off the free list
    free.removeElement(con);
    used.addElement(con);
  }

return con;
}
    public int getMaxCons() {
	return maxCons;
    }


    public boolean getReuseConnections() {
	return reuseCons;
    }


    public long getTimeout() {
	return timeout;
    }

    public String getUrl() {
	return url;
    }


public synchronized void releaseConnection(Connection con)
throws SQLException {

  boolean reuseThisCon = reuseCons;

  if (used.contains(con)) {
    // Move this connection from the used list to the free list
    used.removeElement(con);
    numCons--;
  } else {
    throw new SQLException("Connection " + con +
					 " did not come from this ConnectionPool");
  }

  try {

      if (reuseThisCon) {
	     free.addElement(con);
	     numCons++;
      } else {
	     con.close();
      }
    notify();
  } catch (SQLException e) {
    try {
      con.close();
    } catch (Exception e2) {
      // we're expecting an SQLException here
    }
    notify();
  }
}

    public void setBlock(boolean block) {
	this.block = block;
    }


    public synchronized void setReuseConnections(boolean reuseCons) {
	this.reuseCons = reuseCons;
    }



    public void setTimeout(long timeout) {
	this.timeout = timeout;
    }



    private void addConnection() throws SQLException {
	free.addElement(getNewConnection());
    }



    private Connection getNewConnection() throws SQLException {

	Connection con = null;

    System.out.println("About to connect to " + url + user + password);
 try {
	  con = DriverManager.getConnection(url,user,password);


}
 catch (Exception e) {
    e.printStackTrace();
 }

        ++numCons;

	return con;
    }

}