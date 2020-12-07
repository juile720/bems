package com.ean.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import com.ean.dao.CommonDAO;
import com.ean.util.FileUtils;

@Service("commonService")
public class CommonServiceImpl implements CommonService{
	Logger log = Logger.getLogger(this.getClass());
	
	@Resource(name="fileUtils")
	private FileUtils fileUtils;

	@Resource(name="commonDAO")
	private CommonDAO commonDAO;

	@Override
	public Map<String, Object> selectFileInfo(Map<String, Object> map) throws Exception {
		return commonDAO.selectFileInfo(map);
	}
	
	@Override
	public Map<String, Object> select(Map<String, Object> map, String sqlid) throws Exception {
		return commonDAO.select(map, sqlid);
	}

	@Override
	public Map<String, Object> selectpaginglist(Map<String, Object> map, String sqlid) throws Exception {
		return commonDAO.selectpaginglist(map, sqlid);
	}
	
	@Override
	public List<Map<String, Object>> selectlist(Map<String, Object> map,
			String sqlid) throws Exception {
		// TODO Auto-generated method stub
		return commonDAO.selectList(map, sqlid);
	}
/*
	@Override
	public void insert(Map<String, Object> map, String sqlid, HttpServletRequest request) throws Exception {
		commonDAO.insert(map, sqlid);
		
		//List<Map<String,Object>> list = fileUtils.parseInsertFileInfo(map, request);
		//for(int i=0, size=list.size(); i<size; i++){
		//	sampleDAO.insertFile(list.get(i));
		//}
	}
*/
	@Override
	public void insert(Map<String, Object> map, String sqlid) throws Exception {
		commonDAO.insert(map, sqlid);
	}
	
	@Override
	public void update(Map<String, Object> map, String sqlid) throws Exception {
		commonDAO.updateHitCnt(map, sqlid);		
	}

	@Override
	public void commonupdate(Map<String, Object> map, String sqlid) throws Exception {
		commonDAO.commonupdate(map, sqlid);		
	}
	
	@Override
	public void delete(Map<String, Object> map, String sqlid) throws Exception {
		commonDAO.delete(map, sqlid);
	}

	@Override
	public Map<String, Object> selectBoardDetail(Map<String, Object> map, String sqlid) throws Exception {
		
		String[] values = sqlid.split("\\.");
		
		//System.out.println(values[0]);
		//System.out.println(values[1]);
		
		commonDAO.updateHitCnt(map, values[0] + ".hit" + values[1]);
		Map<String, Object> resultMap = new HashMap<String,Object>();
		Map<String, Object> tempMap = commonDAO.selectBoardDetail(map, sqlid);
		resultMap.put("map", tempMap);
		
		List<Map<String,Object>> list = commonDAO.selectFileList(map, values[0] + ".file" + values[1]);
		resultMap.put("list", list);
		
		return resultMap;
	}

	@Override
	public void insertBoard(Map<String, Object> map, HttpServletRequest request, String sqlid, String sqlid1) throws Exception {
		commonDAO.insert(map, sqlid);
		
		List<Map<String,Object>> list = fileUtils.parseInsertFileInfo(map, request);
		for(int i=0, size=list.size(); i<size; i++){
			commonDAO.insertFile(list.get(i), sqlid1);
		}
	}
}
