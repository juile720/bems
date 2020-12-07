package com.ean.data.controller;

import org.codehaus.jackson.annotate.JsonProperty;

public class SeriesBean {
    @JsonProperty("name")
    private String name;
    @JsonProperty("color")
    private String color;
    @JsonProperty("data")
    private double[] data;
    @JsonProperty("type")
    private String type;

    public String getType() {
		return type;
	}


	public void setType(String type) {
		this.type = type;
	}


	public SeriesBean(String name, String color, String type, double[] data) {
      this.name = name;
      this.color = color;
      this.data = data;
      this.type = type;
    }


    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public double[] getData() {
        return data;
    }

    public void setData(double[] data) {
        this.data = data;
    }
}
