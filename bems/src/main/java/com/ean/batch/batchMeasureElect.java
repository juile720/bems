package com.ean.batch;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import net.wimpi.modbus.ModbusException;
import net.wimpi.modbus.procimg.InputRegister;

import com.ean.db.DBservice;

public class batchMeasureElect {
	public static void main(String[] args) throws IOException, Exception {
		// TODO Auto-generated method stub
		try 
		{
			DBservice dbservice = new DBservice();
			Connection            conn = null;
			PreparedStatement     ps   = null;
			ResultSet             rs   = null;
			int cnt = 0;
			
			String cIP = "";
			ModbusTCPMaster mtm = null;
			InputRegister[] ir = null;
			
	    	// DB 에서 장비의 리스트와 정보를 읽어온다
	    	conn = dbservice.getConnection();
	    	conn.setAutoCommit(false);
	    	
	    	String str = "select * from ( "
	    			+ "SELECT "
	    			+ " c_floor,c_floordesc ,LTRIM (SYS_CONNECT_BY_PATH (c_desc, ' - '), ' - ') AS depth_fullname , C_IPADDRESS, tb_floor.C_PORT, C_HEX, C_HEX8000 "
	    			+ " FROM tb_floor " 
	    			+ " START WITH c_floor = '0' " 
	    			+ " CONNECT BY PRIOR c_floordesc = c_floor  "
	    			+ " order by 1, 2) "
	    			+ " where c_floor <> '0'";

	    	ps = conn.prepareStatement(str);
	    	rs = ps.executeQuery();
	    	
			while(rs.next()){
				int ref = 0;
				int count = 0;
				int unitid = 1;
				
				float i_sum =0;
				float i_thismonth = 0;
				float i_lastmonth = 0;
				float I_W_NOW = 0;
				
				if ( cnt == 0) {
					cIP = rs.getString("C_IPADDRESS").trim();
					mtm = new ModbusTCPMaster(rs.getString("C_IPADDRESS").trim(), Integer.parseInt(rs.getString("C_PORT").trim()));
			        mtm.connect(); cnt = 1;
				} 
		        
				if (!cIP.equals(rs.getString("C_IPADDRESS").trim())){
					cIP = rs.getString("C_IPADDRESS").trim();
					mtm.disconnect();
					mtm = null; ir = null;
					mtm = new ModbusTCPMaster(rs.getString("C_IPADDRESS").trim(), Integer.parseInt(rs.getString("C_PORT").trim()));
			        mtm.connect();
				}

				ref = Integer.parseInt(rs.getString("C_HEX8000").trim(), 16); // Address : 8000 누적 KWH
		        count = 10;
		        
		        ir = mtm.readInputRegisters(unitid, ref, count);

		        for (int n = 0; n < ir.length; n += 2) {

		        	byte[] by = ir[n].toBytes();
		        	byte[] by1 = ir[n + 1].toBytes();
		        	
		        	if (n == 0) {
		        		i_sum = ((by[0] & 0xFF) << 24) | ((by[1] & 0xFF) << 16) | ((by1[0] & 0xFF) << 8) | (by1[1] & 0xFF);
		        		i_sum = (float) (i_sum * 0.1);
//		        		System.out.println("#i_sum" + "=" + i_sum);
		        	}else if(n==2){
		        		i_thismonth = ((by[0] & 0xFF) << 24) | ((by[1] & 0xFF) << 16) | ((by1[0] & 0xFF) << 8) | (by1[1] & 0xFF);
		        		i_thismonth = (float) (i_thismonth * 0.1);
//		        		System.out.println("#i_thismonth" + "=" + i_thismonth);
		        	}else if(n==4){
		        		i_lastmonth = ((by[0] & 0xFF) << 24) | ((by[1] & 0xFF) << 16) | ((by1[0] & 0xFF) << 8) | (by1[1] & 0xFF);
		        		i_lastmonth = (float) (i_lastmonth * 0.1);
//		        		System.out.println("#i_lastmonth" + "=" + i_lastmonth);
		        	}
//		        	System.out.println("#" + (n + 1) + "=" + (value * 0.1));
		        }
		        
		        //Thread.sleep(1000);
		        System.out.println("# C_HEX" + "=" + rs.getString("C_HEX"));
		        ref = Integer.parseInt(rs.getString("C_HEX").trim(), 16); // Address : WATT 
		        count = 29;
		        
		        ir = mtm.readInputRegisters(unitid, ref, count);

		        for (int n = 0; n < ir.length; n++) {
		        	if (n == 4) {
			        	byte[] by = ir[n].toBytes();
			        	byte[] by1 = ir[n + 1].toBytes();
			        	I_W_NOW  = ((by[0] & 0xFF) << 24) | ((by[1] & 0xFF) << 16) | ((by1[0] & 0xFF) << 8) | (by1[1] & 0xFF);
			        	//I_W_NOW = ir[n].getValue();
		        		System.out.println("# I_W_NOW" + "=" + I_W_NOW);
		        	}
		        }
		        
            	str = "insert into tb_rawdata(t_datetime, c_master, c_slave, i_w_now, i_sum, i_thismonth, i_lastmonth,C_DESC) values "
			    		+ "(SYSTIMESTAMP,'" + rs.getString("c_floor").trim()+ "','" +rs.getString("c_floordesc").trim()+"'," 
			    		+I_W_NOW+","+i_sum+","+i_thismonth+","+i_lastmonth+",'"+rs.getString("depth_fullname").trim()+"')";

			    
			    System.out.println("str : " + str);
				
			    ps = conn.prepareStatement(str);
				ps.executeQuery();
				ps.close();
			}

			rs.close();
			mtm.disconnect();
			conn.commit();
			conn.close();
			
		}catch (Exception ex) {
			ex.printStackTrace();
			System.exit(0);
		}
	}
}
