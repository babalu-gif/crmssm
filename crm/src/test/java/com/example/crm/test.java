package com.example.crm;

import com.example.crm.workbench.entity.Activity;
import com.example.crm.workbench.service.ActivityService;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class test {

    @Autowired
    private ActivityService activityService;

    @Test
    public void test(){
        Map<String, Object> map = new HashMap<>();
        map.put("activityName", "测试");
        map.put("clueId", "02ed754f4c4247e585b63ca49bdd7be2");
        List<Activity> activityList = activityService.queryActivityForDetailByNameClueId(map);
        for (Activity activity : activityList){
            System.out.println(activity.getName());
        }
    }
}
