package com.example.crm.settings.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class WorkbenchController {

    @RequestMapping("/settings/index.do")
    public String index(){
        return "settings/index";
    }
}
