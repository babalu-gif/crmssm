package com.example.crm.workbench.web.controller;

import com.example.crm.commons.contants.Contants;
import com.example.crm.commons.entity.ReturnObject;
import com.example.crm.commons.utils.DateUtils;
import com.example.crm.commons.utils.UUIDUtils;
import com.example.crm.settings.entity.DicValue;
import com.example.crm.settings.entity.User;
import com.example.crm.settings.service.DicValueService;
import com.example.crm.settings.service.UserService;
import com.example.crm.workbench.entity.Activity;
import com.example.crm.workbench.entity.Clue;
import com.example.crm.workbench.entity.ClueActivityRelation;
import com.example.crm.workbench.entity.ClueRemark;
import com.example.crm.workbench.service.ActivityService;
import com.example.crm.workbench.service.ClueActivityRelationService;
import com.example.crm.workbench.service.ClueRemarkService;
import com.example.crm.workbench.service.ClueService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.*;

@Controller
public class ClueController {

    @Autowired
    private DicValueService dicValueService;
    @Autowired
    private UserService userService;
    @Autowired
    private ActivityService activityService;
    @Autowired
    private ClueService clueService;
    @Autowired
    private ClueRemarkService clueRemarkService;
    @Autowired
    private ClueActivityRelationService clueActivityRelationService;

    @RequestMapping("/workbench/clue/index.do")
    public String index(HttpServletRequest request){
        // 调用service层，查询动态数据
        List<User> userList = userService.queryAllUsers();
        List<DicValue> appellationList = dicValueService.queryDicValueByTypeCode("appellation");
        List<DicValue> clueStateList = dicValueService.queryDicValueByTypeCode("clueState");
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");

        // 将数据存储到request作用域中
        request.setAttribute("userList", userList);
        request.setAttribute("appellationList", appellationList);
        request.setAttribute("clueStateList", clueStateList);
        request.setAttribute("sourceList", sourceList);
        // 请求转发
        return "workbench/clue/index";
    }

    @RequestMapping("/workbench/clue/Pagination.do")
    @ResponseBody
    public PageInfo<Clue> Pagination(Integer page, Integer pageSize, Clue clue){
        PageHelper.startPage(page, pageSize);
        List<Clue> clueList = clueService.queryPaginationClues(clue);
        PageInfo<Clue> pageInfo = new PageInfo<>(clueList);
        return pageInfo;
    }

    @RequestMapping("/workbench/clue/saveCreateClue.do")
    @ResponseBody
    public Object saveCreateClue(Clue clue, HttpSession session){
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        clue.setId(UUIDUtils.getUUID());
        clue.setCreateBy(user.getName());
        clue.setCreateTime(DateUtils.formateDateTime(new Date()));
        ReturnObject returnObject = new ReturnObject();
        try {
            int result = clueService.saveCreateClue(clue);
            if (result > 0){
                returnObject.setCode(Contants.RETURN_OBJECT_SUCCESS);
            } else {
                returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
            }
        } catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
        }

        return returnObject;
    }

    @RequestMapping("/workbench/clue/deleteClueByIds.do")
    @ResponseBody
    public Object deleteClueByIds(String[] id){
        ReturnObject returnObject = new ReturnObject();
        try {
            clueService.deleteClueByIds(id);
            returnObject.setCode(Contants.RETURN_OBJECT_SUCCESS);
            returnObject.setMessage("删除成功");
        } catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
        }

        return returnObject;
    }

    @RequestMapping("/workbench/clue/queryClueById.do")
    @ResponseBody
    public Clue queryClueById(String id){
        Clue clue = clueService.queryClueById(id);
        return clue;
    }

    @RequestMapping("/workbench/clue/saveEditClue.do")
    @ResponseBody
    public Object saveEditClue(Clue clue, HttpSession session){
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();
        clue.setEditTime(DateUtils.formateDateTime(new Date()));
        clue.setEditBy(user.getName());
        try {
            int result = clueService.editClueById(clue);
            if (result > 0){
                returnObject.setCode(Contants.RETURN_OBJECT_SUCCESS);
                returnObject.setMessage("更新成功");
            } else {
                returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
            }
        } catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
        }

        return returnObject;
    }

    @RequestMapping("/workbench/clue/detailClue.do")
    public String detailClue(String id, HttpServletRequest request){
        // 调用service层方法，查询数据
       Clue clue = clueService.queryClueOwnerById(id);
       List<ClueRemark> remarkList = clueRemarkService.queryClueRemarkByClueId(id);
       List<Activity> activityList = activityService.queryActivityForDetailByClueId(id);
       // 将查询出的数据保存到request作用域中
       request.setAttribute("clue", clue);
       request.setAttribute("remarkList", remarkList);
       request.setAttribute("activityList", activityList);

       return "workbench/clue/detail";
    }

    @RequestMapping("/workbench/clue/queryActivityForDetailByNameClueId.do")
    @ResponseBody
    public Object queryActivityForDetailByNameCLueId(String activityName, String clueId){
        // 封装参数
        Map<String, Object> map = new HashMap<>();
        map.put("activityName", activityName);
        map.put("clueId", clueId);
        // 调用service层方法，查询市场活动
        List<Activity> activityList = activityService.queryActivityForDetailByNameClueId(map);
        // 根据查询结果，返回响应信息
        return activityList;
    }

    @RequestMapping("/workbench/clue/saveBund.do")
    @ResponseBody
    public Object saveBund(String[] activityId, String clueId){
        ReturnObject returnObject = new ReturnObject();
        // 封装参数
        ClueActivityRelation car = null;
        List<ClueActivityRelation> list = new ArrayList<>();

        for (String aid : activityId){
            car = new ClueActivityRelation();
            car.setId(UUIDUtils.getUUID());
            car.setClueId(clueId);
            car.setActivityId(aid);
            list.add(car);
        }

        // 调用service层方法，保存创建市场活动与线索的关联
        try {
            int result = clueActivityRelationService.saveCreateActivityClueRelationByList(list);
            if (result > 0){
                returnObject.setCode(Contants.RETURN_OBJECT_SUCCESS);

                List<Activity> activityList = activityService.queryActivityForDetailByIds(activityId);
                returnObject.setRetData(activityList);
            } else {
                returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
            }
        } catch (Exception e){
            returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
        }

        return returnObject;
    }

    @RequestMapping("/workbench/clue/saveUnbund.do")
    @ResponseBody
    public Object saveUnbund(ClueActivityRelation relation){
        ReturnObject returnObject = new ReturnObject();
        try {
            // 调用service层方法，删除线索和市场活动的关联关系
            int result = clueActivityRelationService.deleteClueActivityRelationByClueIdActivityId(relation);
            if (result > 0){
                returnObject.setCode(Contants.RETURN_OBJECT_SUCCESS);
            } else {
                returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
            }
        } catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
        }
        return returnObject;
    }

    @RequestMapping("/workbench/clue/toConvert.do")
    public String toConvert(String id, HttpServletRequest request){
        // 调用service层方法，查询线索的明细信息
        Clue clue = clueService.queryClueOwnerById(id);
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode("stage");
        // 把数据保存到request作用域中
        request.setAttribute("clue", clue);
        request.setAttribute("stageList", stageList);
        // 请求转发
        return "workbench/clue/convert";
    }

    @RequestMapping("/workbench/clue/queryActivityConvertByNameClueId.do")
    @ResponseBody
    public Object queryActivityConvertByNameClueId(String activityName, String clueId){
        // 封装参数
        Map<String, Object> map = new HashMap<>();
        map.put("activityName", activityName);
        map.put("clueId", clueId);
        // 调用service层方法
        List<Activity> activityList = activityService.queryActivityForConvertByNameClueId(map);
        return activityList;
    }

    @RequestMapping("/workbench/clue/convertClue.do")
    @ResponseBody
    public Object convertClue(String activityId, String clueId, String money, String name, String expectedDate
                              , String stage, String isCreateTran, HttpSession session){
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        // 封装参数
        Map<String, Object> map = new HashMap<>();
        map.put("activityId", activityId);
        map.put("clueId", clueId);
        map.put(Contants.SESSION_USER, user);
        map.put("money", money);
        map.put("name", name);
        map.put("expectedDate", expectedDate);
        map.put("stage", stage);
        map.put("isCreateTran", isCreateTran);
        ReturnObject returnObject = new ReturnObject();
        // 调用service层方法,保存线索转换
       try {
           clueService.saveConvertClue(map);
           returnObject.setCode(Contants.RETURN_OBJECT_SUCCESS);
       } catch (Exception e){
           e.printStackTrace();
           returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
       }

        return returnObject;
    }
}
