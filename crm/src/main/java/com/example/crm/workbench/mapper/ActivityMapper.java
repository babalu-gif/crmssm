package com.example.crm.workbench.mapper;

import com.example.crm.workbench.entity.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbg.generated Tue Mar 22 11:05:30 CST 2022
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbg.generated Tue Mar 22 11:05:30 CST 2022
     */
    int insert(Activity record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbg.generated Tue Mar 22 11:05:30 CST 2022
     */
    int insertSelective(Activity record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbg.generated Tue Mar 22 11:05:30 CST 2022
     */
    Activity selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbg.generated Tue Mar 22 11:05:30 CST 2022
     */
    int updateByPrimaryKeySelective(Activity record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbg.generated Tue Mar 22 11:05:30 CST 2022
     */
    int updateByPrimaryKey(Activity record);

    /**
     *
     * param 查询条件
     * @return 符合条件的数据
     */
    List<Activity> selectPaginationActivities(Activity activity);

    /**
     * 根据活动id删除市场活动
     * @param ids 市场活动的id
     * @return 成功删除的市场活动条数
     */
    int deleteActivityByIds(String[] ids);

    /**
     * 查询所有的市场活动
     * @return 所有的市场活动
     */
    List<Activity> selectAllActivities();

    /**
     * 根据id查询市场活动
     * @param ids
     * @return
     */
    List<Activity> selectActivitiesByIds(String[] ids);

    /**
     * 批量保存创建市场活动
     * @param activityList
     * @return
     */
    int insertActivities(List<Activity> activityList);

    /**
     * 根据id查询市场活动的详细信息
     * @param id
     * @return
     */
    Activity selectForDetailById(String id);

    /**
     * 根据clueId查询与其关联的市场活动
     * @param clueId
     * @return
     */
    List<Activity> selectActivityForDetailByClueId(String clueId);

    /**
     * 根据name模糊查询市场活动，并且把已经根clueId关联过的市场活动排除
     * @param map
     * @return
     */
    List<Activity> selectActivityForDetailByNameClueId(Map<String, Object> map);

    /**
     * 根据ids查询市场活动的明细信息
     * @param ids
     * @return
     */
    List<Activity> selectActivityForDetailByIds(String[] ids);

    /**
     * 根据name模糊查询市场活动，并且和clueId关联过的
     * @param map
     * @return
     */
    List<Activity> selectActivityForConvertByNameClueId(Map<String, Object> map);

    /**
     * 根据市场活动的名称模糊查询市场活动
     * @param activityName
     * @return
     */
    List<Activity> selectActivityByName(String activityName);

    /**
     * 根据contactsId查询关联的市场活动
     * @param contactsId
     * @return
     */
    List<Activity> selectActivityForDetailByContactsId(String contactsId);

    /**
     * 根据contactsId和市场活动名称查询未关联市场活动
     * @param map
     * @return
     */
    List<Activity> selectActivityForDetailByNameContactsId(Map<String, Object> map);
}