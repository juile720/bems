package com.ean.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository("commonDAO")
public class CommonDAO extends AbstractDAO{

	@SuppressWarnings("unchecked")
	public Map<String, Object> selectFileInfo(Map<String, Object> map) throws Exception{
		return (Map<String, Object>)selectOne("common.selectFileInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectUser(Map<String, Object> map) throws Exception{
		return (Map<String, Object>)selectOne("login.selectuser", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> select(Map<String, Object> map, String sqlid) throws Exception{
		return (Map<String, Object>)selectOne(sqlid, map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectList(Map<String, Object> map, String sqlid) throws Exception{
		return (List<Map<String, Object>>)selectList(sqlid, map);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> selectpaginglist(Map<String, Object> map, String sqlid) throws Exception{
		return (Map<String, Object>)selectPagingList(sqlid, map);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> selectBoardDetail(Map<String, Object> map, String sqlid) throws Exception{
		return (Map<String, Object>) selectOne(sqlid, map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectFileList(Map<String, Object> map, String sqlid) throws Exception{
		return (List<Map<String, Object>>)selectList(sqlid, map);
	}
	
	public void updateHitCnt(Map<String, Object> map, String sqlid) throws Exception{
		update(sqlid, map);
	}
	
	public void insert(Map<String, Object> map, String sqlid) throws Exception{
		insert(sqlid, map);
	}
	
	public void update(Map<String, Object> map, String sqlid) throws Exception{
		update(sqlid, map);
	}
	
	public void delete(Map<String, Object> map, String sqlid) throws Exception{
		delete(sqlid, map);
	}
	
	public void insertFile(Map<String, Object> map, String sqlid) throws Exception{
		insert(sqlid, map);
	}
	
	public void commonupdate(Map<String, Object> map, String sqlid) throws Exception{
		update(sqlid, map);
	}
}
