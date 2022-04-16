package com.example.crm.workbench.web.controller;

import com.example.crm.workbench.entity.FunnelVO;
import com.example.crm.workbench.service.TranService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
public class ChartsController {

    @Autowired
    private TranService tranService;

    @RequestMapping("/workbench/chart/transaction/toTranIndex.do")
    public String toTranIndex(){
        return "workbench/chart/transaction/index";
    }

    @RequestMapping("/workbench/chart/transaction/queryCountOfTranGroupByStage.do")
    @ResponseBody
    public Object queryCountOfTranGroupByStage(){
        // 调用service层方法，查询数据
        List<FunnelVO> funnelVOList = tranService.queryCountOfTranGroupByStage();
        // 根据查询结果，返回响应信息
        return  funnelVOList;
    }
}
