package com.example.crm.workbench.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class WorkbenchIndexController {

    @RequestMapping("/workbench/toIndex.do")
    public String toIndex(){
        return "workbench/index";
    }

    @RequestMapping("/workbench/main/main_toIndex.do")
    public String main_toIndex(){
        return "workbench/main/index";
    }

}
