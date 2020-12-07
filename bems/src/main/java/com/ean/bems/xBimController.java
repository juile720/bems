package com.ean.bems;
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

@Controller
public class xBimController {
	Logger log = Logger.getLogger(this.getClass());
	
	@Resource(name="commonService")
	private CommonService commonService;
    
	@RequestMapping(value = "/xBim.do")
    public String xBim(CommandMap commandMap, ModelMap model) throws Exception {
    	String returnurl = "input/Xbim";
		return returnurl;
    }
	
	@RequestMapping(value = "/xBimView.do")
    public String xBimView(CommandMap commandMap, ModelMap model) throws Exception {
    	String returnurl = "input/XbimView";
		return returnurl;
    }
	
    @RequestMapping(value = "/selectDataList.do")
    @ResponseBody
    public List<Map<String, Object>> selectDataList(HttpServletRequest request) throws Exception {
    	
    	String sqlid = "data.selectDataList";
    	String day1 = null;
    	
    	Calendar cal = Calendar.getInstance();
    	//현재 년도, 월, 일
    	int year = cal.get ( cal.YEAR );
    	int month = cal.get ( cal.MONTH ) + 1 ;
    	int date = cal.get ( cal.DATE ) ;
    	int hour = cal.get(Calendar.HOUR_OF_DAY);
    	int minute = cal.get(Calendar.MINUTE);
    	
    	String C_SLAVE = request.getParameter("c_slave");
    	Map<String,Object> map = new HashMap<String,Object>();
    	map.put("C_SLAVE", C_SLAVE);
    	
    	if (Integer.toString(month).length() < 2){
			day1 = Integer.toString(year) + "0" + Integer.toString(month);
		}else{
			day1 = Integer.toString(year) + Integer.toString(month);
		}
    	
    	if (Integer.toString(date).length() < 2){
    		day1 = day1 + "0" + Integer.toString(date);
    	}else{
    		day1 = day1 + Integer.toString(date);
    	}
    	
    	if (Integer.toString(hour).length() < 2){
    		day1 = day1 + "0" + Integer.toString(hour);
    	}else{
    		day1 = day1 + Integer.toString(hour);
    	}
    	
    	if (minute >= 0 && minute < 15 ){
    		day1 = day1 + "00";
    	}
    	if (minute >= 15 && minute < 30 ){
    		day1 = day1 + "15";
    	}
    	if (minute >= 30 && minute < 45 ){
    		day1 = day1 + "30";
    	}
    	if (minute >= 45 && minute < 59 ){
    		day1 = day1 + "45";
    	}
    	map.put("DT", day1);
    	
    	List<Map<String, Object>> list = null;
    	try {
    		list = commonService.selectlist(map, sqlid);

    	}catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

    	return list;
	}
}	