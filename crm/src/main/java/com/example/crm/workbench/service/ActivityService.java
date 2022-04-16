package com.example.crm.workbench.service;

import com.example.crm.workbench.entity.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityService {

    int saveCreateActivity(Activity activity);

    List<Activity> queryPaginationActivities(Activity activity);

    int deleteActivityByIds(String[] ids);

    Activity queryActivityById(String id);

    int editActivity(Activity activity);

    List<Activity> queryAllActivities();

    List<Activity> queryActivitiesByIds(String[] ids);

    int saveCreateActivities(List<Activity> activityList);

    Activity queryActivityDetail(String id);

    List<Activity> queryActivityForDetailByClueId(String clueId);

    List<Activity> queryActivityForDetailByNameClueId(Map<String, Object> map);

    List<Activity> queryActivityForDetailByIds(String[] ids);

    List<Activity> queryActivityForConvertByNameClueId(Map<String, Object> map);

    List<Activity> queryActivityByName(String activityName);

    List<Activity> queryActivityForDetailByContactsId(String contactsId);

    List<Activity> queryActivityForDetailByNameContactsId(Map<String, Object> map);
}
