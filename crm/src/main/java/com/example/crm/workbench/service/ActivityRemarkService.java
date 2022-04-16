package com.example.crm.workbench.service;

import com.example.crm.workbench.entity.ActivityRemark;

import java.util.List;

public interface ActivityRemarkService {
    List<ActivityRemark>  queryActivityRemarkByActivityId(String id);

    int saveCreateActivityRemark(ActivityRemark activityRemark);

    int deleteActivityRemarkById(String id);

    ActivityRemark queryActivityRemarkById(String id);

    int saveEditActivityRemark(ActivityRemark activityRemark);
}
