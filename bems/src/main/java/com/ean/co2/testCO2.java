package com.ean.co2;

import java.io.DataOutputStream;
import java.io.DataInputStream;
import java.io.IOException;
import java.net.Socket;
import java.nio.DoubleBuffer;

public class testCO2 {
	
	
	public static void main(String argc[]) throws IOException, Exception{
		try 
		{
			//String result = "";
			byte[] message = new byte[8];
			message[0] = 0x01;
			message[1] = 0x03;
			message[2] = 0x00;
			message[3] = 0x65;
			message[4] = 0x00;
			message[5] = 0x05;
			message[6] = (byte) 0x95;
			message[7] = (byte) 0xd6;
			
			Socket s = new Socket("10.1.1.4", 5000);
			
			
			Thread.sleep(10000);
			
			DataOutputStream dOut = new DataOutputStream(s.getOutputStream());
			DataInputStream dIn = new DataInputStream(s.getInputStream());

			dOut.write(message);           // write the message
			
			Thread.sleep(10000);
			
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
			        	System.exit(0);
			        }
		    	}catch(Exception ee){
		    		System.out.println("RsSocket: readMsg Exception common header read");
		    		ee.printStackTrace();
		    		System.exit(0);
		    	}
		        wanted -= len;
		        offset += len;
		        totlen += len;
		    }
		    System.out.println(dIn.read( buffer, offset, wanted ));
		    int val = (buffer[3] << 8) + buffer[4];
		    
		    // 음수 처리를 위한 로직
		    if (Integer.parseInt(Integer.toString(buffer[4])) < 0){
		    	val = val + 255;
		    }
		    
		    System.out.println("co2 : " + val);
		    
		    double val1 = (buffer[5] << 8) + buffer[6];
		    
		    // 음수 처리를 위한 로직
		    if (Integer.parseInt(Integer.toString(buffer[6])) < 0){
		    	val1 = val1 + 255;
		    }
		    
		    val1 = val1 / 10.1;
		    double per = Double.parseDouble(String.format("%.1f",val1));

		    System.out.println("온도 : " + per);

		    double val2 = (buffer[7] << 8) + buffer[8];

		    // 음수 처리를 위한 로직
		    if (Integer.parseInt(Integer.toString(buffer[8])) < 0){
		    	val2 = val2 + 255;
		    }

		    val2 = val2 / 10.1;
		    per = Double.parseDouble(String.format("%.1f",val2));

		    System.out.println("습도 : " + per);
		
		    

			dIn.close();
			s.close();			
		}catch (Exception ex) {
			ex.printStackTrace();
			System.exit(0);
		}
	}

}
