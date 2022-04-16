package com.example.crm.workbench.service.impl;

import com.example.crm.workbench.entity.Activity;
import com.example.crm.workbench.mapper.ActivityMapper;
import com.example.crm.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;


@Service
public class ActivityServiceImpl implements ActivityService {

    @Autowired
    private ActivityMapper activityMapper;

    @Override
    public int saveCreateActivity(Activity activity) {
        return activityMapper.insert(activity);
    }

    @Override
    public List<Activity> queryPaginationActivities(Activity activity) {
        List<Activity> activityList = activityMapper.selectPaginationActivities(activity);
        return activityList;
    }

    @Override
    public int deleteActivityByIds(String[] ids) {
        return activityMapper.deleteActivityByIds(ids);
    }

    @Override
    public Activity queryActivityById(String id) {
        Activity activity = activityMapper.selectByPrimaryKey(id);
        activity.setCreateBy(null);
        activity.setCreateTime(null);
        activity.setEditBy(null);
        activity.setEditTime(null);
        return activity;
    }

    @Override
    public int editActivity(Activity activity) {
        return activityMapper.updateByPrimaryKeySelective(activity);
    }

    @Override
    public List<Activity> queryAllActivities() {
        return activityMapper.selectAllActivities();
    }

    @Override
    public List<Activity> queryActivitiesByIds(String[] ids) {
        return activityMapper.selectActivitiesByIds(ids);
    }

    @Override
    public int saveCreateActivities(List<Activity> activityList) {
        return activityMapper.insertActivities(activityList);
    }

    @Override
    public Activity queryActivityDetail(String id) {
        return activityMapper.selectForDetailById(id);
    }

    @Override
    public List<Activity> queryActivityForDetailByClueId(String clueId) {
        return activityMapper.selectActivityForDetailByClueId(clueId);
    }

    @Override
    public List<Activity> queryActivityForDetailByNameClueId(Map<String, Object> map) {
        return activityMapper.selectActivityForDetailByNameClueId(map);
    }

    @Override
    public List<Activity> queryActivityForDetailByIds(String[] ids) {
        return activityMapper.selectActivityForDetailByIds(ids);
    }

    @Override
    public List<Activity> queryActivityForConvertByNameClueId(Map<String, Object> map) {
        return activityMapper.selectActivityForConvertByNameClueId(map);
    }

    @Override
    public List<Activity> queryActivityByName(String activityName) {
        return activityMapper.selectActivityByName(activityName);
    }

    @Override
    public List<Activity> queryActivityForDetailByContactsId(String contactsId) {
        return activityMapper.selectActivityForDetailByContactsId(contactsId);
    }

    @Override
    public List<Activity> queryActivityForDetailByNameContactsId(Map<String, Object> map) {
        return activityMapper.selectActivityForDetailByNameContactsId(map);
    }
}
