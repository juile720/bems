package com.ean.data.controller;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ean.common.CommandMap;
import com.ean.service.CommonService;
import com.ean.data.controller.dataVO;
import com.ean.data.controller.SeriesBean;

@Controller
public class dataController {
	Logger log = Logger.getLogger(this.getClass());
	
	@Resource(name="commonService")
	private CommonService commonService;

	/*
	 * 현재 온도를 입력받는다
	 */
/*    @RequestMapping(value = "/data/inputtemp.do")
    @ResponseBody
    public String inputTemp(HttpServletRequest request) throws Exception {
    	String sqlid = "data.insertTemp";
		String returnstr = "ok";
		String temp = request.getParameter("temp");
		String humi = request.getParameter("humi");
		System.out.println(temp + "    " + humi);
		
		Map<String,Object> map = new HashMap<String,Object>();
		
		map.put("I_TEMP", temp);
		map.put("I_HUMI", humi);
		commonService.insert(map, sqlid);
		
		return returnstr;
    }*/
    
    @RequestMapping(value = "/data/graphView.do")
    public String graph1(CommandMap commandMap, ModelMap model) throws Exception {
    	String returnurl = "bems/building_total";
		return returnurl;
    }
    
    @RequestMapping(value = "/data/energyUse.do")
    public String energyUse(CommandMap commandMap, ModelMap model) throws Exception {
    	String returnurl = "bems/energy_use";
		return returnurl;
    }
    
    @RequestMapping(value = "/data/energyResource.do")
    public String energyResource(CommandMap commandMap, ModelMap model) throws Exception {
    	String returnurl = "bems/energy_resource";
		return returnurl;
    }
    
    @RequestMapping(value = "/data/getFacilitiesList.do")
    public String getFacilitiesList(CommandMap commandMap, ModelMap model) throws Exception {
    	String returnurl = "bems/energy_resource";
		return returnurl;
    }
    
    @RequestMapping(value = "/data/energyFacilities.do")
    public String energyFacilities(CommandMap commandMap, ModelMap model) throws Exception {
    	String sqlid = "code.getFacilities";
    	String sqlid1 = "data.getFacilitiesListData";
    	
    	String returnurl = "bems/energy_facilities";
    	List<?> List = null;

    	try {
    		List = commonService.selectlist(commandMap.getMap(), sqlid);
    		List<Map<String, Object>> List1 = commonService.selectlist(commandMap.getMap(), sqlid1);
    		model.addAttribute("list", List);    		
    		model.addAttribute("list1", List1);
    	}catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	
		return returnurl;
    }
     
    @RequestMapping(value = "/data/floor.do")
    public String floor(CommandMap commandMap, ModelMap model) throws Exception {
    	String returnurl = "bems/floor";
    	String sqlid = "data.getFloorTempHumi";
    	Map<String,Object> map = new HashMap<String,Object>();
    	Map<String, Object> resultList = new HashMap<String, Object>();
    	
    	Calendar cal = Calendar.getInstance();
    	//현재 년도, 월, 일
    	int year = cal.get ( cal.YEAR );
    	int month = cal.get ( cal.MONTH ) + 1 ;
    	int date = cal.get ( cal.DATE ) ;
    	
    	String day1 = null, day2 = null, yyyymm1 = null, yyyymm2 = null;
    	
    	String C_FLOOR = (String)commandMap.get("C_FLOOR");

    	if (C_FLOOR.equals("4")){
    		map.put("C_FLOOR", "2");map.put("C_MASTER", "1");
    	}else if(C_FLOOR.equals("5")){
    		map.put("C_FLOOR", "4");map.put("C_MASTER", "3");
    	}else if(C_FLOOR.equals("6")){
    		map.put("C_FLOOR", "6");map.put("C_MASTER", "5");
    	}else if(C_FLOOR.equals("7")){
    		map.put("C_FLOOR", "8");map.put("C_MASTER", "7");
    	}else if(C_FLOOR.equals("8")){
    		map.put("C_FLOOR", "10");map.put("C_MASTER", "9");
    	}else if(C_FLOOR.equals("9")){
    		map.put("C_FLOOR", "12");map.put("C_MASTER", "13");
    	}else if(C_FLOOR.equals("10")){
    		map.put("C_FLOOR", "14");map.put("C_MASTER", "15");
    	}
		
    	if (Integer.toString(month).length() < 2){
			day1 = Integer.toString(year - 1) + "0" + Integer.toString(month);
			day2 = Integer.toString(year) + "0" + Integer.toString(month);
			yyyymm1 = day1; yyyymm2 = day2;
		}else{
			day1 = Integer.toString(year - 1) + Integer.toString(month);
			day2 = Integer.toString(year) + Integer.toString(month);
			yyyymm1 = day1; yyyymm2 = day2;
		}
    	
    	if (Integer.toString(date).length() < 2){
    		day1 = day1 + "0" + Integer.toString(date);
    		day2 = day2 + "0" + Integer.toString(date);
    	}else{
    		day1 = day1 + Integer.toString(date);
    		day2 = day2 + Integer.toString(date);
    	}
    	
    	map.put("DAY1", day1);map.put("DAY2", day2);
    	map.put("YYYYMM1", yyyymm1);map.put("YYYYMM2", yyyymm2);
    	
    	resultList.put("resultlist",commonService.selectlist(map, sqlid));
    	
		model.addAttribute("resultlist",resultList.get("resultlist"));
    	model.addAttribute("C_FLOOR", C_FLOOR);
		return returnurl;
    }
    

    @RequestMapping(value = "/data/getFacilitiesdata.do")
    @ResponseBody
    public Map<?,?> getFacilitiesData(HttpServletRequest request) throws Exception {

    	String sqlid = "data.getFacilitiesSelectData";

    	Map<String,Object> map = new HashMap<String,Object>();
    	String C_SLAVE = request.getParameter("c_slave");
    	map.put("C_SLAVE", C_SLAVE);

    	Map<String, Object> result = commonService.select(map, sqlid);
    	
		return result;
    }
    
    @RequestMapping(value = "/data/getgraph.do")
    @ResponseBody
    public dataVO getgraph1(CommandMap commandMap, ModelMap model) throws Exception {
    	
    	double[] dat = null;
    	double[] dat1 = null;
    	double[] dat2 = null;
    	
    	String[] categories = null;
    	
    	List<String> x = new ArrayList<String>();
    	List<String> y1 = new ArrayList<String>();
    	List<String> y2 = new ArrayList<String>();
    	List<String> y3 = new ArrayList<String>();
    	
    	String sqlid = "data.getTest";
    	dataVO dvo = new dataVO(null, null);
    	
    	List<SeriesBean> seb = new ArrayList<SeriesBean>();
    	
    	try {
    		List<Map<String, Object>> list = commonService.selectlist(commandMap.getMap(), sqlid);
    		//categories = new String[list.size()];
        	for (int i=0; i<list.size(); i++){
        		Map<String, Object> mapVal = list.get(i);
        		
//        		categories[i] = mapVal.get("TDATE").toString();
        		if (mapVal.get("C_MASTER").toString().equals("0")){
        			x.add(mapVal.get("TDATE").toString());
        			y1.add(String.valueOf(mapVal.get("NUM")));
        		}else if (mapVal.get("C_MASTER").toString().trim().equals("1") && mapVal.get("C_SLAVE").toString().trim().equals("1")){
        			y2.add(String.valueOf(mapVal.get("NUM")));
        		}else if (mapVal.get("C_MASTER").toString().trim().equals("1") && mapVal.get("C_SLAVE").toString().trim().equals("2")){
        			y3.add(String.valueOf(mapVal.get("NUM")));
        		}
        		
        	}
        	categories = new String[]{"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Nov", "Dec"};

//        	categories = new String[x.size()];
//       		for (int i=0; i<x.size(); i++){
//        		categories[i] = x.get(i).toString();
//        	}

       		dat = new double[y1.size()];
        	for (int i=0; i<y1.size(); i++){
        		dat[i] = Double.parseDouble(y1.get(i));
        	}
        	
        	SeriesBean sb = new SeriesBean(null, null, null, null);
        	
        	sb.setName("CO2");
        	sb.setType("spline");
        	sb.setColor("#f5d14e");
        	sb.setData(dat);
        	
        	seb.add(sb);
        	
        	dat1 = new double[y2.size()];
        	for (int i=0; i<y2.size(); i++){
        		dat1[i] = Double.parseDouble(y2.get(i));
        	}

        	sb = new SeriesBean(null, null, null, null);
        	
        	sb.setName("냉방");
        	sb.setType("column");
        	sb.setColor("#f15d45");
        	sb.setData(dat1);
        	
        	seb.add(sb);

    	}catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

    	dvo.setCategories(Arrays.asList(categories));
    	dvo.setSeries(seb);
    	return dvo;
    }
    
    @RequestMapping(value="/data/pop_trendLog.do")
	public String pop_trendLog(CommandMap commandMap, ModelMap model, HttpServletRequest request) throws Exception{
		String returnurl = "popup/pop_trendLog";
		String sqlid = "data.pop_trendLog";
		
		String cFloor = (String)commandMap.get("cFloor");
		String T_DATETIME1 = (String)commandMap.get("T_DATETIME1");
		String T_DATETIME2 = (String)commandMap.get("T_DATETIME2");
		
		List<Map<String, Object>> resultMap = null;
		if(cFloor != null && T_DATETIME1 != null && T_DATETIME2 != null) {
			
			String tFloor[] = cFloor.split(":");
			commandMap.put("cFloor", tFloor[0]);
			commandMap.put("cElecValue", tFloor[1]);
			commandMap.put("cCo2Value", tFloor[2]);
			
			String t_DATETIME1 = T_DATETIME1.replaceAll("-", "");
			commandMap.put("T_DATETIME1", t_DATETIME1);
			
			String t_DATETIME2 = T_DATETIME2.replaceAll("-", "");
			commandMap.put("T_DATETIME2", t_DATETIME2);
			
			resultMap = commonService.selectlist(commandMap.getMap(), sqlid);
		}
		
	    model.addAttribute("list", resultMap);
	    model.addAttribute("cFloor", cFloor);
    	model.addAttribute("T_DATETIME1", T_DATETIME1);
	    model.addAttribute("T_DATETIME2", T_DATETIME2);

		return returnurl;
	}
    
    @RequestMapping(value = "/data/pop_standard.do")
    public String pop_standard(CommandMap commandMap, ModelMap model) throws Exception {
    	String returnurl = "popup/pop_standard";
		return returnurl;
    }
    
    @RequestMapping(value = "/data/pop_detailsearch1.do")
    public String pop_detailsearch1(CommandMap commandMap, ModelMap model) throws Exception {
    	String returnurl = "popup/pop_detailsearch1";
		return returnurl;
    }
    
    @RequestMapping(value = "/data/pop_detailsearch2.do")
    public String pop_detailsearch2(CommandMap commandMap, ModelMap model) throws Exception {
    	String returnurl = "popup/pop_detailsearch2";
		return returnurl;
    }
    
    @RequestMapping(value = "/data/pop_cumulative.do")
    public String pop_cumulative(CommandMap commandMap, ModelMap model) throws Exception {
    	String returnurl = "popup/pop_cumulative";
		return returnurl;
    }
    
    @RequestMapping(value = "/data/pop_goal.do")
    public String pop_goal(CommandMap commandMap, ModelMap model) throws Exception {
    	String returnurl = "popup/pop_goal";
		return returnurl;
    }
    
    @RequestMapping(value = "/data/pop_energy_cumulative.do")
    public String pop_energy_cumulative(CommandMap commandMap, ModelMap model) throws Exception {
    	String returnurl = "popup/pop_energy_cumulative";
		return returnurl;
    }
    
    @RequestMapping(value = "/data/pop_performance_cumulative.do")
    public String pop_performance_cumulative(CommandMap commandMap, ModelMap model) throws Exception {
    	String returnurl = "popup/pop_performance_cumulative";
		return returnurl;
    }
    
    @RequestMapping(value="/data/htmlExcelDownload.do")
	public String htmlExcelDownload(CommandMap commandMap, ModelMap model, HttpServletRequest request) throws Exception{
    	
		String returnurl = "common/htmlExcelDownload";
		
		model.addAttribute("excel_data", (String) commandMap.get("excel_data"));
		
		String excelName = (String) commandMap.get("excelName");
		model.addAttribute("excelName", excelName);
		
		return returnurl;
	}
    
    @RequestMapping(value="/data/inputList.do")
	public String inputList(CommandMap commandMap, ModelMap model, HttpServletRequest request) throws Exception{
		String returnurl = "input/inputList";
		String sqlid = "data.inputList";
		
		String gubun = (String)commandMap.get("gubun");
		String cFloor = (String)commandMap.get("cFloor");
		String cYear = (String)commandMap.get("cYear");
		String cMonth = (String)commandMap.get("cMonth");
		
		List<Map<String, Object>> resultMap = null;
		if(gubun != null && cFloor != null && cYear != null) {
			// 테이블 추가시 sTable 항목 추가
			if(gubun.equals("gas")) {
				commandMap.put("sTable", "TB_GAS2");
			} else if(gubun.equals("water")) {
				commandMap.put("sTable", "TB_WATER2");
			} else if(gubun.equals("electric")) {
				commandMap.put("sTable", "TB_ELECTRIC2");
			}
			
			if(cYear != null && cMonth == null) {
				commandMap.put("cYYYYMM", cYear);
			} else if(cYear != null && cMonth != null) {
				commandMap.put("cYYYYMM", cYear+cMonth);
			}
			
			resultMap = commonService.selectlist(commandMap.getMap(), sqlid);
		}
		
		Calendar c = Calendar.getInstance();
		String defaultYear = String.valueOf(c.get(Calendar.YEAR));
		model.addAttribute("defaultYear", defaultYear);
	    model.addAttribute("list", resultMap);
	    model.addAttribute("gubun", gubun);
	    model.addAttribute("cFloor", cFloor);
    	model.addAttribute("cYear", cYear);
	    model.addAttribute("cMonth", cMonth);

		return returnurl;
	}
    
    @RequestMapping(value="/data/inputWrite.do")
	public String inputWrite(CommandMap commandMap, ModelMap model, HttpServletRequest request) throws Exception{
		String returnurl = "input/inputWrite";
		
		String gubun = (String)commandMap.get("gubun");
		String cFloor = (String)commandMap.get("cFloor");
		String cYear = (String)commandMap.get("cYear");
		String cMonth = (String)commandMap.get("cMonth");
		
		// 테이블 추가시 gubun, gubunName 항목 추가
		if(gubun == null || gubun.equals("")) {
			model.addAttribute("gubun", "gas");
			model.addAttribute("gubunName", "가스");
		} else if(gubun.equals("gas")) {
			model.addAttribute("gubun", "gas");
			model.addAttribute("gubunName", "가스");
		} else if(gubun.equals("water")) {
			model.addAttribute("gubun", "water");
			model.addAttribute("gubunName", "유류");
		} else if(gubun.equals("electric")) {
			model.addAttribute("gubun", "electric");
			model.addAttribute("gubunName", "전기");
		}
		if(cFloor == null || cFloor.equals("")) {
			model.addAttribute("cFloor", "4");
		} else {
			model.addAttribute("cFloor", cFloor);
		}
		
		return returnurl;
	}
    
    @RequestMapping(value="/data/inputWriteProc.do")
	@ResponseBody
	public String inputWriteProc(CommandMap commandMap, HttpServletRequest request, ModelMap model) throws Exception{
		
		String rtn = "";
		
		String sqlid = "data.inputWriteProc";
		
		// 테이블 추가시 sTable 항목 추가
		String gubun = (String)commandMap.get("gubun");
		if(gubun.equals("gas")) {
			commandMap.put("sTable", "TB_GAS2");
		} else if(gubun.equals("water")) {
			commandMap.put("sTable", "TB_WATER2");
		} else if(gubun.equals("electric")) {
			commandMap.put("sTable", "TB_ELECTRIC2");
		}
		
		String C_YYYYMMDD = (String)commandMap.get("C_YYYYMMDD");
		C_YYYYMMDD = C_YYYYMMDD.replaceAll("-", "");
		commandMap.put("C_YYYYMMDD", C_YYYYMMDD);
		
		String I_USE_PAY = (String)commandMap.get("I_USE_PAY");
		if(I_USE_PAY == null || I_USE_PAY.equals("")) {
			commandMap.put("I_USE_PAY", 0);
		}

		try{
			Map<String, Object> map = commandMap.getMap();
			commonService.insert(map, sqlid);
			
			rtn = "SUCCESS";
		}catch(Exception e){
			rtn = "FAIL";
		}
		
	    return rtn;
	}
    
    @RequestMapping(value="/data/inputUpdate.do")
	public String inputUpdate(CommandMap commandMap, ModelMap model, HttpServletRequest request) throws Exception{
		String returnurl = "input/inputUpdate";
		String sqlid = "data.inputUpdate";
		
		String C_GUBUN = (String)commandMap.get("C_GUBUN");
		
		// 테이블 추가시 sTable 항목 추가
		if(C_GUBUN.equals("gas")) {
			commandMap.put("sTable", "TB_GAS2");
		} else if(C_GUBUN.equals("water")) {
			commandMap.put("sTable", "TB_WATER2");
		} else if(C_GUBUN.equals("electric")) {
			commandMap.put("sTable", "TB_ELECTRIC2");
		}
		
		String C_YYYYMMDD = (String)commandMap.get("C_YYYYMMDD");
		C_YYYYMMDD = C_YYYYMMDD.replaceAll("-", "");
		commandMap.put("C_YYYYMMDD", C_YYYYMMDD);
		
		Map<String,Object> resultMap = commonService.select(commandMap.getMap(), sqlid);
	
		model.addAttribute("map",resultMap);
		
		return returnurl;
	}

    @RequestMapping(value = "/getWheater.do")
    @ResponseBody
    public Map<?, ?> getWheater(HttpServletRequest request) throws Exception {
    	String sqlid = "data.getWeather";
    	
    	Map<String, List> resultList = new HashMap<String, List>(); 

    	Map<String,Object> map = new HashMap<String,Object>();
    	resultList.put("results", commonService.selectlist(map, sqlid));
    	
    	return resultList;
    }
    
    @RequestMapping(value="/data/updateXbim.do")
	public String updateXbim(CommandMap commandMap, ModelMap model, HttpServletRequest request) throws Exception{
		String returnurl = "input/updateXbim";
		
		return returnurl;
	}
    
    @RequestMapping(value = "/data/selectDataDescList.do")
    @ResponseBody
    public List<Map<String, Object>> selectDataDesc(HttpServletRequest request) throws Exception {
    	
    	String sqlid = "data.selectDataDescList";
    	
    	String C_SLAVE = request.getParameter("c_slave");
    	Map<String,Object> map = new HashMap<String,Object>();
    	map.put("C_SLAVE", C_SLAVE);
    	
    	List<Map<String, Object>> list = null;
    	try {
    		list = commonService.selectlist(map, sqlid);

    	}catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

    	return list;
	}
    
	@RequestMapping(value = "/data/selectDataDescOne.do")
	@ResponseBody
	public Map<?,?> selectDataDescOne(HttpServletRequest request) throws Exception {

    	String sqlid = "data.selectDataDescOne";

    	Map<String,Object> map = new HashMap<String,Object>();
    	String C_MASTER = request.getParameter("c_master");
    	String C_SLAVE = request.getParameter("c_slave");
    	String C_SLAVE1 = request.getParameter("c_slave1");
    	String I_NUM = request.getParameter("i_num");
    	map.put("C_MASTER", C_MASTER);
    	map.put("C_SLAVE", C_SLAVE);
    	map.put("C_SLAVE1", C_SLAVE1);
    	map.put("I_NUM", I_NUM);

    	Map<String, Object> result = commonService.select(map, sqlid);
    	
		return result;
	}
	
	@RequestMapping(value="/data/updateDataDescOne.do")
	@ResponseBody
	public String updateDataDescOne(CommandMap commandMap, HttpServletRequest request, ModelMap model) throws Exception{
		
		String rtn = "";
		
		String sqlid = "data.updateDataDescOne";
		

		try{
			Map<String, Object> map = commandMap.getMap();
			commonService.insert(map, sqlid);
			
			rtn = "SUCCESS";
		}catch(Exception e){
			rtn = "FAIL";
		}
		
	    return rtn;
	}
}