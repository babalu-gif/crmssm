package com.example.crm.workbench.web.controller;

import com.example.crm.commons.contants.Contants;
import com.example.crm.commons.entity.ReturnObject;
import com.example.crm.commons.utils.DateUtils;
import com.example.crm.commons.utils.HSSFUtils;
import com.example.crm.commons.utils.UUIDUtils;
import com.example.crm.settings.entity.User;
import com.example.crm.settings.service.UserService;
import com.example.crm.workbench.entity.Activity;
import com.example.crm.workbench.entity.ActivityRemark;
import com.example.crm.workbench.service.ActivityRemarkService;
import com.example.crm.workbench.service.ActivityService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Controller
public class ActivityController {

    @Autowired
    private UserService userService;
    @Autowired
    private ActivityService activityService;
    @Autowired
    private ActivityRemarkService activityRemarkService;

    @RequestMapping("/workbench/activity/index.do")
    public String index(HttpServletRequest request) {
        // 调用service方法，查询所有用户
        List<User> userList = userService.queryAllUsers();
        // 把数据保存到request中
        request.setAttribute("userList", userList);
        // 请求转发到市场活动的主页面
        return "workbench/activity/index";
    }

    @RequestMapping("/workbench/activty/saveCreateActivity.do")
    @ResponseBody
    public Object saveCreateActivity(Activity activity, HttpSession session) {
        activity.setId(UUIDUtils.getUUID());
        activity.setCreateTime(DateUtils.formateDateTime(new Date()));
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        activity.setCreateBy(user.getName());
        ReturnObject returnObject = new ReturnObject();
        try {
            int result = activityService.saveCreateActivity(activity);
            if (result > 0) {
                returnObject.setCode(Contants.RETURN_OBJECT_SUCCESS);
            } else {
                returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
            }
        } catch (Exception e) {
            returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
            e.printStackTrace();
        }

        return returnObject;
    }

    @RequestMapping("/workbench/activity/queryPagination.do")
    @ResponseBody
    public PageInfo<Activity> page(Integer page, Integer pageSize, Activity activity) {
        PageHelper.startPage(page, pageSize);
        List<Activity> activityList = activityService.queryPaginationActivities(activity);
        PageInfo<Activity> pageInfo = new PageInfo<>(activityList);
        return pageInfo;
    }

    @RequestMapping("/workbench/activity/deleteActivityByIds.do")
    @ResponseBody
    public Object deleteActivityByIds(String[] id) {
        ReturnObject returnObject = new ReturnObject();
        // 调用service层方法，删除市场活动
        try {
            int result = activityService.deleteActivityByIds(id);
            if (result > 0) {
                returnObject.setCode(Contants.RETURN_OBJECT_SUCCESS);
            } else {
                returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
        }
        return returnObject;
    }

    @RequestMapping("/workbench/activity/queryActivityById.do")
    @ResponseBody
    public Object queryActivityById(String id){
        Activity activity = activityService.queryActivityById(id);
        return activity;
    }

    @RequestMapping("/workbench/activity/saveEditActivity.do")
    @ResponseBody
    public Object editActivity(Activity activity, HttpSession session) {
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        activity.setEditTime(DateUtils.formateDateTime(new Date()));
        activity.setEditBy(user.getName());
        ReturnObject returnObject = new ReturnObject();
        // 调用service层方法，删除市场活动
        try {
            int result = activityService.editActivity(activity);
            if (result > 0) {
                returnObject.setCode(Contants.RETURN_OBJECT_SUCCESS);
            } else {
                returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
        }
        return returnObject;
    }

    @RequestMapping("/workbench/activity/exportAllActivities.do")
    public void exportAllActivities(HttpServletResponse response) throws IOException {
        // 调用service层方法，查询所有的市场活动
        List<Activity> activityList = activityService.queryAllActivities();
        // 创建excel文件，并且把activityList写入到excel文件中
        HSSFWorkbook wb = new HSSFWorkbook();
        HSSFSheet sheet = wb.createSheet("市场活动列表");
        HSSFRow row = sheet.createRow(0);
        HSSFCell cell = row.createCell(0);
        cell.setCellValue("ID");
        cell = row.createCell(1);
        cell.setCellValue("所有者");
        cell = row.createCell(2);
        cell.setCellValue("名称");
        cell = row.createCell(3);
        cell.setCellValue("开始日期");
        cell = row.createCell(4);
        cell.setCellValue("结束日期");
        cell = row.createCell(5);
        cell.setCellValue("成本");
        cell = row.createCell(6);
        cell.setCellValue("描述");
        cell = row.createCell(7);
        cell.setCellValue("创建时间");
        cell = row.createCell(8);
        cell.setCellValue("创建者");
        cell = row.createCell(9);
        cell.setCellValue("修改时间");
        cell = row.createCell(10);
        cell.setCellValue("修改者");

        if (activityList != null && activityList.size() > 0){
            Activity activity = null;
            // 遍历activityList，创建HSSFRow对象，生成所有数据行
            for (int i = 0; i < activityList.size(); i++){
                activity = activityList.get(i);
                // 每遍历一个activity，生成一行
                row = sheet.createRow(i+1);
                cell = row.createCell(0);
                cell.setCellValue(activity.getId());
                cell = row.createCell(1);
                cell.setCellValue(activity.getOwner());
                cell = row.createCell(2);
                cell.setCellValue(activity.getName());
                cell = row.createCell(3);
                cell.setCellValue(activity.getStartDate());
                cell = row.createCell(4);
                cell.setCellValue(activity.getEndDate());
                cell = row.createCell(5);
                cell.setCellValue(activity.getCost());
                cell = row.createCell(6);
                cell.setCellValue(activity.getDescription());
                cell = row.createCell(7);
                cell.setCellValue(activity.getCreateTime());
                cell = row.createCell(8);
                cell.setCellValue(activity.getCreateBy());
                cell = row.createCell(9);
                cell.setCellValue(activity.getEditTime());
                cell = row.createCell(10);
                cell.setCellValue(activity.getEditBy());
            }
        }

        // 根据wb对象生成excel文件
        /*OutputStream os = new FileOutputStream("D:\\Java\\workspace-ssm\\crm-project\\crm\\src\\main\\webapp\\upload\\activityList.xls");
        wb.write(os);*/
        // 关闭资源
        /*os.close();
        wb.close();*/

        // 把生成的excel文件下载到客户端
        response.setContentType("application/octet-stream;charset=UTF-8");
        response.addHeader("Content-Disposition", "attachment;filename=activityList.xls");
        OutputStream out = response.getOutputStream();
       /* InputStream is = new FileInputStream("D:\\Java\\workspace-ssm\\crm-project\\crm\\src\\main\\webapp\\upload\\activityList.xls");
        byte[] buff = new byte[256];
        int len = 0;
        while ((len = is.read(buff)) != -1){
            out.write(buff, 0, len);
        }

        is.close();*/
        wb.write(out);

        wb.close();
        out.flush();
    }

    @RequestMapping("/workbench/activity/exportCheckedActivities.do")
    public void exportCheckedActivities(HttpServletResponse response, String[] id) throws IOException {
        // 调用service层方法，查询勾选的市场活动
        List<Activity> activityList = activityService.queryActivitiesByIds(id);
        // 创建excel文件，并且把activityList写入到excel文件中
        HSSFWorkbook wb = new HSSFWorkbook();
        HSSFSheet sheet = wb.createSheet("市场活动列表");
        HSSFRow row = sheet.createRow(0);
        HSSFCell cell = row.createCell(0);
        cell.setCellValue("ID");
        cell = row.createCell(1);
        cell.setCellValue("所有者");
        cell = row.createCell(2);
        cell.setCellValue("名称");
        cell = row.createCell(3);
        cell.setCellValue("开始日期");
        cell = row.createCell(4);
        cell.setCellValue("结束日期");
        cell = row.createCell(5);
        cell.setCellValue("成本");
        cell = row.createCell(6);
        cell.setCellValue("描述");
        cell = row.createCell(7);
        cell.setCellValue("创建时间");
        cell = row.createCell(8);
        cell.setCellValue("创建者");
        cell = row.createCell(9);
        cell.setCellValue("修改时间");
        cell = row.createCell(10);
        cell.setCellValue("修改者");

        if (activityList != null && activityList.size() > 0){
            Activity activity = null;
            // 遍历activityList，创建HSSFRow对象，生成所有数据行
            for (int i = 0; i < activityList.size(); i++){
                activity = activityList.get(i);
                // 每遍历一个activity，生成一行
                row = sheet.createRow(i+1);
                cell = row.createCell(0);
                cell.setCellValue(activity.getId());
                cell = row.createCell(1);
                cell.setCellValue(activity.getOwner());
                cell = row.createCell(2);
                cell.setCellValue(activity.getName());
                cell = row.createCell(3);
                cell.setCellValue(activity.getStartDate());
                cell = row.createCell(4);
                cell.setCellValue(activity.getEndDate());
                cell = row.createCell(5);
                cell.setCellValue(activity.getCost());
                cell = row.createCell(6);
                cell.setCellValue(activity.getDescription());
                cell = row.createCell(7);
                cell.setCellValue(activity.getCreateTime());
                cell = row.createCell(8);
                cell.setCellValue(activity.getCreateBy());
                cell = row.createCell(9);
                cell.setCellValue(activity.getEditTime());
                cell = row.createCell(10);
                cell.setCellValue(activity.getEditBy());
            }
        }

        // 把生成的excel文件下载到客户端
        response.setContentType("application/octet-stream;charset=UTF-8");
        response.addHeader("Content-Disposition", "attachment;filename=activityList.xls");
        OutputStream out = response.getOutputStream();

        wb.write(out);

        wb.close();
        out.flush();
    }

    @RequestMapping("/workbench/activity/importActivity.do")
    @ResponseBody
    public Object importActivity(MultipartFile activityFile, HttpSession session){
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();

        try {
            // 把excel文件写入到磁盘中
            /*String fileName = activityFile.getOriginalFilename();
            File file = new File("D:\\ADownload\\test\\", fileName);
            activityFile.transferTo(file);*/

            // 解析excel文件，获取文件中的数据，并且封装成activityList
            // InputStream is = new FileInputStream("D:\\ADownload\\test\\"+fileName);

            InputStream is = activityFile.getInputStream();
            HSSFWorkbook wb = new HSSFWorkbook(is);
            HSSFSheet sheet = wb.getSheetAt(0); // 页的下标，下标从0开始，依次递增
            // 根据sheet获取HSSFRow对象，封装了一行所有的信息
            HSSFRow row = null;
            HSSFCell cell = null;
            Activity activity = null;
            List<Activity> activityList = new ArrayList<>();
            for (int i = 1; i <= sheet.getLastRowNum(); i++){
                row = sheet.getRow(i);  // 行的下标，下标从0开始，依次增加
                activity = new Activity();
                activity.setId(UUIDUtils.getUUID());
                activity.setOwner(user.getId());
                activity.setCreateTime(DateUtils.formateDateTime(new Date()));
                activity.setCreateBy(user.getName());
                for (int j = 0; j < row.getLastCellNum(); j++){
                    cell = row.getCell(j); // 列的下标，下标从0开始，依次增加
                    // 获取列中的数据
                    String cellValue = HSSFUtils.getCellValueForStr(cell);
                    if (j == 2){
                        activity.setName(cellValue);
                    } else if (j == 3){
                        activity.setStartDate(cellValue);
                    } else if (j == 4){
                        activity.setEndDate(cellValue);
                    } else if (j == 5){
                        activity.setCost(cellValue);
                    } else if (j == 6){
                        activity.setDescription(cellValue);
                    }
                }
                // 每一行中所有列封装完之后，把activity保存到list中
                activityList.add(activity);
            }

            // 调用service层方法，保存市场活动
            int result = activityService.saveCreateActivities(activityList);
            returnObject.setCode(Contants.RETURN_OBJECT_SUCCESS);
            returnObject.setMessage("成功导入"+result+"条数据");
        } catch (Exception e){
            returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
        }
        return returnObject;
    }

    @RequestMapping("/workbench/activity/detailActivity.do")
    public String detailActivity(String id, HttpServletRequest request){
        Activity activity = activityService.queryActivityDetail(id);
        List<ActivityRemark> remarkList = activityRemarkService.queryActivityRemarkByActivityId(id);

        // 把数据保存到request中
        request.setAttribute("activity", activity);
        request.setAttribute("remarkList", remarkList);
        return "workbench/activity/detail";
    }
}