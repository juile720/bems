package com.ean.batch;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import net.wimpi.modbus.ModbusException;
import net.wimpi.modbus.procimg.InputRegister;

import com.ean.db.DBservice;

public class batchModbus {

	public static void main(String[] args) throws IOException, Exception {
		// TODO Auto-generated method stub
		try 
		{
			DBservice dbservice = new DBservice();
			Connection            conn = null;
			PreparedStatement     ps   = null;
			ResultSet             rs   = null;
			
	    	// DB 에서 장비의 리스트와 정보를 읽어온다
	    	conn = dbservice.getConnection();
	    	conn.setAutoCommit(false);
	    	
	    	String str = "select * from tb_device where c_name NOT like '%CO2%' and c_master = '0' "
	    			+ "and c_slave not in ('15','16','17','18','19') order by to_number(c_slave) ";
	    	ps = conn.prepareStatement(str);
	    	rs = ps.executeQuery();
	    	
			while(rs.next()){
				int cnt = 1; //loop count
				int ref = 0;
				int count = 0;
				int unitid = 1;
				InputRegister[] ir = null;
				double val = 0;

				ModbusTCPMaster mtm = new ModbusTCPMaster(rs.getString("C_IPADDRESS").trim(), Integer.parseInt(rs.getString("C_PORT").trim()));
	            mtm.connect();
	            
	            ref = Integer.parseInt("1F40", 16); // Address : 8000 누적 KWH
	            
	            if (rs.getString("C_IPADDRESS").equals("10.1.1.2") ){
	            	count = 118;
	            }else if(rs.getString("C_IPADDRESS").equals("10.1.1.6") || rs.getString("C_IPADDRESS").equals("10.1.1.9")){
	            	count = 119;
	            }else if(rs.getString("C_IPADDRESS").equals("10.1.1.11") || rs.getString("C_IPADDRESS").equals("10.1.1.13")){
	            	count = 125;
	            }else if(rs.getString("C_IPADDRESS").equals("10.1.1.15")){
	            	count = 108;
	            }else if(rs.getString("C_IPADDRESS").equals("10.1.1.17")){
	            	count = 125;
	            }
	            
	            String decref = getHexToDec("1F40");

	            Integer I = Integer.parseInt(decref); 
	            
	            ir = null;
                String sref = getDecToHex(String.valueOf(I));
                ref = Integer.parseInt(sref, 16);
                
                //System.out.println("ip address = " + rs.getString("C_IPADDRESS") );
                ir = mtm.readInputRegisters(unitid, ref, count);
                //System.out.println("ir.length = " + ir.length);

             // 0:냉방 18:난방 36:급탕 54:환기 72:조명 90:콘센트
                
                for (int n = 0; n < ir.length; n++) {
                	
                	if (rs.getString("C_IPADDRESS").equals("10.1.1.2") ){ // 4층
                    	if ( n==0 || n==9 || n==18 || n==27 || n==36 || n==45 || n==54 || n==63 || n==72 || n==81 || n==90 || n==99 || n==108 ) 
                    	{
                    		String roof = "";
                    		switch(n){
                    		case 0: roof="1"; break; case 9: roof="2";break;
                    		case 18: roof="3";break; case 27: roof="4";break;
                    		case 36: roof="5";break; case 45: roof="6";break;
                    		case 54: roof="7";break; case 63: roof="8";break;
                    		case 72: roof="9";break; case 81: roof="10";break;
                    		case 90: roof="11";break; case 99: roof="12";break;
                    		case 108: roof="13";break; case 117: roof="14";break;
                    		}

                    		//System.out.println("address " + (I + n) + " = " + ir[n].getValue() +" address " + (I + (n + 1)) + " = " + ir[n+1].getValue());
            			    val = (ir[n].getValue() << 8) + ir[n + 1].getValue();
            			    // 음수 처리를 위한 로직
            			    if (Integer.parseInt(Integer.toString(ir[n + 1].getValue())) < 0){
            			    	val = val + 255;
            			    }

            			    val = val / 10.0;
            			    double watt = getWatt(ref, count,unitid,ir, mtm, Integer.parseInt(roof) - 1);
            			    System.out.println("4Floor = " + roof + " kwh = " + val + " watt = " + watt);
                        	str = "insert into tb_rowdata(t_datetime, c_master, c_slave, i_num, i_w_now, i_kwh_now) values "
            			    		+ "(SYSTIMESTAMP,'" + rs.getString("C_MASTER").trim()+ "','" +rs.getString("C_SLAVE").trim()+"'," 
                        			+ Integer.parseInt(roof) + "," + watt  + "," + val +")";
            			    
            			    System.out.println("str : " + str);
            				
            			    ps = conn.prepareStatement(str);
            				ps.executeQuery();
            				ps.close();
                    	}                		
                	}
                	else if( rs.getString("C_IPADDRESS").equals("10.1.1.6") || rs.getString("C_IPADDRESS").equals("10.1.1.9")){ //  6층
                    	if ( n==0 || n==9 || n==18 || n==27 || n==36 || n==45 || n==54 || n==63 || n==72 || n==81 || n==90 || n==99 || n==108 || n==117) 
                    	{
                    		String roof = "";
                    		switch(n){
                    		case 0: roof="1"; break; case 9: roof="2";break;
                    		case 18: roof="3";break; case 27: roof="4";break;
                    		case 36: roof="5";break; case 45: roof="6";break;
                    		case 54: roof="7";break; case 63: roof="8";break;
                    		case 72: roof="9";break; case 81: roof="10";break;
                    		case 90: roof="11";break; case 99: roof="12";break;
                    		case 108: roof="13";break; case 117: roof="14";break;
                    		}

                    		//System.out.println("address " + (I + n) + " = " + ir[n].getValue() +" address " + (I + (n + 1)) + " = " + ir[n+1].getValue());
            			    val = (ir[n].getValue() << 8) + ir[n + 1].getValue();
            			    // 음수 처리를 위한 로직
            			    if (Integer.parseInt(Integer.toString(ir[n + 1].getValue())) < 0){
            			    	val = val + 255;
            			    }

            			    val = val / 10.0;
            			    double watt = getWatt(ref, count,unitid,ir, mtm, Integer.parseInt(roof) - 1);

            			    if( rs.getString("C_IPADDRESS").equals("10.1.1.6")){
            			    	System.out.println("5Floor = " + roof + " kwh = " + val + " watt = " + watt);
            			    }else{
            			    	System.out.println("6Floor = " + roof + " kwh = " + val + " watt = " + watt);
            			    }

                        	str = "insert into tb_rowdata(t_datetime, c_master, c_slave, i_num, i_w_now, i_kwh_now) values "
            			    		+ "(SYSTIMESTAMP,'" + rs.getString("C_MASTER").trim()+ "','" +rs.getString("C_SLAVE").trim()+"'," 
                        			+ Integer.parseInt(roof) + "," + watt  + "," + val +")";
            			    
            			    System.out.println("str : " + str);
            				
            			    ps = conn.prepareStatement(str);
            				ps.executeQuery();
            				ps.close();

                    	}                		
                	}
                	else if(rs.getString("C_IPADDRESS").equals("10.1.1.11") || rs.getString("C_IPADDRESS").equals("10.1.1.13")){ // 7층 8층
                    	if (n==0 || n==9 || n==18 || n==27 || n==36 || n==45 || n==54 || n==63 || n==72 || n==81 || n==90 || n==99 || n==108 || n==117 || n==126) 
                    	{
                    		String roof = "";
                    		switch(n){
                    		case 0: roof="1"; break; case 9: roof="2";break;
                    		case 18: roof="3";break; case 27: roof="4";break;
                    		case 36: roof="5";break; case 45: roof="6";break;
                    		case 54: roof="7";break; case 63: roof="8";break;
                    		case 72: roof="9";break; case 81: roof="10";break;
                    		case 90: roof="11";break; case 99: roof="12";break;
                    		case 108: roof="13";break; case 117: roof="14";break;
                    		case 126: roof="15";break;
                    		}

                    		//System.out.println("address " + (I + n) + " = " + ir[n].getValue() +" address " + (I + (n + 1)) + " = " + ir[n+1].getValue());
            			    val = (ir[n].getValue() << 8) + ir[n + 1].getValue();
            			    // 음수 처리를 위한 로직
            			    if (Integer.parseInt(Integer.toString(ir[n + 1].getValue())) < 0){
            			    	val = val + 255;
            			    }

            			    val = val / 10.0;
            			    double watt = getWatt(ref, count,unitid,ir, mtm, Integer.parseInt(roof) - 1);

            			    if( rs.getString("C_IPADDRESS").equals("10.1.1.11")){
            			    	System.out.println("7Floor = " + roof + " kwh = " + val + " watt = " + watt);
            			    }else{
            			    	System.out.println("8Floor = " + roof + " kwh = " + val + " watt = " + watt);
            			    }
            			    
                        	str = "insert into tb_rowdata(t_datetime, c_master, c_slave, i_num, i_w_now, i_kwh_now) values "
            			    		+ "(SYSTIMESTAMP,'" + rs.getString("C_MASTER").trim()+ "','" +rs.getString("C_SLAVE").trim()+"'," 
                        			+ Integer.parseInt(roof) + "," + watt  + "," + val +")";
            			    
            			    System.out.println("str : " + str);
            				
            			    ps = conn.prepareStatement(str);
            				ps.executeQuery();
            				ps.close();

                    	}                		
                	}
                	else if(rs.getString("C_IPADDRESS").equals("10.1.1.15")){ // 9층
                    	if ( n==0 || n==9 || n==18 || n==27 || n==36 || n==45 || n==54 || n==63 || n==72 || n==81 || n==90 || n==99 || n==108 || n==117 || n==126) 
                    	{
                    		String roof = "";
                    		switch(n){
                    		case 0: roof="1"; break; case 9: roof="2";break;
                    		case 18: roof="3";break; case 27: roof="4";break;
                    		case 36: roof="5";break; case 45: roof="6";break;
                    		case 54: roof="7";break; case 63: roof="8";break;
                    		case 72: roof="9";break; case 81: roof="10";break;
                    		case 90: roof="11";break; case 99: roof="12";break;
                    		case 108: roof="13";break; case 117: roof="14";break;
                    		case 126: roof="15";break;
                    		}

                    		//System.out.println("address " + (I + n) + " = " + ir[n].getValue() +" address " + (I + (n + 1)) + " = " + ir[n+1].getValue());
            			    val = (ir[n].getValue() << 8) + ir[n + 1].getValue();
            			    // 음수 처리를 위한 로직
            			    if (Integer.parseInt(Integer.toString(ir[n + 1].getValue())) < 0){
            			    	val = val + 255;
            			    }

            			    val = val / 10.0;
            			    double watt = getWatt(ref, count,unitid,ir, mtm, Integer.parseInt(roof) - 1);
            			    System.out.println("9floor = " + roof + " kwh = " + val + " watt = " + watt);

                        	str = "insert into tb_rowdata(t_datetime, c_master, c_slave, i_num, i_w_now, i_kwh_now) values "
            			    		+ "(SYSTIMESTAMP,'" + rs.getString("C_MASTER").trim()+ "','" +rs.getString("C_SLAVE").trim()+"'," 
                        			+ Integer.parseInt(roof) + "," + watt  + "," + val +")";
            			    
            			    System.out.println("str : " + str);
            				
            			    ps = conn.prepareStatement(str);
            				ps.executeQuery();
            				ps.close();

                    	}                		
                	}
                	else if(rs.getString("C_IPADDRESS").equals("10.1.1.17")){ //10층
                    	if ( n==0 || n==9 || n==18 || n==27 || n==36 || n==45 || n==54 || n==63 || n==72 || n==81 || n==90 || n==99 || n==108 
                    		|| n==117 || n==126 || n==135 || n==144 || n==153 || n==162) 
                    	{
                    		String roof = "";
                    		switch(n){
                    		case 0: roof="1"; break; case 9: roof="2";break;
                    		case 18: roof="3";break; case 27: roof="4";break;
                    		case 36: roof="5";break; case 45: roof="6";break;
                    		case 54: roof="7";break; case 63: roof="8";break;
                    		case 72: roof="9";break; case 81: roof="10";break;
                    		case 90: roof="11";break; case 99: roof="12";break;
                    		case 108: roof="13";break; case 117: roof="14";break;
                    		case 126: roof="15";break;case 135: roof="16";break;
                    		case 144: roof="17";break;case 153: roof="18";break;
                    		case 162: roof="19";break;
                    		}

                    		//System.out.println("address " + (I + n) + " = " + ir[n].getValue() +" address " + (I + (n + 1)) + " = " + ir[n+1].getValue());
            			    val = (ir[n].getValue() << 8) + ir[n + 1].getValue();
            			    // 음수 처리를 위한 로직
            			    if (Integer.parseInt(Integer.toString(ir[n + 1].getValue())) < 0){
            			    	val = val + 255;
            			    }

            			    val = val / 10.0;
            			    double watt = getWatt(ref, count,unitid,ir, mtm, Integer.parseInt(roof) - 1);
            			    System.out.println("10floor = " + roof + " kwh = " + val + " watt = " + watt);

            			    str = "insert into tb_rowdata(t_datetime, c_master, c_slave, i_num, i_w_now, i_kwh_now) values "
            			    		+ "(SYSTIMESTAMP,'" + rs.getString("C_MASTER").trim()+ "','" +rs.getString("C_SLAVE").trim()+"'," 
                        			+ Integer.parseInt(roof) + "," + watt  + "," + val +")";
            			    
            			    System.out.println("str : " + str);
            				
            			    ps = conn.prepareStatement(str);
            				ps.executeQuery();
            				ps.close();

                    	}                		
                	}
                }         
                
                
	            mtm.disconnect();
			}
	    	
			rs.close();
			
			conn.commit();
			conn.close();
			
		}catch (Exception ex) {
			ex.printStackTrace();
			System.exit(0);
		}
	}

	private static String getHexToDec(String hex) {
		   long v = Long.parseLong(hex, 16);   
		   return String.valueOf(v);
	}

	private static String getDecToHex(String dec){
	    
		  Long intDec = Long.parseLong(dec);
		  return Long.toHexString(intDec).toUpperCase();
	}
	
	private static double getWatt(int ref, int count,int unitid,InputRegister[] ir, ModbusTCPMaster mtm, int addr){
		double val = 0;
        String[] mapaddr = {"0974", "09B4", "09F4", "0A34", "0A74", "0AB4","0AF4","0B34","0B74","0BB4","0BF4","0C34","0C74","08CC" ,"08F4"};

        ref = Integer.parseInt(mapaddr[addr], 16); // Address : 2420 부터 각 포인트에 대한 현재 Watt를 구한다.
        count = 32;
        String decref = getHexToDec(mapaddr[addr]);
        int k = Integer.parseInt(decref);
        
        try {
			ir = mtm.readInputRegisters(unitid, ref, count);
		} catch (ModbusException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        
        for (int n = 0; n < ir.length; n++) {
        	
        	if (n == 4){ // 현재 Watt 값을 가져온다.

        		String num = String.format("%.2f" , (double)((ir[n].getValue() << 8) + ir[n + 1].getValue()));
        		if (num.length() > 8){
        			num = num.substring(0, 5);
        		}
        		
        		val = Double.parseDouble(num);

			    // 음수 처리를 위한 로직
			    if (Integer.parseInt(Integer.toString(ir[n + 1].getValue())) < 0){
			    	val = val + 255;
			    }
        	}
        }

/*        for (int v=0; v<mapaddr.length; v++){
        	ref = Integer.parseInt(mapaddr[v], 16); // Address : 2420 각 포인트에 대한 현재 Watt를 구한다.
        	count = 32;
        	String decref = getHexToDec(mapaddr[v]);
        	int k = Integer.parseInt(decref);

            try {
				ir = mtm.readInputRegisters(unitid, ref, count);
			} catch (ModbusException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
            
            for (int n = 0; n < ir.length; n++) {
            	
            	if (n == 4){ // 현재 Watt 값을 가져온다.

            		String num = String.format("%.2f" , (double)((ir[n].getValue() << 8) + ir[n + 1].getValue()));
            		System.out.println(num);
            		val = Double.parseDouble(num);
    			    //val = (ir[n].getValue() << 8) + ir[n + 1].getValue();
    			    // 음수 처리를 위한 로직
    			    if (Integer.parseInt(Integer.toString(ir[n + 1].getValue())) < 0){
    			    	val = val + 255;
    			    }
    			    

            	}

            }
        }*/
        
		return val;

	}
}
