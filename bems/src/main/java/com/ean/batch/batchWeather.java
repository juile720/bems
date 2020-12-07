package com.ean.batch;

import java.io.IOException;
import java.net.URL;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import com.ean.db.DBservice;

public class batchWeather {

	public static void main(String[] args) throws IOException {
		// TODO Auto-generated method stub

		DBservice dbservice = new DBservice();
		Connection            conn = null;
		PreparedStatement     ps   = null;
		conn = dbservice.getConnection();
		
		try{
			
			URL url = new URL("http://api.wunderground.com/api/f63368dd321cbf33/geolookup/conditions/lang:KR/q/Korea/Seoul.xml");

            DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
            DocumentBuilder db = dbf.newDocumentBuilder(); //XML문서 빌더 객체를 생성
            Document doc = db.parse(new InputSource(url.openStream())); //XML문서를 파싱한다.
            doc.getDocumentElement().normalize();
            
            NodeList nodeList = doc.getElementsByTagName("current_observation");
			String temp = null;
			String humi = null;
			String namet = null;
			
            for(int i = 0; i< nodeList.getLength(); i++){
                if (i == 0) {
                    Node node = nodeList.item(i); //data엘리먼트 노드
                    Element fstElmnt = (Element) node;
                    NodeList nameList  = fstElmnt.getElementsByTagName("temp_c");
                    Element nameElement = (Element) nameList.item(0);
                    nameList = nameElement.getChildNodes();
                    temp =  ((Node) nameList.item(0)).getNodeValue() ;

                    NodeList websiteList = fstElmnt.getElementsByTagName("icon"); 
                    namet = websiteList.item(0).getChildNodes().item(0).getNodeValue();
                    
                    NodeList websiteList1 = fstElmnt.getElementsByTagName("relative_humidity"); 
                    humi = websiteList1.item(0).getChildNodes().item(0).getNodeValue();
                    humi = humi.substring(0, humi.length() -1);
                    System.out.println("temp - " + temp + " weather - " + namet + " humi - " + humi); 
                    
                	String str = "insert into TB_TEMPERATURE(t_datetime, i_temp, i_humi, c_condition) values "
    			    		+ "(SYSTIMESTAMP," +  temp  + "," + humi +",'" + namet + "')";
    			    
    			    System.out.println("str : " + str);
    				
    			    ps = conn.prepareStatement(str);
    				ps.executeQuery();
    				ps.close();
                }
                
            }
			conn.close();
			
		}catch(Exception e){
			e.printStackTrace();
			System.exit(0);
		}

		System.exit(0);
	}
	
}
