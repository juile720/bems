package com.ean.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

public interface CommonService {

	Map<String, Object> selectFileInfo(Map<String, Object> map) throws Exception;

	Map<String, Object> select(Map<String, Object> map, String sqlid) throws Exception;
	
	Map<String, Object> selectpaginglist(Map<String, Object> map, String sqlid) throws Exception;
	
	List<Map<String, Object>> selectlist(Map<String, Object> map, String sqlid) throws Exception;

	void insert(Map<String, Object> map, String sqlid) throws Exception;
	
	void update(Map<String, Object> map, String sqlid) throws Exception;
	
	void commonupdate(Map<String, Object> map, String sqlid) throws Exception;

	void delete(Map<String, Object> map, String sqlid) throws Exception;

	Map<String, Object> selectBoardDetail(Map<String, Object> map, String sqlid) throws Exception;
	
	void insertBoard(Map<String, Object> map, HttpServletRequest request, String sqlid, String sqlid1) throws Exception;

}
