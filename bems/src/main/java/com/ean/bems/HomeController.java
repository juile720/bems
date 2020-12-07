package com.ean.bems;

import java.text.DateFormat;
import java.util.Date;
import java.util.Locale;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.RequestContextHolder;

import com.ean.common.CommandMap;
import com.ean.service.CommonService;
import com.ean.util.CommonUtils;
/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {
	
	@RequestMapping(value="/total.do")
	public String login(CommandMap commandMap, ModelMap model) throws Exception{
		String returnurl = "bems/building_total";
		return returnurl;
	}
}
