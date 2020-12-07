package com.ean.batch;
import java.io.*;

import net.wimpi.modbus.msg.*;
import net.wimpi.modbus.io.*;
import net.wimpi.modbus.net.*;
import net.wimpi.modbus.procimg.InputRegister;
import net.wimpi.modbus.procimg.Register;

import com.ean.batch.ModbusTCPMaster;
import com.ean.db.*;

public class modbus {
	static TCPMasterConnection connection;
	static ModbusTCPTransaction transaction = null; //the transaction
	static ReadInputDiscretesRequest request = null; //the request
	static ReadInputDiscretesResponse response = null; //the response
	
	public static void main(String argc[]) throws IOException{
		try 
		{
			File file = new File("C:\\A project\\log.txt");
			PrintStream printStream = new PrintStream(new FileOutputStream(file));

			PrintStream sysout = System.out;
			// standard out과 err을 file로 변경
			System.setOut(printStream);
			System.setErr(printStream);

			int cnt = 1; //loop count
			int ref = Integer.parseInt("0091", 16);
			int count = 2;
			int unitid = 1;
			InputRegister[] ir = null;
			
			ModbusTCPMaster mtm = new ModbusTCPMaster("10.1.1.2");
            mtm.connect();
            
            
            Register[] rg = mtm.readMultipleRegisters(unitid, ref, count);
            
            System.out.println("Register=" + rg.length);
            
            for (int n = 0; n < rg.length; n++) {
            	
            	System.out.println("reg = "+ rg[n].toUnsignedShort() + " DEC " + n + "=" + rg[n].getValue());
            }

            ref = Integer.parseInt("08FC", 16); // Address = 2300
            count = 120;
            
            /*
             *  시작주소에서 count 만큼을 뺀다.
             *  루프를 돌아서 주소가 0이 되기 전까지 계속 어드레스에서 읽어 오도록 한다
             *  Address 2300 : 1 : Operation Heartbit
             *                 2 : Temperature
             *                 3 : Frequency
             *                 4 : Program Version
             *                 5 : Present Co2 use
             *                 6 : Reserved
             */
            
            System.out.println("Fuction Code = 04 \n");
            ir = mtm.readInputRegisters(unitid, ref, count);

            System.out.println("Address =" + getHexToDec("08FC") + "\n");
            
            for (int n = 0; n < ir.length; n++) {
            	switch(n){
            	case 0 : System.out.println("Operation Heartbit " + (n + 1) + "=" + ir[n].getValue());
            	break;
            	case 1 : System.out.println("Temperature " + (n + 1) + "=" + ir[n].getValue());
            	break;
            	case 2 : System.out.println("Frequency " + (n + 1) + "=" + ir[n].getValue());
            	break;
            	case 3 : System.out.println("Program Version " + (n + 1) + "=" + ir[n].getValue());
            	break;
            	case 4 : System.out.println("Present Co2 use " + (n + 1) + "=" + ir[n].getValue());
            	break;
            	case 5 : System.out.println("Reserved " + (n + 1) + "=" + ir[n].getValue());
            	break;
            	default : System.out.println("Word " + (n + 1) + "=" + ir[n].getValue());
            	}
            	
            	//System.out.println("Word " + n + "=" + ir[n].getValue());
            }

            /*
             *  시작주소에서 count 만큼을 뺀다.
             *  루프를 돌아서 주소가 0이 되기 전까지 계속 어드레스에서 읽어 오도록 한다
             *  
             */
            
            ref = Integer.parseInt("0870", 16);
            count = 120;
            
            String decref = getHexToDec("0870");

            int i = Integer.parseInt(decref); 
            System.out.println("!!!!!!!!!!!!!!!Start Address= " + String.valueOf(i) + "\n");
            while(i >=0){
                ir = null;
                String sref = getDecToHex(String.valueOf(i));
                ref = Integer.parseInt(sref, 16);
                
                System.out.println("Fuction Code = 04 \n");
                
                ir = mtm.readInputRegisters(unitid, ref, count);

                System.out.println("ADDRESS =" + String.valueOf(i));
                
                for (int n = 0; n < ir.length; n++) {
                	System.out.println("address " + (i + n) + " = " + ir[n].getValue() + " number - " + (n + 1));                
                }         
                
                i = i - count;
            }

            /*
             * 위의 루틴이 끝나면 다시 주소를 입력 한 후 64 바이트씩 읽어들이도록 한다.
             * 이 아래에 for 문으로 넣어줄것  
             * 
             */
            
            ref = Integer.parseInt("16B4", 16); // Address : 5812
            count = 64;
            cnt = 1; //loop count
            decref = getHexToDec("16B4");

            i = Integer.parseInt(decref); 
            System.out.println("Start Address = " + String.valueOf(i) + "\n");
            while(cnt <= 54){
                ir = null;
                String sref = getDecToHex(String.valueOf(i));
                ref = Integer.parseInt(sref, 16);
                
                System.out.println("Fuction Code = 04 \n");
                
                ir = mtm.readInputRegisters(unitid, ref, count);

                System.out.println("Address = " + String.valueOf(i) + " cnt = " + cnt);
                
                for (int n = 0; n < ir.length; n++) {
                	System.out.println("address " + (i + n) + " = " + ir[n].getValue() + " number - " + (n + 1));
                }         
                
                i= i - count;
                cnt++;
            }
            
            /*
             * 
             */
            
            ref = Integer.parseInt("22A0", 16); // Address : 8864
            count = 108;
            
            decref = getHexToDec("22A0");

            i = Integer.parseInt(decref); 
            
            cnt = 1; //loop count
            System.out.println("Start Address = " + String.valueOf(i) + "\n");
            while(cnt < 10){
                ir = null;
                String sref = getDecToHex(String.valueOf(i));
                ref = Integer.parseInt(sref, 16);
                
                System.out.println("Fuction Code = 04 \n");
                
                ir = mtm.readInputRegisters(unitid, ref, count);

                System.out.println("Address =" + String.valueOf(i));
                
                for (int n = 0; n < ir.length; n++) {
                	System.out.println("address " + (i + n) + " = " + ir[n].getValue());
                }         
                
                i= i - count;
                cnt++;
            }
            
            
            /*
             * 
             */
            
            ref = Integer.parseInt("1E36", 16); // Address : 7734
            count = 102;
            
            decref = getHexToDec("1E36");

            i = Integer.parseInt(decref); 
            
            cnt = 1; //loop count
            System.out.println("Start Address= " + String.valueOf(i) + "\n");
            while(cnt < 19){
                ir = null;
                String sref = getDecToHex(String.valueOf(i));
                ref = Integer.parseInt(sref, 16);
                System.out.println("Fuction Code = 04 \n");
                
                ir = mtm.readInputRegisters(unitid, ref, count);

                System.out.println("Address =" + String.valueOf(i));
                
                for (int n = 0; n < ir.length; n++) {
                	System.out.println("address " + (i + n) + " = " + ir[n].getValue());
                }         
                
                i= i - count;
                cnt++;
            }
            
            
            /*
             * 
             */
            
            ref = Integer.parseInt("08FC", 16); // Address : 2300
            count = 120;
            
            decref = getHexToDec("08FC");

            i = Integer.parseInt(decref); 
            
            cnt = 1; //loop count
            System.out.println("Start Address= " + String.valueOf(i) + "\n");
            while(i >= 0){
                ir = null;
                String sref = getDecToHex(String.valueOf(i));
                ref = Integer.parseInt(sref, 16);
                
                System.out.println("Fuction Code = 04 \n");
                
                ir = mtm.readInputRegisters(unitid, ref, count);

                System.out.println("Address =" + String.valueOf(i));
                
                for (int n = 0; n < ir.length; n++) {
                	System.out.println("address " + (i + n) + " = " + ir[n].getValue());
                }         

                if (cnt==1){
                	i = i - 140;
                }else
                {
                	i= i - count;	
                }
                
                cnt++;
            }
            
            mtm.disconnect();
            
            printStream.close();
		} catch (Exception ex) {
		ex.printStackTrace();
		}
		System.out.println("Finished");
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
