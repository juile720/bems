package com.ean.graph.service;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import com.ean.graph.controller.SeriesBean;
import com.ean.graph.controller.dataVO;
import com.ean.service.CommonService;
import com.ean.util.CommonUtils;

@Service
public class ChartService {
	Logger log = Logger.getLogger(this.getClass());
	
	@Resource(name="commonService")
	private CommonService commonService;
	
	/*
	 * 건물전체 상위 그래프 데이터
	 */
	public dataVO getTotalPageTopGraph(){

		String sqlid = "data.getTopGraph_year";
		
		double[] dat = null;
		
		List<SeriesBean> list = new ArrayList<SeriesBean>();
		
    	List<String> y1 = new ArrayList<String>(); // y값 전기
    	List<String> y2 = new ArrayList<String>(); // y값 가스
    	List<String> y3 = new ArrayList<String>(); // y값 유류
    	
    	String[] categories = null; // x값
    	
    	// map은 빈칸으로 채워 넣는다.. 일단은..... 나중에 값이 들어가야 하는..
		Map<String,Object> map = new HashMap<String,Object>();
		
		try {
			List<Map<String, Object>> glist = commonService.selectlist(map, sqlid);

			for (int i=0; i<glist.size(); i++){
        		Map<String, Object> mapVal = glist.get(i);
        		
        		if (mapVal.get("GUBUN").toString().equals("E")){
        			y1.add(String.valueOf(mapVal.get("I_USE")));
        		}else if (mapVal.get("GUBUN").toString().trim().equals("G")){
        			y2.add(String.valueOf(mapVal.get("I_USE")));
        		}else if (mapVal.get("GUBUN").toString().trim().equals("W")){
        			y3.add(String.valueOf(mapVal.get("I_USE")));
        		}
        	}        		
    		categories = new String[]{ "Jan", "Feb", "Mar", "Apr", "May", 
    				"Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};
    		
    		dat = new double[y1.size()];

       		for (int y=0; y<y1.size(); y++){
        		dat[y] = Double.parseDouble(y1.get(y));
        	}
       		
        	list.add(new SeriesBean("전기","#f5d14e","column",dat));
        	
        	dat = null;
    		dat = new double[y2.size()];

       		for (int y=0; y<y2.size(); y++){
        		dat[y] = Double.parseDouble(y2.get(y));
        	}
       		list.add(new SeriesBean("가스","#f15d45","spline",dat));
       		
       		dat = null;
    		dat = new double[y3.size()];

       		for (int y=0; y<y3.size(); y++){
        		dat[y] = Double.parseDouble(y3.get(y));
        	}
       		
       		list.add(new SeriesBean("유류","#3dddf7","spline",dat));


    	}catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return new dataVO(Arrays.asList(categories),list);
	}
	
	/*
	 * 건물전체 가운데 그래프 데이터 
	 */
	public dataVO getTotalPageMid(String gb, String day1, String day2){
		String sqlid = "";
		
		Map<String,Object> map = new HashMap<String,Object>();

		double[] dat = null;
		
		List<SeriesBean> list = new ArrayList<SeriesBean>();
		
    	List<String> y1 = new ArrayList<String>(); // y값 냉방
    	List<String> y2 = new ArrayList<String>(); // y값 난방
    	List<String> y3 = new ArrayList<String>(); // y값 급탕
    	List<String> y4 = new ArrayList<String>(); // y값 환기
    	List<String> y5 = new ArrayList<String>(); // y값 조명
    	List<String> y6 = new ArrayList<String>(); // y값 콘센트
    	
    	List<String> categories = new ArrayList<String>();
    	//String[] categories = null; // x값

    	SimpleDateFormat transFormat = new SimpleDateFormat("yyyyMMdd");
    	String BeforeDay = "";

    	try {
			if (gb.equals("1")){
				sqlid = "data.getFirstMidGraph_year";
			}else if (gb.equals("2")){
				Date DDAY = transFormat.parse(day1);
				Date yesterday = CommonUtils.getYesterday(DDAY);
				BeforeDay = transFormat.format(yesterday);
	
				sqlid = "data.getFirstMidGraph_week";
				map.put("DAY1", day1);
				map.put("DAY2", day2);
				map.put("BDAY", BeforeDay);
			}else if (gb.equals("3")){
				Date DDAY = transFormat.parse(day1);
				Date yesterday = CommonUtils.getYesterday(DDAY);
				BeforeDay = transFormat.format(yesterday);
	
				sqlid = "data.getFirstMidGraph_day";
				map.put("DAY1", day1);
				map.put("BDAY", BeforeDay);
			}
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		try {
			List<Map<String, Object>> glist = commonService.selectlist(map, sqlid);
			String x = null;
			String c_slave = null;
			double dwatt = 0.0;
			
			for (int i=0; i<glist.size(); i++){
				Map<String, Object> mapVal = glist.get(i);
				if ( i == 0 ) {
					x = mapVal.get("TIM").toString();
				}
				if (!mapVal.get("TIM").toString().equals(x)){
					categories.add(x);
					x = mapVal.get("TIM").toString();
				}
			}
			categories.add(x);

			Collections.sort(glist, new Comparator<Map<String, Object>>() {
		        @Override
		        public int compare(Map<String, Object> first, Map<String, Object> second) {
		        	return (first.get("C_REPRESENT").toString()).compareTo( second.get("C_REPRESENT").toString());
		        }
		    });
			
			for (int i=0; i<glist.size(); i++){
				Map<String, Object> mapVal = glist.get(i);
				if ( i == 0 ) {
					x = mapVal.get("TIM").toString();
					c_slave = mapVal.get("C_REPRESENT").toString();
					dwatt =  Double.parseDouble(mapVal.get("KWH").toString());
	        		if (mapVal.get("C_REPRESENT").toString().equals("R2")){
	        			y1.add(Double.toString((Double.parseDouble(mapVal.get("KWH").toString()))));
	        		}else if (mapVal.get("C_REPRESENT").toString().trim().equals("R3")){
	        			y2.add(Double.toString((Double.parseDouble(mapVal.get("KWH").toString()))));
	        		}else if (mapVal.get("C_REPRESENT").toString().trim().equals("R4")){
	        			y3.add(Double.toString((Double.parseDouble(mapVal.get("KWH").toString()))));
	        		}else if (mapVal.get("C_REPRESENT").toString().trim().equals("R5")){
	        			y4.add(Double.toString((Double.parseDouble(mapVal.get("KWH").toString()))));
	        		}else if (mapVal.get("C_REPRESENT").toString().trim().equals("R6")){
	        			y5.add(Double.toString((Double.parseDouble(mapVal.get("KWH").toString()))));
	        		}
				}
				if(!mapVal.get("TIM").toString().equals(x) && mapVal.get("C_REPRESENT").toString().equals(c_slave)){
	        		if (mapVal.get("C_REPRESENT").toString().equals("R2")){
	        			y1.add(Double.toString((Double.parseDouble(mapVal.get("KWH").toString()) - dwatt)));
	        		}else if (mapVal.get("C_REPRESENT").toString().trim().equals("R3")){
	        			y2.add(Double.toString((Double.parseDouble(mapVal.get("KWH").toString()) - dwatt)));
	        		}else if (mapVal.get("C_REPRESENT").toString().trim().equals("R4")){
	        			y3.add(Double.toString((Double.parseDouble(mapVal.get("KWH").toString()) - dwatt)));
	        		}else if (mapVal.get("C_REPRESENT").toString().trim().equals("R5")){
	        			y4.add(Double.toString((Double.parseDouble(mapVal.get("KWH").toString()) - dwatt)));
	        		}else if (mapVal.get("C_REPRESENT").toString().trim().equals("R6")){
	        			y5.add(Double.toString((Double.parseDouble(mapVal.get("KWH").toString()) - dwatt)));
	        		}
	        		x = mapVal.get("TIM").toString();
	        		dwatt =  Double.parseDouble(mapVal.get("KWH").toString());
				}else if(!mapVal.get("TIM").toString().equals(x) && !mapVal.get("C_REPRESENT").toString().equals(c_slave)){
	        		if (mapVal.get("C_REPRESENT").toString().equals("R2")){
	        			y1.add(Double.toString((Double.parseDouble(mapVal.get("KWH").toString()))));
	        		}else if (mapVal.get("C_REPRESENT").toString().trim().equals("R3")){
	        			y2.add(Double.toString((Double.parseDouble(mapVal.get("KWH").toString()))));
	        		}else if (mapVal.get("C_REPRESENT").toString().trim().equals("R4")){
	        			y3.add(Double.toString((Double.parseDouble(mapVal.get("KWH").toString()))));
	        		}else if (mapVal.get("C_REPRESENT").toString().trim().equals("R5")){
	        			y4.add(Double.toString((Double.parseDouble(mapVal.get("KWH").toString()))));
	        		}else if (mapVal.get("C_REPRESENT").toString().trim().equals("R6")){
	        			y5.add(Double.toString((Double.parseDouble(mapVal.get("KWH").toString()))));
	        		}
					x = mapVal.get("TIM").toString();
					c_slave = mapVal.get("C_REPRESENT").toString();
					dwatt =  Double.parseDouble(mapVal.get("KWH").toString());
				}
				
			}
			/*	
			}else{
				for (int i=0; i<glist.size(); i++){
	        		Map<String, Object> mapVal = glist.get(i);
	        		
	        		if (mapVal.get("C_SLAVE").toString().equals("1")){
	        			y1.add(String.valueOf(mapVal.get("WATT")));
	        		}else if (mapVal.get("C_SLAVE").toString().trim().equals("3")){
	        			y2.add(String.valueOf(mapVal.get("WATT")));
	        		}else if (mapVal.get("C_SLAVE").toString().trim().equals("4")){
	        			y3.add(String.valueOf(mapVal.get("WATT")));
	        		}else if (mapVal.get("C_SLAVE").toString().trim().equals("5")){
	        			y4.add(String.valueOf(mapVal.get("WATT")));
	        		}else if (mapVal.get("C_SLAVE").toString().trim().equals("6")){
	        			y5.add(String.valueOf(mapVal.get("WATT")));
	        		}
	        	}
			}
*/
    		
/*    		
			for (int i=0; i<glist.size(); i++){
        		Map<String, Object> mapVal = glist.get(i);
        		
        		if (mapVal.get("C_SLAVE").toString().equals("1")){
        			y1.add(String.valueOf(mapVal.get("WATT")));
        		}else if (mapVal.get("C_SLAVE").toString().trim().equals("3")){
        			y2.add(String.valueOf(mapVal.get("WATT")));
        		}else if (mapVal.get("C_SLAVE").toString().trim().equals("4")){
        			y3.add(String.valueOf(mapVal.get("WATT")));
        		}else if (mapVal.get("C_SLAVE").toString().trim().equals("5")){
        			y4.add(String.valueOf(mapVal.get("WATT")));
        		}else if (mapVal.get("C_SLAVE").toString().trim().equals("6")){
        			y5.add(String.valueOf(mapVal.get("WATT")));
        		}
        	}
*/
//    		categories = new String[]{"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct","Nov", "Dec"};

    		dat = new double[y1.size()];

       		for (int y=0; y<y1.size(); y++){
        		dat[y] = Double.parseDouble(y1.get(y));
        	}
       		
        	list.add(new SeriesBean("1","#3dddf7","line",dat));
        	
/*        	dat = null;
    		dat = new double[y2.size()];

       		for (int y=0; y<y2.size(); y++){
        		dat[y] = Double.parseDouble(y2.get(y));
        	}
       		list.add(new SeriesBean("난방","#ffaa01","line",dat));
*/       		
       		dat = null;
    		dat = new double[y2.size()];

       		for (int y=0; y<y2.size(); y++){
        		dat[y] = Double.parseDouble(y2.get(y));
        	}
       		
       		list.add(new SeriesBean("3","#5789ff","line",dat));

       		dat = null;
    		dat = new double[y3.size()];

       		for (int y=0; y<y3.size(); y++){
        		dat[y] = Double.parseDouble(y3.get(y));
        	}
       		
       		list.add(new SeriesBean("4","#7266ba","line",dat));

       		dat = null;
    		dat = new double[y4.size()];

       		for (int y=0; y<y4.size(); y++){
        		dat[y] = Double.parseDouble(y4.get(y));
        	}
       		
       		list.add(new SeriesBean("5","#f76397","line",dat));
       		
       		dat = null;
    		dat = new double[y5.size()];

       		for (int y=0; y<y5.size(); y++){
        		dat[y] = Double.parseDouble(y5.get(y));
        	}
       		
       		list.add(new SeriesBean("6","#fe8030","line",dat));
       		
    	}catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	//return new dataVO(Arrays.asList(categories),list);
		return new dataVO(categories,list);
	}
	
	/*
	 * 건물전체 하단 그래프 데이터
	 */
	
	public dataVO getTotalPageBottomGraph(){

		String sqlid = "data.getTotalEnergy";
		
		double[] dat = null;
		
		double total=0, y1=0,y2=0,y3=0,y4=0,y5=0,y6=0;
		List<SeriesBean> list = new ArrayList<SeriesBean>();
		    	
    	String[] categories = null; // x값
    	
    	// map은 빈칸으로 채워 넣는다.. 일단은..... 나중에 값이 들어가야 하는..
		Map<String,Object> map = new HashMap<String,Object>();
		
		try {
			List<Map<String, Object>> glist = commonService.selectlist(map, sqlid);

			dat = new double[5];
			
			for (int i=0; i<glist.size(); i++){
        		Map<String, Object> mapVal = glist.get(i);
        		
        		if (mapVal.get("C_REPRESENT").toString().equals("R2")){
        			dat[0] = Math.abs(Double.parseDouble(String.valueOf(mapVal.get("KWH")))) ;
        			dat[0] = Double.parseDouble(String.format("%.2f", dat[0]));
        		}else if (mapVal.get("C_REPRESENT").toString().equals("R3")){
        			dat[1] = Math.abs(Double.parseDouble(String.valueOf(mapVal.get("KWH")))) ;
        			dat[1] = Double.parseDouble(String.format("%.2f", dat[1]));
        		}else if (mapVal.get("C_REPRESENT").toString().equals("R4")){
        			dat[2] = Math.abs(Double.parseDouble(String.valueOf(mapVal.get("KWH"))));
        			dat[2] = Double.parseDouble(String.format("%.2f", dat[2]));
        		}else if (mapVal.get("C_REPRESENT").toString().equals("R5")){
        			dat[3] = Math.abs(Double.parseDouble(String.valueOf(mapVal.get("KWH"))));
        			dat[3] = Double.parseDouble(String.format("%.2f", dat[3]));
        		}else if (mapVal.get("C_REPRESENT").toString().equals("R6")){
        			dat[4] = Math.abs(Double.parseDouble(String.valueOf(mapVal.get("KWH"))));
        			dat[4] = Double.parseDouble(String.format("%.2f", dat[4]));
        		}
        		/*
        		if (mapVal.get("C_NAME").toString().equals("A")){
        			total = Double.parseDouble(String.valueOf(mapVal.get("WATT")));
        		}else if (mapVal.get("C_NAME").toString().trim().equals("냉방")){
        			y1 = Double.parseDouble(String.valueOf(mapVal.get("WATT")));
        		}else if (mapVal.get("C_NAME").toString().trim().equals("급탕")){
        			y2 = Double.parseDouble(String.valueOf(mapVal.get("WATT")));
        		}else if (mapVal.get("C_NAME").toString().trim().equals("환기")){
        			y3 = Double.parseDouble(String.valueOf(mapVal.get("WATT")));
        		}else if (mapVal.get("C_NAME").toString().trim().equals("조명")){
        			y4 = Double.parseDouble(String.valueOf(mapVal.get("WATT")));
        		}else if (mapVal.get("C_NAME").toString().trim().equals("콘센트")){
        			y5 = Double.parseDouble(String.valueOf(mapVal.get("WATT")));
        		}/*else if (mapVal.get("NAME").toString().trim().equals("6")){
        			y6 = Double.parseDouble(String.valueOf(mapVal.get("WATT")));
        		}*/
        	}  
			total = dat[0] + dat[1] + dat[2] + dat[3] + dat[4];
    		categories = new String[]{"1", "2", "3", "4", "5", "6", "7","8","9","10","11","12"};

//    		dat = new double[5];
//    		dat[0] = y1;dat[1] = y2;dat[2] = y3;dat[3] = y4;dat[4] = y5; //dat[5] = y6;
       		
        	list.add(new SeriesBean("냉방","","",dat));
        	
       		dat = null;
    		dat = new double[1];
    		dat[0] = total;
       		list.add(new SeriesBean("total","","",dat));
       		
    	}catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return new dataVO(Arrays.asList(categories),list);
	}
	
	/*
	 * 에너지 용도별 화면 1번 그래프 
	 */
	public dataVO getEnergyFirstGraph(String gb, String day1, String day2){

		String sqlid = "data.getEnergyFirstGraph";
		
		double[] dat = null;
		
		List<SeriesBean> list = new ArrayList<SeriesBean>();
				
    	List<String> y1 = new ArrayList<String>(); // y값 냉방 -- 사용안함
    	List<String> y2 = new ArrayList<String>(); // y값 냉난방
    	List<String> y3 = new ArrayList<String>(); // y값 급탕
    	List<String> y4 = new ArrayList<String>(); // y값 환기
    	List<String> y5 = new ArrayList<String>(); // y값 조명
    	List<String> y6 = new ArrayList<String>(); // y값 콘센트
    	
    	List<String> cat = new ArrayList<String>(); 
    	List<String> tmp = new ArrayList<String>();
    	List<String> hum = new ArrayList<String>();
    	
    	List<String> categories = new ArrayList<String>();
    	
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("GB",gb);
		map.put("SDATE", day1);
		map.put("EDATE", day2);
		
		try {
			List<Map<String, Object>> glist = commonService.selectlist(map, sqlid);
 
			String comp = "";
			
			Map<String, Object> mapVal1 = glist.get(0);
			comp = mapVal1.get("DT").toString();

			cat.add(mapVal1.get("DT").toString());
			tmp.add(mapVal1.get("TEMP").toString());
			hum.add(mapVal1.get("HUMI").toString());
			
			double tot = 0.0, p[] = new double[6];
			
			String x = null;
			for (int i=0; i<glist.size(); i++){
				Map<String, Object> mapVal = glist.get(i);
				if ( i == 0 ) {
					x = mapVal.get("DT").toString();
				}
				if (!mapVal.get("DT").toString().equals(x)){
					categories.add(x);
					x = mapVal.get("DT").toString();
				}
			}
			categories.add(x);
			
			if (mapVal1.get("C_REPRESENT").toString().trim().equals("R2")){
    			y2.add(String.valueOf(mapVal1.get("KWH")));
    			p[0] = p[0] + Double.parseDouble(String.valueOf(mapVal1.get("KWH")));
    			tot = tot + Double.parseDouble(String.valueOf(mapVal1.get("KWH")));
    		}else if (mapVal1.get("C_REPRESENT").toString().trim().equals("R3")){
    			y3.add(String.valueOf(mapVal1.get("KWH")));
    			p[1] = p[1] + Double.parseDouble(String.valueOf(mapVal1.get("KWH")));
    			tot = tot + Double.parseDouble(String.valueOf(mapVal1.get("KWH")));
    		}else if (mapVal1.get("C_REPRESENT").toString().trim().equals("R4")){
    			y4.add(String.valueOf(mapVal1.get("KWH")));
    			p[2] = p[2] + Double.parseDouble(String.valueOf(mapVal1.get("KWH")));
    			tot = tot + Double.parseDouble(String.valueOf(mapVal1.get("KWH")));
    		}else if (mapVal1.get("C_REPRESENT").toString().trim().equals("R5")){
    			y5.add(String.valueOf(mapVal1.get("KWH")));
    			p[3] = p[3] + Double.parseDouble(String.valueOf(mapVal1.get("KWH")));
    			tot = tot + Double.parseDouble(String.valueOf(mapVal1.get("KWH")));
    		}else if (mapVal1.get("C_REPRESENT").toString().trim().equals("R6")){
    			y6.add(String.valueOf(mapVal1.get("KWH")));
    			p[4] = p[4] + Double.parseDouble(String.valueOf(mapVal1.get("KWH")));
    			tot = tot + Double.parseDouble(String.valueOf(mapVal1.get("KWH")));
    		} 
			
			for (int i=1; i<glist.size(); i++){
        		Map<String, Object> mapVal = glist.get(i);

        		if (!mapVal.get("DT").toString().equals(comp)){
        			comp = mapVal.get("DT").toString();
        			cat.add(mapVal.get("DT").toString());
        			tmp.add(mapVal.get("TEMP").toString());
        			hum.add(mapVal.get("HUMI").toString());
        			
        			if (mapVal.get("C_REPRESENT").toString().trim().equals("R2")){
            			y2.add(String.valueOf(mapVal.get("KWH")));
            			p[0] = p[0] + Double.parseDouble(String.valueOf(mapVal.get("KWH")));
            			tot = tot + Double.parseDouble(String.valueOf(mapVal.get("KWH")));
            		}else if (mapVal.get("C_REPRESENT").toString().trim().equals("R3")){
            			y3.add(String.valueOf(mapVal.get("KWH")));
            			p[1] = p[1] + Double.parseDouble(String.valueOf(mapVal.get("KWH")));
            			tot = tot + Double.parseDouble(String.valueOf(mapVal.get("KWH")));
            		}else if (mapVal.get("C_REPRESENT").toString().trim().equals("R4")){
            			y4.add(String.valueOf(mapVal.get("KWH")));
            			p[2] = p[2] + Double.parseDouble(String.valueOf(mapVal.get("KWH")));
            			tot = tot + Double.parseDouble(String.valueOf(mapVal.get("KWH")));
            		}else if (mapVal.get("C_REPRESENT").toString().trim().equals("R5")){
            			y5.add(String.valueOf(mapVal.get("KWH")));
            			p[3] = p[3] + Double.parseDouble(String.valueOf(mapVal.get("KWH")));
            			tot = tot + Double.parseDouble(String.valueOf(mapVal.get("KWH")));
            		}else if (mapVal.get("C_REPRESENT").toString().trim().equals("R6")){
            			y6.add(String.valueOf(mapVal.get("KWH")));
            			p[4] = p[4] + Double.parseDouble(String.valueOf(mapVal.get("KWH")));
            			tot = tot + Double.parseDouble(String.valueOf(mapVal.get("KWH")));
            		} 
        			
        		}else{
        			if (mapVal.get("C_REPRESENT").toString().trim().equals("R2")){
            			y2.add(String.valueOf(mapVal.get("KWH")));
            			p[0] = p[0] + Double.parseDouble(String.valueOf(mapVal.get("KWH")));
            			tot = tot + Double.parseDouble(String.valueOf(mapVal.get("KWH")));
            		}else if (mapVal.get("C_REPRESENT").toString().trim().equals("R3")){
            			y3.add(String.valueOf(mapVal.get("KWH")));
            			p[1] = p[1] + Double.parseDouble(String.valueOf(mapVal.get("KWH")));
            			tot = tot + Double.parseDouble(String.valueOf(mapVal.get("KWH")));
            		}else if (mapVal.get("C_REPRESENT").toString().trim().equals("R4")){
            			y4.add(String.valueOf(mapVal.get("KWH")));
            			p[2] = p[2] + Double.parseDouble(String.valueOf(mapVal.get("KWH")));
            			tot = tot + Double.parseDouble(String.valueOf(mapVal.get("KWH")));
            		}else if (mapVal.get("C_REPRESENT").toString().trim().equals("R5")){
            			y5.add(String.valueOf(mapVal.get("KWH")));
            			p[3] = p[3] + Double.parseDouble(String.valueOf(mapVal.get("KWH")));
            			tot = tot + Double.parseDouble(String.valueOf(mapVal.get("KWH")));
            		}else if (mapVal.get("C_REPRESENT").toString().trim().equals("R6")){
            			y6.add(String.valueOf(mapVal.get("KWH")));
            			p[4] = p[4] + Double.parseDouble(String.valueOf(mapVal.get("KWH")));
            			tot = tot + Double.parseDouble(String.valueOf(mapVal.get("KWH")));
            		}
        		}
        	}        		
/*
    		dat = new double[y1.size()];

       		for (int y=0; y<y1.size(); y++){
        		dat[y] = Double.parseDouble(y1.get(y));
        	}
       		
        	list.add(new SeriesBean("냉방","#3dddf7","column",dat));
*/        	
        	dat = null;
    		dat = new double[y2.size()];

       		for (int y=0; y<y2.size(); y++){
        		dat[y] = Double.parseDouble(y2.get(y));
        	}
       		list.add(new SeriesBean("냉난방","#ffaa01","column",dat));
       		
       		dat = null;
    		dat = new double[y3.size()];

       		for (int y=0; y<y3.size(); y++){
        		dat[y] = Double.parseDouble(y3.get(y));
        	}
       		
       		list.add(new SeriesBean("급탕","#5789ff","column",dat));

       		dat = null;
    		dat = new double[y4.size()];

       		for (int y=0; y<y4.size(); y++){
        		dat[y] = Double.parseDouble(y4.get(y));
        	}
       		
       		list.add(new SeriesBean("환기","#7266ba","column",dat));

       		dat = null;
    		dat = new double[y5.size()];

       		for (int y=0; y<y5.size(); y++){
        		dat[y] = Double.parseDouble(y5.get(y));
        	}
       		
       		list.add(new SeriesBean("조명","#f76397","column",dat));
       		
       		dat = null;
    		dat = new double[y6.size()];

       		for (int y=0; y<y6.size(); y++){
        		dat[y] = Double.parseDouble(y6.get(y));
        	}
       		
       		list.add(new SeriesBean("콘센트","#fe8030","column",dat));
       		
       		dat = null;
    		dat = new double[tmp.size()];

       		for (int y=0; y<tmp.size(); y++){
        		dat[y] = Double.parseDouble(tmp.get(y));
        	}
       		
       		list.add(new SeriesBean("외기온도","#fe8030","line",dat));
       		
       		dat = null;
    		dat = new double[hum.size()];

       		for (int y=0; y<hum.size(); y++){
        		dat[y] = Double.parseDouble(hum.get(y));
        	}
       		list.add(new SeriesBean("외기습도","#fe8030","line",dat));
       		
       		for (int k = 0; k <6; k++){
           		dat = null;
           		dat = new double[1];
           		dat[0] = Math.round((p[k]/tot) * 100.0);
           		
           		list.add(new SeriesBean("p" + Integer.toString(k+1),"","",dat));
       		}
       		
       		for (int k = 0; k <6; k++){
           		dat = null;
           		dat = new double[1];
           		dat[0] = p[k];
           		
           		list.add(new SeriesBean("g" + Integer.toString(k+1),"","",dat));
       		}

    	}catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return new dataVO(categories,list);
	}
	
	/*
	 * 에너지 원별 화면 파이 그래프 / 금액 
	 */
	public dataVO getEnergyResourceFirstGraph(String gb, String day1, String day2){

		String sqlid = "data.getEnergyResourceGraph";
		
		double[] dat = null;
		
		List<SeriesBean> list = new ArrayList<SeriesBean>();
		
    	List<String> y1 = new ArrayList<String>(); // y값 전력
    	List<String> y2 = new ArrayList<String>(); // y값 가스
    	List<String> y3 = new ArrayList<String>(); // y값 유류
    	List<String> y4 = new ArrayList<String>(); // y값 태양광
    	List<String> y5 = new ArrayList<String>(); // y값 태양열
    	List<String> y6 = new ArrayList<String>(); // y값 지열
    	
    	List<String> y11 = new ArrayList<String>(); // y값 전력금액
    	List<String> y21 = new ArrayList<String>(); // y값 가스금액
    	List<String> y31 = new ArrayList<String>(); // y값 유류금액
    	List<String> y41 = new ArrayList<String>(); // y값 태양광금액
    	List<String> y51 = new ArrayList<String>(); // y값 태양열금액
    	List<String> y61 = new ArrayList<String>(); // y값 지열금액
    	
    	List<String> cat = new ArrayList<String>(); 
    	String[] categories = null; // x값
    	double tot = 0.0;
    	
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("GB",gb);
		map.put("SDATE", day1);
		map.put("EDATE", day2);
		
		try {
			List<Map<String, Object>> glist = commonService.selectlist(map, sqlid);
			
			for (int i=0; i<glist.size(); i++){
        		Map<String, Object> mapVal = glist.get(i);
        		
        		if (mapVal.get("GUBUN").toString().trim().equals("A")){
        			tot = tot+ Double.parseDouble(String.valueOf(mapVal.get("PROD")));
        			y1.add(String.valueOf(mapVal.get("PROD")));
        			y11.add(String.valueOf(mapVal.get("PAY")));
        		}else if(mapVal.get("GUBUN").toString().trim().equals("B")){
        			tot = tot+ Double.parseDouble(String.valueOf(mapVal.get("PROD")));
        			y2.add(String.valueOf(mapVal.get("PROD")));
        			y21.add(String.valueOf(mapVal.get("PAY")));
        		}else if(mapVal.get("GUBUN").toString().trim().equals("C")){
        			tot = tot+ Double.parseDouble(String.valueOf(mapVal.get("PROD")));
        			y3.add(String.valueOf(mapVal.get("PROD")));
        			y31.add(String.valueOf(mapVal.get("PAY")));
        		}else if(mapVal.get("GUBUN").toString().trim().equals("D")){
        			tot = tot+ Double.parseDouble(String.valueOf(mapVal.get("PROD")));
        			y4.add(String.valueOf(mapVal.get("PROD")));
        			y41.add(String.valueOf(mapVal.get("PAY")));
        		}else if(mapVal.get("GUBUN").toString().trim().equals("E")){
        			tot = tot+ Double.parseDouble(String.valueOf(mapVal.get("PROD")));
        			y5.add(String.valueOf(mapVal.get("PROD")));
        			y51.add(String.valueOf(mapVal.get("PAY")));
        		}else if(mapVal.get("GUBUN").toString().trim().equals("F")){
        			tot = tot+ Double.parseDouble(String.valueOf(mapVal.get("PROD")));
        			y6.add(String.valueOf(mapVal.get("PROD")));
        			y61.add(String.valueOf(mapVal.get("PAY")));
        		}
			}

			categories = new String[1];
			if (CommonUtils.nullCheckbf(gb)) {
				categories[0] = "";
			}else{
				categories[0] = day1;				
			}
			
    		dat = null; dat = new double[y1.size()];

       		for (int y=0; y<y1.size(); y++){
        		dat[y] = (Double.parseDouble(y1.get(y)) / tot) * 100;
        	}
       		list.add(new SeriesBean("전력","#3dddf7","column",dat));
       		dat = null; dat = new double[y1.size()];
       		for (int y=0; y<y1.size(); y++){
        		dat[y] = Double.parseDouble(y1.get(y));
        	}
       		list.add(new SeriesBean("전력val","#3dddf7","column",dat));
    		dat = null; dat = new double[y11.size()];

       		for (int y=0; y<y11.size(); y++){
        		dat[y] = Double.parseDouble(y11.get(y));
        	}
       		list.add(new SeriesBean("전력금액","#3dddf7","column",dat));
       		
    		dat = null; dat = new double[y2.size()];
       		for (int y=0; y<y2.size(); y++){
       			dat[y] = (Double.parseDouble(y2.get(y)) / tot) * 100;
        	}
       		list.add(new SeriesBean("가스","#3dddf7","column",dat));
    		dat = null; dat = new double[y2.size()];
       		for (int y=0; y<y2.size(); y++){
       			dat[y] = Double.parseDouble(y2.get(y)) ;
        	}
       		list.add(new SeriesBean("가스val","#3dddf7","column",dat));
    		dat = null; dat = new double[y21.size()];
       		for (int y=0; y<y21.size(); y++){
        		dat[y] = Double.parseDouble(y21.get(y));
        	}
       		list.add(new SeriesBean("가스금액","#3dddf7","column",dat));
			
    		dat = null; dat = new double[y3.size()];
       		for (int y=0; y<y3.size(); y++){
       			dat[y] = (Double.parseDouble(y3.get(y)) / tot) * 100;
        	}
       		list.add(new SeriesBean("유류","#3dddf7","column",dat));
    		dat = null; dat = new double[y3.size()];
       		for (int y=0; y<y3.size(); y++){
       			dat[y] = Double.parseDouble(y3.get(y)) ;
        	}
       		list.add(new SeriesBean("유류val","#3dddf7","column",dat));
       		dat = null; dat = new double[y31.size()];
       		for (int y=0; y<y31.size(); y++){
        		dat[y] = Double.parseDouble(y31.get(y));
        	}
       		list.add(new SeriesBean("유류금액","#3dddf7","column",dat));
       		
       		dat = null; dat = new double[y4.size()];
       		for (int y=0; y<y4.size(); y++){
       			dat[y] = (Double.parseDouble(y4.get(y)) / tot) * 100;
        	}
       		list.add(new SeriesBean("태양광","#3dddf7","column",dat));
       		dat = null; dat = new double[y4.size()];
       		for (int y=0; y<y4.size(); y++){
       			dat[y] = Double.parseDouble(y4.get(y));
        	}
       		list.add(new SeriesBean("태양광val","#3dddf7","column",dat));
       		
       		dat = null; dat = new double[y41.size()];
       		for (int y=0; y<y41.size(); y++){
        		dat[y] = Double.parseDouble(y41.get(y));
        	}
       		list.add(new SeriesBean("태양광금액","#3dddf7","column",dat));
       		
       		dat = null; dat = new double[y5.size()];
       		for (int y=0; y<y5.size(); y++){
       			dat[y] = (Double.parseDouble(y5.get(y)) / tot) * 100;
        	}
       		list.add(new SeriesBean("태양열","#3dddf7","column",dat));
       		dat = null; dat = new double[y5.size()];
       		for (int y=0; y<y5.size(); y++){
       			dat[y] = Double.parseDouble(y5.get(y));
        	}
       		list.add(new SeriesBean("태양열val","#3dddf7","column",dat));
       		dat = null; dat = new double[y51.size()];
       		for (int y=0; y<y51.size(); y++){
        		dat[y] = Double.parseDouble(y51.get(y));
        	}
       		list.add(new SeriesBean("태양열금액","#3dddf7","column",dat));
       		
       		dat = null; dat = new double[y6.size()];
       		for (int y=0; y<y6.size(); y++){
       			dat[y] = (Double.parseDouble(y6.get(y)) / tot) * 100;
        	}
       		list.add(new SeriesBean("지열","#3dddf7","column",dat));
       		dat = null; dat = new double[y6.size()];
       		for (int y=0; y<y6.size(); y++){
       			dat[y] = Double.parseDouble(y6.get(y));
        	}
       		list.add(new SeriesBean("지열val","#3dddf7","column",dat));
       		dat = null; dat = new double[y61.size()];
       		for (int y=0; y<y61.size(); y++){
        		dat[y] = Double.parseDouble(y61.get(y));
        	}
       		list.add(new SeriesBean("지열금액","#3dddf7","column",dat));
       		
		}catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return new dataVO(Arrays.asList(categories),list);
	}
	
	/*
	 * 에너지 원별 화면 spline 그래프  
	 */
	public dataVO getEnergyResourceSecondGraph(String day1, String day2){

		String sqlid = "data.getEnergyResourceGraph2";
		
		double[] dat1 = null, dat2 = null, dat3 = null, dat4 = null, dat5 = null, dat6 = null;
		
		List<SeriesBean> list = new ArrayList<SeriesBean>();
		
    	String[] categories = null; // x값 변수값의  월 일
    	
		Map<String,Object> map = new HashMap<String,Object>();

		map.put("SDATE", day1);
		map.put("EDATE", day2);
		
		Calendar calendar = Calendar.getInstance();
		
		int year = Integer.parseInt(day1.substring(0, 4));
		int month = Integer.parseInt(day1.substring(5, 6));
		calendar.set(year, month, 1);
		
		int DayOfMonth = calendar.getActualMaximum(Calendar.DAY_OF_MONTH);
		
		try {
			List<Map<String, Object>> glist = commonService.selectlist(map, sqlid);
			
			dat1 = new double[DayOfMonth];dat2 = new double[DayOfMonth];
			dat3 = new double[DayOfMonth];dat4 = new double[DayOfMonth];
			dat5 = new double[DayOfMonth];dat6 = new double[DayOfMonth];
			
			String tmp = "",comp = "", comp1 = "";
			
			for (int k=1; k < DayOfMonth + 1; k++){
				for (int i=0; i<glist.size(); i++){
					Map<String, Object> mapVal = glist.get(i);
	        		if (mapVal.get("GUBUN").toString().trim().equals("A")){
	        			tmp = String.valueOf(mapVal.get("X"));
	        			comp = tmp.substring(6,8);
	            		if (Integer.toString(k).length() < 2){
	            			comp1 = "0" + Integer.toString(k);
	            		}else{
	            			comp1 = Integer.toString(k);
	            		}
	        			if (comp.equals(comp1)){
	        				dat1[k - 1] = (Double.parseDouble(String.valueOf(mapVal.get("WATT"))));
	        			}
	        		}
				}
			}
			
			for (int k=1; k < DayOfMonth + 1; k++){
				for (int i=0; i<glist.size(); i++){
					Map<String, Object> mapVal = glist.get(i);
	        		if (mapVal.get("GUBUN").toString().trim().equals("B")){
	        			tmp = String.valueOf(mapVal.get("X"));
	        			comp = tmp.substring(6,8);
	            		if (Integer.toString(k).length() < 2){
	            			comp1 = "0" + Integer.toString(k);
	            		}else{
	            			comp1 = Integer.toString(k);
	            		}
	        			if (comp.equals(comp1)){
	        				dat2[k - 1] = (Double.parseDouble(String.valueOf(mapVal.get("WATT"))));
	        			}
	        		}
				}
			}
			
			for (int k=1; k < DayOfMonth + 1; k++){
				for (int i=0; i<glist.size(); i++){
					Map<String, Object> mapVal = glist.get(i);
	        		if (mapVal.get("GUBUN").toString().trim().equals("C")){
	        			tmp = String.valueOf(mapVal.get("X"));
	        			comp = tmp.substring(6,8);
	            		if (Integer.toString(k).length() < 2){
	            			comp1 = "0" + Integer.toString(k);
	            		}else{
	            			comp1 = Integer.toString(k);
	            		}
	        			if (comp.equals(comp1)){
	        				dat3[k - 1] = (Double.parseDouble(String.valueOf(mapVal.get("WATT"))));
	        			}
	        		}
				}
			}
			
			for (int k=1; k < DayOfMonth + 1; k++){
				for (int i=0; i<glist.size(); i++){
					Map<String, Object> mapVal = glist.get(i);
	        		if (mapVal.get("GUBUN").toString().trim().equals("D")){
	        			tmp = String.valueOf(mapVal.get("X"));
	        			comp = tmp.substring(6,8);
	            		if (Integer.toString(k).length() < 2){
	            			comp1 = "0" + Integer.toString(k);
	            		}else{
	            			comp1 = Integer.toString(k);
	            		}
	        			if (comp.equals(comp1)){
	        				dat4[k - 1] = (Double.parseDouble(String.valueOf(mapVal.get("WATT"))));
	        			}
	        		}
				}
			}
			
			for (int k=1; k < DayOfMonth + 1; k++){
				for (int i=0; i<glist.size(); i++){
					Map<String, Object> mapVal = glist.get(i);
	        		if (mapVal.get("GUBUN").toString().trim().equals("E")){
	        			tmp = String.valueOf(mapVal.get("X"));
	        			comp = tmp.substring(6,8);
	            		if (Integer.toString(k).length() < 2){
	            			comp1 = "0" + Integer.toString(k);
	            		}else{
	            			comp1 = Integer.toString(k);
	            		}
	        			if (comp.equals(comp1)){
	        				dat5[k - 1] = (Double.parseDouble(String.valueOf(mapVal.get("WATT"))));
	        			}
	        		}
				}
			}
			
			for (int k=1; k < DayOfMonth + 1; k++){
				for (int i=0; i<glist.size(); i++){
					Map<String, Object> mapVal = glist.get(i);
	        		if (mapVal.get("GUBUN").toString().trim().equals("F")){
	        			tmp = String.valueOf(mapVal.get("X"));
	        			comp = tmp.substring(6,8);
	            		if (Integer.toString(k).length() < 2){
	            			comp1 = "0" + Integer.toString(k);
	            		}else{
	            			comp1 = Integer.toString(k);
	            		}
	        			if (comp.equals(comp1)){
	        				dat6[k - 1] = (Double.parseDouble(String.valueOf(mapVal.get("WATT"))));
	        			}
	        		}
				}
			}
			
			categories = new String[DayOfMonth];
			
			for (int y=1; y < DayOfMonth + 1; y++ ){categories[y - 1] = Integer.toString(y);}

       		list.add(new SeriesBean("A","#3dddf7","spline",dat1));
       		list.add(new SeriesBean("B","#3dddf7","spline",dat2));
       		list.add(new SeriesBean("C","#3dddf7","spline",dat3));
       		list.add(new SeriesBean("D","#3dddf7","spline",dat4));
       		list.add(new SeriesBean("E","#3dddf7","spline",dat5));
       		list.add(new SeriesBean("F","#3dddf7","spline",dat6));
       		
		}catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
    	return new dataVO(Arrays.asList(categories),list);
	}
	
	/*
	 * 에너지 원별 화면 Column 그래프  
	 */
	public dataVO getEnergyResourceThridGraph(String day1){
		String sqlid = "data.getEnergyResourceGraph3";

		double[] dat1 = null, dat2 = null, dat3 = null, dat4 = null, dat5 = null, dat6 = null;
		
		List<SeriesBean> list = new ArrayList<SeriesBean>();
		
    	String[] categories = null; // x값 변수값의  월 일
    	categories = new String[1];
		Map<String,Object> map = new HashMap<String,Object>();

		map.put("SDATE", day1);
		
		try {
			List<Map<String, Object>> glist = commonService.selectlist(map, sqlid);
		
			dat1 = new double[1];dat2 = new double[1];
			dat3 = new double[1];dat4 = new double[1];
			dat5 = new double[1];dat6 = new double[1];
			
			for (int i=0; i<glist.size(); i++){
				Map<String, Object> mapVal = glist.get(i);
        		if (mapVal.get("GUBUN").toString().trim().equals("A")){
        			dat1[0] = (Double.parseDouble(String.valueOf(mapVal.get("WATT"))));
        		}else if (mapVal.get("GUBUN").toString().trim().equals("B")){
        			dat2[0] = (Double.parseDouble(String.valueOf(mapVal.get("WATT"))));
        		}else if (mapVal.get("GUBUN").toString().trim().equals("C")){
        			dat3[0] = (Double.parseDouble(String.valueOf(mapVal.get("WATT"))));
        		}else if (mapVal.get("GUBUN").toString().trim().equals("D")){
        			dat4[0] = (Double.parseDouble(String.valueOf(mapVal.get("WATT"))));
        		}else if (mapVal.get("GUBUN").toString().trim().equals("E")){
        			dat5[0] = (Double.parseDouble(String.valueOf(mapVal.get("WATT"))));
        		}else if (mapVal.get("GUBUN").toString().trim().equals("F")){
        			dat6[0] = (Double.parseDouble(String.valueOf(mapVal.get("WATT"))));
        		}
        		
			}
			
       		list.add(new SeriesBean("A","#3dddf7","column",dat1));
       		list.add(new SeriesBean("B","#3dddf7","column",dat2));
       		list.add(new SeriesBean("C","#3dddf7","column",dat3));
       		list.add(new SeriesBean("D","#3dddf7","column",dat4));
       		list.add(new SeriesBean("E","#3dddf7","column",dat5));
       		list.add(new SeriesBean("F","#3dddf7","column",dat6));
       		categories[0] = "1";
		}catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return new dataVO(Arrays.asList(categories),list);
	}

	/*
	 * 에너지 원별 화면 line 그래프  
	 */
	public dataVO getEnergyResourceForthGraph(String day1){
		String sqlid = "data.getEnergyResourceGraph4";

		double[] dat1 = null, dat2 = null, dat3 = null, dat4 = null, dat5 = null, dat6 = null;
		
		List<SeriesBean> list = new ArrayList<SeriesBean>();
		
    	String[] categories = null; // x값 변수값의  월 일
    	categories = new String[1];
		Map<String,Object> map = new HashMap<String,Object>();

		map.put("SDATE", day1);
		
		Calendar calendar = Calendar.getInstance();
		
		int year = Integer.parseInt(day1.substring(0, 4));
		int month = Integer.parseInt(day1.substring(5, 6));
		calendar.set(year, month, 1);
		
		int DayOfMonth = calendar.getActualMaximum(Calendar.DAY_OF_MONTH);
		
		try {
			List<Map<String, Object>> glist = commonService.selectlist(map, sqlid);
		
			dat1 = new double[DayOfMonth];dat2 = new double[DayOfMonth];
			dat3 = new double[DayOfMonth];dat4 = new double[DayOfMonth];
			dat5 = new double[DayOfMonth];dat6 = new double[DayOfMonth];
			
			String tmp = "",comp = "", comp1 = "";
			
			for (int k=1; k < DayOfMonth + 1; k++){
				for (int i=0; i<glist.size(); i++){
					Map<String, Object> mapVal = glist.get(i);
	        		if (mapVal.get("GUBUN").toString().trim().equals("A")){
	        			tmp = String.valueOf(mapVal.get("X"));
	        			comp = tmp.substring(6,8);
	            		if (Integer.toString(k).length() < 2){
	            			comp1 = "0" + Integer.toString(k);
	            		}else{
	            			comp1 = Integer.toString(k);
	            		}
	        			if (comp.equals(comp1)){
	        				dat1[k - 1] = (Double.parseDouble(String.valueOf(mapVal.get("WATT"))));
	        			}
	        		}
				}
			}
			
			for (int k=1; k < DayOfMonth + 1; k++){
				for (int i=0; i<glist.size(); i++){
					Map<String, Object> mapVal = glist.get(i);
	        		if (mapVal.get("GUBUN").toString().trim().equals("B")){
	        			tmp = String.valueOf(mapVal.get("X"));
	        			comp = tmp.substring(6,8);
	            		if (Integer.toString(k).length() < 2){
	            			comp1 = "0" + Integer.toString(k);
	            		}else{
	            			comp1 = Integer.toString(k);
	            		}
	        			if (comp.equals(comp1)){
	        				dat2[k - 1] = (Double.parseDouble(String.valueOf(mapVal.get("WATT"))));
	        			}
	        		}
				}
			}
			
			for (int k=1; k < DayOfMonth + 1; k++){
				for (int i=0; i<glist.size(); i++){
					Map<String, Object> mapVal = glist.get(i);
	        		if (mapVal.get("GUBUN").toString().trim().equals("C")){
	        			tmp = String.valueOf(mapVal.get("X"));
	        			comp = tmp.substring(6,8);
	            		if (Integer.toString(k).length() < 2){
	            			comp1 = "0" + Integer.toString(k);
	            		}else{
	            			comp1 = Integer.toString(k);
	            		}
	        			if (comp.equals(comp1)){
	        				dat3[k - 1] = (Double.parseDouble(String.valueOf(mapVal.get("WATT"))));
	        			}
	        		}
				}
			}
			
			for (int k=1; k < DayOfMonth + 1; k++){
				for (int i=0; i<glist.size(); i++){
					Map<String, Object> mapVal = glist.get(i);
	        		if (mapVal.get("GUBUN").toString().trim().equals("D")){
	        			tmp = String.valueOf(mapVal.get("X"));
	        			comp = tmp.substring(6,8);
	            		if (Integer.toString(k).length() < 2){
	            			comp1 = "0" + Integer.toString(k);
	            		}else{
	            			comp1 = Integer.toString(k);
	            		}
	        			if (comp.equals(comp1)){
	        				dat4[k - 1] = (Double.parseDouble(String.valueOf(mapVal.get("WATT"))));
	        			}
	        		}
				}
			}
			
			for (int k=1; k < DayOfMonth + 1; k++){
				for (int i=0; i<glist.size(); i++){
					Map<String, Object> mapVal = glist.get(i);
	        		if (mapVal.get("GUBUN").toString().trim().equals("E")){
	        			tmp = String.valueOf(mapVal.get("X"));
	        			comp = tmp.substring(6,8);
	            		if (Integer.toString(k).length() < 2){
	            			comp1 = "0" + Integer.toString(k);
	            		}else{
	            			comp1 = Integer.toString(k);
	            		}
	        			if (comp.equals(comp1)){
	        				dat5[k - 1] = (Double.parseDouble(String.valueOf(mapVal.get("WATT"))));
	        			}
	        		}
				}
			}
			
			for (int k=1; k < DayOfMonth + 1; k++){
				for (int i=0; i<glist.size(); i++){
					Map<String, Object> mapVal = glist.get(i);
	        		if (mapVal.get("GUBUN").toString().trim().equals("F")){
	        			tmp = String.valueOf(mapVal.get("X"));
	        			comp = tmp.substring(6,8);
	            		if (Integer.toString(k).length() < 2){
	            			comp1 = "0" + Integer.toString(k);
	            		}else{
	            			comp1 = Integer.toString(k);
	            		}
	        			if (comp.equals(comp1)){
	        				dat6[k - 1] = (Double.parseDouble(String.valueOf(mapVal.get("WATT"))));
	        			}
	        		}
				}
			}
			
			categories = new String[DayOfMonth];
			
			for (int y=1; y < DayOfMonth + 1; y++ ){categories[y - 1] = Integer.toString(y);}

       		list.add(new SeriesBean("A","#7cb5ec","spline",dat1));
       		list.add(new SeriesBean("B","#aaeeee","spline",dat2));
       		list.add(new SeriesBean("C","#90ee7e","spline",dat3));
       		list.add(new SeriesBean("D","#2b908f","spline",dat4));
       		list.add(new SeriesBean("E","#175ea4","spline",dat5));
       		list.add(new SeriesBean("F","#c6def7","spline",dat6));
       		
		}catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return new dataVO(Arrays.asList(categories),list);
	}
	
	/*
	 * 각층 line 그래프  (내부온도 외부온도)
	 */
	public dataVO getFloorTemp(String yyyy){
		String sqlid = "data.getFloorgraphtemp";
		
		List<SeriesBean> list = new ArrayList<SeriesBean>();
		
		double[] dat1 = null, dat2 = null;
		String[] categories = null; // x값 년월
		
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("YYYY", yyyy);
		
		try {
			
			List<Map<String, Object>> glist = commonService.selectlist(map, sqlid);
			int s = glist.size() / 2;
			int s1 = 0, s2 = 0;
			
			dat1 = new double[s];dat2 = new double[s];
			categories = new String[s];
			
			for (int i=0; i<glist.size(); i++){
				Map<String, Object> mapVal = glist.get(i);
        		if (mapVal.get("GUBUN").toString().trim().equals("I")){
        			categories[s1] = mapVal.get("MONTH").toString();
        			dat1[s1] = (Double.parseDouble(String.valueOf(mapVal.get("TEMP"))));
        			s1++;
        		}else if (mapVal.get("GUBUN").toString().trim().equals("O")){
        			dat2[s2] = (Double.parseDouble(String.valueOf(mapVal.get("TEMP"))));
        			s2++;
        		}
			}
			
			list.add(new SeriesBean("I","#f51f6b","spline",dat1));
			list.add(new SeriesBean("O","#2196f3","spline",dat2));
			
		}catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return new dataVO(Arrays.asList(categories),list);
		
	}
	
	/*
	 * 각층 bar 그래프  (전기 유류 가스)
	 */
	public dataVO getFloorkwh(String yyyy){
		String sqlid = "data.getFloorgraphUse";
		
		List<SeriesBean> list = new ArrayList<SeriesBean>();
		
		double[] dat1 = null, dat2 = null, dat3 = null;
		String[] categories = null; // x값 년월
		
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("YYYY", yyyy);
		
		try {
			
			List<Map<String, Object>> glist = commonService.selectlist(map, sqlid);
			int s = glist.size() / 3;
			int s1 = 0, s2 = 0, s3 = 0;
			
			dat1 = new double[s];dat2 = new double[s];dat3 = new double[s];
			categories = new String[s];
			
			for (int i=0; i<glist.size(); i++){
				Map<String, Object> mapVal = glist.get(i);
        		if (mapVal.get("GUBUN").toString().trim().equals("E")){
        			categories[s1] = mapVal.get("C_YYYYMM").toString();
        			dat1[s1] = (Double.parseDouble(String.valueOf(mapVal.get("I_KWH"))));
        			s1++;
        		}else if (mapVal.get("GUBUN").toString().trim().equals("G")){
        			dat2[s2] = (Double.parseDouble(String.valueOf(mapVal.get("I_KWH"))));
        			s2++;
        		}
        		else if (mapVal.get("GUBUN").toString().trim().equals("W")){
        			dat3[s3] = (Double.parseDouble(String.valueOf(mapVal.get("I_KWH"))));
        			s3++;
        		}
			}
			
			list.add(new SeriesBean("E","#f15d45","column",dat1));
			list.add(new SeriesBean("G","#ffaa00","column",dat2));
			list.add(new SeriesBean("W","#3ddcf7","column",dat2));
			
		}catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return new dataVO(Arrays.asList(categories),list);
		
	}
}

