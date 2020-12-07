package com.ean.quartz;
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

import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.springframework.scheduling.quartz.QuartzJobBean;

import com.ean.db.DBservice;
import com.ean.batch.ModbusTCPMaster;

import net.wimpi.modbus.procimg.InputRegister;

public class CronQuartz extends QuartzJobBean{
		
	@Override
	protected void executeInternal(JobExecutionContext arg0) throws JobExecutionException {
		
		DBservice dbservice = new DBservice();
		Connection            conn = null;
		PreparedStatement     ps   = null;
		ResultSet             rs   = null;
				
	    long time = System.currentTimeMillis();
	    SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd HH:mm:ss");
	    System.out.println("Cron trigger 1 (5 second): current time = " + sdf.format(time));

	    List<Map> listeps = new ArrayList();
	    List<Map> listco2 = new ArrayList();
	    
	    try {
	    	// DB 에서 장비의 리스트와 정보를 읽어온다
	    	conn = dbservice.getConnection();
	    	conn.setAutoCommit(false);
	    	
	    	String str = "select * from TB_DEVICE WHERE C_MASTER='0' and ";
	    	str += "( c_slave not in ('15','16','17','18','19') ) and c_ipaddress not in ('10.1.1.18', '10.1.1.16', '10.1.1.4')";
	    	ps = conn.prepareStatement(str);
	    	rs = ps.executeQuery();
	    	
			while(rs.next()){
			    Map<String, String> eps = new HashMap();
			    Map<String, String> co2 = new HashMap();
			    
				//System.out.println(rs.getString(1) + " " + rs.getString(2)+ " " + rs.getString(3) + " " + rs.getString(4)+ " " + rs.getString(5));
				
				// LIST 에 저장함
				if (rs.getString(3).indexOf("CO2") > 0){
					co2.put("master", rs.getString(1));
					co2.put("slave", rs.getString(2));
					co2.put("ip", rs.getString(5));
					co2.put("port", rs.getString(6));
					listco2.add(co2);
				}
				else{
					eps.put("master", rs.getString(1));
					eps.put("slave", rs.getString(2));
					eps.put("ip", rs.getString(5));
					eps.put("port", rs.getString(6));
					listeps.add(eps);
				}
			}
			
			rs.close();
			
			/* 임시 막기 시작
			//EPS  데이터 수집
			for (int i=0; i<listeps.size(); i++){
				double[][] gData = new double[6][2];
				
				int cnt = 1; //loop count
				int ref = 0;
				int count = 0;
				int unitid = 1;
				InputRegister[] ir = null;
				double val = 0;
				
				String map1 = listeps.get(i).toString();
				map1 = map1.substring(1, map1.length() -1);
				System.out.println(map1);
				
				String[] values = map1.split(",");
				String[] port = values[0].split("=");
				String[] slave = values[1].split("=");
				String[] master = values[2].split("=");
				String[] ip = values[3].split("=");
				
				System.out.println(master[1]);
				System.out.println(slave[1]);
				System.out.println(ip[1]);
				System.out.println(Integer.parseInt(port[1].trim()));
				
				// modbusTCP의 기본 포트는 502번이므로 포트 설정을 따로 던지지 않아도 502번을 기본적으로 세팅하도록 되어있다.
				// 이 프로그램에선 일관성을 유지하기 위해 포트를 그대로 넣도록 한다.
				
				ModbusTCPMaster mtm = new ModbusTCPMaster(ip[1], Integer.parseInt(port[1].trim()));
	            mtm.connect();
	            
	            ref = Integer.parseInt("1F40", 16); // Address : 8000
	            count = 108;
	            
	            String decref = getHexToDec("1F40");

	            i = Integer.parseInt(decref); 
	            
	            cnt = 1; //loop count
	            System.out.println("Start Address = " + String.valueOf(i) + "\n");
//	            while(cnt < 2){
                
	            ir = null;
                String sref = getDecToHex(String.valueOf(i));
                ref = Integer.parseInt(sref, 16);
                
                System.out.println("Fuction Code = 04 \n");
                
                ir = mtm.readInputRegisters(unitid, ref, count);

                System.out.println("Address =" + String.valueOf(i));
                
                for (int n = 0; n < ir.length; n++) {
                	// 0:냉방 18:난방 36:급탕 54:환기 72:조명 90:콘센트 
                	if (n==0 || n==18 || n==36 || n==54 || n==72 || n==90) {
                		String roof = "";
                		switch(n){
                		case 0: roof="1"; break;
                		case 18: roof="2";break;
                		case 36: roof="3";break;
                		case 54: roof="4";break;
                		case 72: roof="5";break;
                		case 90: roof="6";break;
                		}
                		System.out.println("address " + (i + n) + " = " + ir[n].getValue() +" address " + (i + (n + 1)) + " = " + ir[n+1].getValue());
        			    val = (ir[n].getValue() << 8) + ir[n + 1].getValue();
        			    // 음수 처리를 위한 로직
        			    if (Integer.parseInt(Integer.toString(ir[n + 1].getValue())) < 0){
        			    	val = val + 255;
        			    }

        			    val = val / 10.0;
        			    
        			    gData[Integer.parseInt(roof) - 1][1] = val;
                	}
                	
                }         
                
//                i = i - count;
//                cnt++;

                String[] mapaddr = {"0974", "0B94", "09F4", "0A34", "0A74", "0AB4"};

                for (int v=0; v<mapaddr.length; v++){
                	ref = Integer.parseInt(mapaddr[v], 16); // Address : 2420 각 포인트에 대한 현재 Watt를 구한다.
                	count = 32;
                	decref = getHexToDec(mapaddr[v]);
                	int k = Integer.parseInt(decref);

                    ir = mtm.readInputRegisters(unitid, ref, count);
                    
                    for (int n = 0; n < ir.length; n++) {
                    	
                    	if (n == 4){ // 현재 Watt 값을 가져온다.
                    		System.out.println("address " + (k + n) + " = " + ir[n].getValue());
                    		System.out.println("address " + (k + (n + 1)) + " = " + ir[n + 1].getValue());
            			    val = (ir[n].getValue() << 8) + ir[n + 1].getValue();
            			    // 음수 처리를 위한 로직
            			    if (Integer.parseInt(Integer.toString(ir[n + 1].getValue())) < 0){
            			    	val = val + 255;
            			    }
            			    
            			    gData[v][0] = val;
                    	}

                    }
                }
                
                for (int v=0; v<6; v++){

    			    str = "insert into tb_history(t_datetime, c_master, c_slave, i_w_now, i_kwh_now) values "
    			    		+ "(SYSTIMESTAMP,'" + slave[1] + "','"+(v+1)+"'," + gData[v][0] + "," + gData[v][1] +")";
    			    
    			    System.out.println("str : " + str);
    				
    			    ps = conn.prepareStatement(str);
    				ps.executeQuery();
    				ps.close();
                }
                
	            mtm.disconnect();
			}
			
			== 임시 막기 */
			
			// Co2, 온도 습도  데이터 수집
			for (int i=0; i<listco2.size(); i++){
				byte[] message = new byte[8];
				message[0] = 0x01;
				message[1] = 0x03;
				message[2] = 0x00;
				message[3] = 0x65;
				message[4] = 0x00;
				message[5] = 0x05;
				message[6] = (byte) 0x95;
				message[7] = (byte) 0xd6;
				
				String map1 = listco2.get(i).toString();
				map1 = map1.substring(1, map1.length() -1);
				System.out.println(map1);
				
				String[] values = map1.split(",");
				String[] port = values[0].split("=");
				String[] slave = values[1].split("=");
				String[] master = values[2].split("=");
				String[] ip = values[3].split("=");
				
				System.out.println(master[1]);
				System.out.println(slave[1]);
				System.out.println(ip[1]);
				System.out.println(Integer.parseInt(port[1].trim()));
				Socket s = null;
				DataOutputStream dOut;
				DataInputStream dIn = null;
				try{
					s = new Socket(ip[1].trim(), Integer.parseInt(port[1].trim()));
					Thread.sleep(3000);
					dOut = new DataOutputStream(s.getOutputStream());
					dIn = new DataInputStream(s.getInputStream());

					dOut.write(message);           // write the message
					
					Thread.sleep(6000);
					
					// Timeout 설정 10초
				    try{
				    	s.setSoTimeout(10000);
				    }catch(Exception e){
				    	System.out.println("RsSocket: readMsg setSoTimeout 생성 오류");
				    	e.printStackTrace();
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

				    System.out.println("온도 : " + per1);

				    double val2 = (buffer[7] << 8) + buffer[8];

				    // 음수 처리를 위한 로직
				    if (Integer.parseInt(Integer.toString(buffer[8])) < 0){
				    	val2 = val2 + 255;
				    }

				    val2 = val2 / 10.1;
				    double per2 = Double.parseDouble(String.format("%.1f",val2));

				    System.out.println("습도 : " + per2);
				    
				    str = "insert into tb_co2(t_datetime, c_master, c_slave, I_CO2, I_TEMP, I_HUMI) values " + 
				    		"(SYSTIMESTAMP,'" + master[1] + "','" + slave[1] + "'," + val + "," + per1 + "," + per2 + ")";
				    
				    System.out.println("str : " + str);
					
				    ps = conn.prepareStatement(str);
					ps.executeQuery();
					ps.close();
					
					dIn.close();
					s.close();		
				}catch (Exception ex) {
					ex.printStackTrace();
					
					dIn.close();
					s.close();		
				}
	
			}
			
			conn.commit();
			conn.close();

			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
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
}
