package com.ean.util;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.Map.Entry;

import org.apache.log4j.Logger;

public class CommonUtils {
	private static final Logger log = Logger.getLogger(CommonUtils.class);
	
	public static String getRandomString(){
		return UUID.randomUUID().toString().replaceAll("-", "");
	}
	
	public static void printMap(Map<String,Object> map){
		Iterator<Entry<String,Object>> iterator = map.entrySet().iterator();
		Entry<String,Object> entry = null;
		log.debug("--------------------printMap--------------------\n");
		while(iterator.hasNext()){
			entry = iterator.next();
			log.debug("key : "+entry.getKey()+",\tvalue : "+entry.getValue());
		}
		log.debug("");
		log.debug("------------------------------------------------\n");
	}
	
	public static void printList(List<Map<String,Object>> list){
		Iterator<Entry<String,Object>> iterator = null;
		Entry<String,Object> entry = null;
		log.debug("--------------------printList--------------------\n");
		int listSize = list.size();
		for(int i=0; i<listSize; i++){
			log.debug("list index : "+i);
			iterator = list.get(i).entrySet().iterator();
			while(iterator.hasNext()){
				entry = iterator.next();
				log.debug("key : "+entry.getKey()+",\tvalue : "+entry.getValue());
			}
			log.debug("\n");
		}
		log.debug("------------------------------------------------\n");
	}
	
    public static String nullCheck(String str)
    {
    	if(str == null || str.equals("all") || str.equals("null")) 	{

    		str = "";
    	}

    	return str.trim();
    }
    
    public static String nullCheck(Object str) {
    	if(str ==null) return "";
    	if(str instanceof String) return nullCheck((String) str);
    	else return "";
    	
    }
    
    public static boolean nullCheckbf(Object str) {
    	if(str ==null) return true;
    	else return false;
    	
    }
    
    public static String[] nullCheck(String[] str) { // 2003.04.30 이종옥
        if (str==null || str.length == 0)
            return null;
        String[] rtn = new String[str.length];
        for (int i = 0; i<str.length; i++)
            rtn[i] = nullCheck(str[i]);
        return rtn;
    }
    
    public static boolean isNull(String str)
    {
    	if(str == null || str.equals("") || str.equals("all") || str.equals("null") )
    	{
    		return false;
    	}
    	else
    	{
    		return true;
    	}
    }
    
    public static Date getYesterday ( Date today ) {
    	 if ( today == null ) throw new IllegalStateException ( "today is null" );
    	 Date yesterday = new Date ( );
    	 yesterday.setTime ( today.getTime ( ) - ( (long) 1000 * 60 * 60 * 24 ) );
    	 return yesterday;
    	}



}
