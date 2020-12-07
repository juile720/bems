package com.ean.data.controller;
import org.codehaus.jackson.map.annotate.JsonRootName;
import java.util.List;

@JsonRootName("dataVO")

public class dataVO {
	
	private List<SeriesBean> series;
	private List<String> categories;
	
	public dataVO(List<String> categories, List<SeriesBean> series){
        this.setCategories(categories);
        this.setSeries(series);
	}
	
	public List<SeriesBean> getSeries() {
		return series;
	}

	public void setSeries(List<SeriesBean> series) {
		this.series = series;
	}

	public List<String> getCategories() {
		return categories;
	}
	public void setCategories(List<String> categories) {
		this.categories = categories;
	}
	
	
}
