package com.ean.co2;

import java.io.IOException;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.net.Socket;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.ean.db.DBservice;

public class batchCO2 {

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
	    	
	    	String str = "select * from tb_device where c_name like '%CO2%' "
	    			+ "and c_ipaddress not in ('10.1.1.8' , '10.1.1.10', '10.1.1.14', '10.1.1.16','10.1.1.18')";

	    	ps = conn.prepareStatement(str);
	    	rs = ps.executeQuery();
	    	
			while(rs.next()){
				Socket s = null;
				DataOutputStream dOut;
				DataInputStream dIn = null;
				
				byte[] message = new byte[8];
				message[0] = 0x01;
				message[1] = 0x03;
				message[2] = 0x00;
				message[3] = 0x65;
				message[4] = 0x00;
				message[5] = 0x05;
				message[6] = (byte) 0x95;
				message[7] = (byte) 0xd6;
				
				try{
					s = new Socket(rs.getString("C_IPADDRESS").trim(), Integer.parseInt(rs.getString("C_PORT").trim()));
					Thread.sleep(10000);
					dOut = new DataOutputStream(s.getOutputStream());
					dIn = new DataInputStream(s.getInputStream());

					dOut.write(message);           // write the message
					
					Thread.sleep(10000);
					
					// Timeout 설정 10초
				    try{
				    	s.setSoTimeout(15000);
				    }catch(Exception e){
				    	System.out.println("RsSocket: readMsg setSoTimeout 생성 오류");
				    	e.printStackTrace();
				    	rs.close();
						conn.close();

						dIn.close();
						s.close();
						System.exit(0);				    	
				    }
				    
					int offset = 0;
				    int wanted = 10;
				    int len=0;
				    int totlen=0;
				    
					byte[] buffer = new byte[20];
					
				    while( wanted > 0 )
				    {
				    	try{
				    		len = dIn.read( buffer, offset, wanted );     
					        if( len == -1 )
					        {
					        	System.out.println("RsSocket: readMsg common header read");
					        }
				    	}catch(Exception ee){
				    		System.out.println("RsSocket: readMsg Exception common header read");
				    		ee.printStackTrace();
					    	rs.close();
							conn.close();

							dIn.close();
							s.close();
							System.exit(0);				    	
				    	}
				        wanted -= len;
				        offset += len;
				        totlen += len;
				    }
				    
				    int val = (buffer[3] << 8) + buffer[4];
				    
				    // 음수 처리를 위한 로직
				    if (Integer.parseInt(Integer.toString(buffer[4])) < 0){
				    	val = val + 255;
				    }
				    System.out.println("CO2 : " + val);
				    
				    double val1 = (buffer[5] << 8) + buffer[6];
				    
				    // 음수 처리를 위한 로직
				    if (Integer.parseInt(Integer.toString(buffer[6])) < 0){
				    	val1 = val1 + 255;
				    }
				    
				    val1 = val1 / 10.1;
				    double per1 = Double.parseDouble(String.format("%.1f",val1));

				    System.out.println("temp : " + per1);

				    double val2 = (buffer[7] << 8) + buffer[8];

				    // 음수 처리를 위한 로직
				    if (Integer.parseInt(Integer.toString(buffer[8])) < 0){
				    	val2 = val2 + 255;
				    }

				    val2 = val2 / 10.1;
				    double per2 = Double.parseDouble(String.format("%.1f",val2));

				    System.out.println("humi : " + per2);
				    
				    str = "insert into tb_co2(t_datetime, c_master, c_slave, I_CO2, I_TEMP, I_HUMI) values " + 
				    		"(SYSTIMESTAMP,'" + rs.getString("C_MASTER").trim() + "','" + rs.getString("C_SLAVE").trim() + "'," + val + "," + per1 + "," + per2 + ")";
				    
				    System.out.println("str : " + str);
					
				    ps = conn.prepareStatement(str);
					ps.executeQuery();
					ps.close();
					
					dIn.close();
					s.close();		
					
					Thread.sleep(3000);
				    
				}catch (Exception ex) {
					ex.printStackTrace();

					rs.close();
					
					conn.commit();
					conn.close();

					dIn.close();
					s.close();
					System.exit(0);
				}
				
				
			}
			rs.close();
			
			conn.commit();
			conn.close();
			
		}catch (Exception ex) {
			ex.printStackTrace();
			System.exit(0);
		}
	}

}
