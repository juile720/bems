package com.ean.graph.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ean.common.CommandMap;
import com.ean.graph.service.ChartService;
import com.ean.util.CommonUtils;

@Controller
public class graphController {
	Logger log = Logger.getLogger(this.getClass());
		
    @Autowired
    ChartService chartService;
    
    @RequestMapping("/totalmiddle.do")
    @ResponseBody
    public dataVO totalmiddle(HttpServletRequest request) {
    	String gb = request.getParameter("gb");

    	String day1 = request.getParameter("day1");
    	day1 = day1.replaceAll("/", "");
    	String day2 = request.getParameter("day2");
    	day2 = day2.replaceAll("/", "");
    	
        return chartService.getTotalPageMid(gb, day1, day2);
    }
    
    
    @RequestMapping("/pagetopGraph.do")
    @ResponseBody
    public dataVO showLineChart1(HttpServletRequest request) {
    	return chartService.getTotalPageTopGraph();
    }
    
    @RequestMapping("/pagebottomGraph.do")
    @ResponseBody
    public dataVO showLineChart3() {
        return chartService.getTotalPageBottomGraph();
    }
    
    @RequestMapping("/pageEnergyGraph.do")
    @ResponseBody
    public dataVO showEnegyChart1(CommandMap commandMap,HttpServletRequest request) {
    	String gb = request.getParameter("gb");
    	String day1 = request.getParameter("day1");
    	
    	if (!CommonUtils.nullCheckbf(day1)){
    		day1 = day1.replaceAll("/", "");
    	}
    	
    	String day2 = request.getParameter("day2");
    	if (!CommonUtils.nullCheckbf(day2)){
    		day2 = day2.replaceAll("/", "");
    	}

		return chartService.getEnergyFirstGraph(gb, day1, day2);
		
    }
    
    @RequestMapping("/pageResourceGraph1.do")
    @ResponseBody
    public dataVO showResourceChartFirst(CommandMap commandMap,HttpServletRequest request) {
    	String gb = request.getParameter("gb");
    	String day1 = request.getParameter("day1");
    	
    	if (!CommonUtils.nullCheckbf(day1)){
    		day1 = day1.replaceAll("/", "");
    	}
    	
    	String day2 = request.getParameter("day2");
    	if (!CommonUtils.nullCheckbf(day2)){
    		day2 = day2.replaceAll("/", "");
    	}

		return chartService.getEnergyFirstGraph(gb, day1, day2);
		
    }
    
    @RequestMapping("/pageResourceGraph2.do")
    @ResponseBody
    public dataVO showResourceChartSecond(CommandMap commandMap,HttpServletRequest request) {
    	String gb = request.getParameter("gb");
    	String day1 = request.getParameter("day1");
    	
    	if (!CommonUtils.nullCheckbf(day1)){
    		day1 = day1.replaceAll("/", "");
    	}
    	
    	String day2 = request.getParameter("day2");
    	if (!CommonUtils.nullCheckbf(day2)){
    		day2 = day2.replaceAll("/", "");
    	}

		return chartService.getEnergyFirstGraph(gb, day1, day2);
		
    }
    
    @RequestMapping("/pageEResourceGraph1.do")
    @ResponseBody
    public dataVO showEResourceChart(HttpServletRequest request) {
    	String gb = request.getParameter("gb");
    	String day1 = request.getParameter("day1");
    	
    	if (!CommonUtils.nullCheckbf(day1)){
    		day1 = day1.replaceAll("/", "");
    	}
    	
    	String day2 = request.getParameter("day2");
    	if (!CommonUtils.nullCheckbf(day2)){
    		day2 = day2.replaceAll("/", "");
    	}

		return chartService.getEnergyResourceFirstGraph(gb, day1, day2);
		
    }
    
    @RequestMapping("/pageEResourceGraph2.do")
    @ResponseBody
    public dataVO showEResourceChartSecond(HttpServletRequest request) {
    	Calendar cal = Calendar.getInstance();
    	//현재 년도, 월, 일
    	int year = cal.get ( cal.YEAR );
    	int month = cal.get ( cal.MONTH ) + 1 ;
    	int date = cal.get ( cal.DATE ) ;
    	
    	String gb = request.getParameter("gb");
    	String day1 = request.getParameter("day1");
    	String day2 = "";
    	
    	if (!CommonUtils.nullCheckbf(gb)){
        	if (gb.equals("1")){
            	if (!CommonUtils.nullCheckbf(day1)){
            		String tmp[] = day1.split("-");
            		day1 = Integer.toString(Integer.parseInt(tmp[0]) - 1) + tmp[1];
            		day2 = tmp[0] + tmp[1];
            	}else{
            		if (Integer.toString(month).length() < 2){
            			day1 = Integer.toString(year - 1) + "0" + Integer.toString(month);
            			day2 = Integer.toString(year) + "0" + Integer.toString(month);
            		}else{
            			day1 = Integer.toString(year - 1) + Integer.toString(month);	
            			day2 = Integer.toString(year) +  Integer.toString(month);
            		}
            		
            	}
        	}else{
            	if (!CommonUtils.nullCheckbf(day1)){
            		String tmp[] = day1.split("-");
            		day1 = Integer.toString(Integer.parseInt(tmp[0]) - 1) + tmp[1];
            		day2 = tmp[0] + tmp[1];
            	}else{
            		if (Integer.toString(month).length() < 2){
            			day1 = Integer.toString(year - 1) + "0" + Integer.toString(month);
            			day2 = Integer.toString(year) + "0" + Integer.toString(month);
            		}else{
            			day1 = Integer.toString(year - 1) + Integer.toString(month);	
            			day2 = Integer.toString(year) +  Integer.toString(month);
            		}
            		
            	}
        	}
    	}else{
        	if (!CommonUtils.nullCheckbf(day1)){
        		String tmp[] = day1.split("-");
        		day1 = Integer.toString(Integer.parseInt(tmp[0]) - 1) + tmp[1];
        		day2 = tmp[0] + tmp[1];
        	}else{
        		if (Integer.toString(month).length() < 2){
        			day1 = Integer.toString(year - 1) + "0" + Integer.toString(month);
        			day2 = Integer.toString(year) + "0" + Integer.toString(month);
        		}else{
        			day1 = Integer.toString(year - 1) + Integer.toString(month);	
        			day2 = Integer.toString(year) +  Integer.toString(month);
        		}
        		
        	}
    	}

		return chartService.getEnergyResourceSecondGraph(day1, day2);
		
    }
    
    @RequestMapping("/pageEResourceGraph3.do")
    @ResponseBody
    public dataVO showEResourceChartThird(HttpServletRequest request) {
    	Calendar cal = Calendar.getInstance();
    	//현재 년도, 월, 일
    	int year = cal.get ( cal.YEAR );
    	int month = cal.get ( cal.MONTH ) + 1 ;
    	int date = cal.get ( cal.DATE ) ;
    	
    	String day1 = request.getParameter("day1");
    	if (!CommonUtils.nullCheckbf(day1)){
    		String tmp[] = day1.split("-");
    		day1 = Integer.toString(Integer.parseInt(tmp[0]) - 1) + tmp[1];
    	}else{
    		if (Integer.toString(month).length() < 2){
    			day1 = Integer.toString(year) + "0" + Integer.toString(month);
    		}else{
    			day1 = Integer.toString(year) + Integer.toString(month);	
    		}
    		
    	}
    	
    	return chartService.getEnergyResourceThridGraph(day1);
    }
    
    @RequestMapping("/pageEResourceGraph4.do")
    @ResponseBody
    public dataVO showEResourceChartForth(HttpServletRequest request) {
    	Calendar cal = Calendar.getInstance();
    	//현재 년도, 월, 일
    	int year = cal.get ( cal.YEAR );
    	int month = cal.get ( cal.MONTH ) + 1 ;
    	int date = cal.get ( cal.DATE ) ;
    	
    	String day1 = request.getParameter("day1");
    	if (!CommonUtils.nullCheckbf(day1)){
    		String tmp[] = day1.split("-");
    		day1 = Integer.toString(Integer.parseInt(tmp[0])) + tmp[1];
    	}else{
    		if (Integer.toString(month).length() < 2){
    			day1 = Integer.toString(year) + "0" + Integer.toString(month);
    		}else{
    			day1 = Integer.toString(year) + Integer.toString(month);	
    		}
    		
    	}
    	
    	return chartService.getEnergyResourceForthGraph(day1);
    }
    
    @RequestMapping("/pageFloorTemp.do")
    @ResponseBody
    public dataVO showFloorTemp(HttpServletRequest request) {
    	Calendar cal = Calendar.getInstance();
    	//현재 년도, 월, 일
    	int year = cal.get ( cal.YEAR );
    	
    	return chartService.getFloorTemp(Integer.toString(year));
    }
    
    @RequestMapping("/pageFloorGrapgh.do")
    @ResponseBody
    public dataVO showFloorGraph(HttpServletRequest request) {
    	Calendar cal = Calendar.getInstance();
    	//현재 년도, 월, 일
    	int year = cal.get ( cal.YEAR );
    	
    	return chartService.getFloorkwh(Integer.toString(year));
    }
}
