package com.example.crm.workbench.service.impl;

import com.example.crm.commons.contants.Contants;
import com.example.crm.commons.utils.DateUtils;
import com.example.crm.commons.utils.UUIDUtils;
import com.example.crm.settings.entity.User;
import com.example.crm.workbench.entity.*;
import com.example.crm.workbench.mapper.CustomerMapper;
import com.example.crm.workbench.mapper.TranHistoryMapper;
import com.example.crm.workbench.mapper.TranMapper;
import com.example.crm.workbench.mapper.TranRemarkMapper;
import com.example.crm.workbench.service.TranService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
public class TranServiceImpl implements TranService {

    @Autowired
    private TranMapper tranMapper;
    @Autowired
    private TranRemarkMapper tranRemarkMapper;
    @Autowired
    private TranHistoryMapper tranHistoryMapper;
    @Autowired
    private CustomerMapper customerMapper;

    @Override
    public List<Tran> queryTranByCustomerId(String customerId) {
        return tranMapper.selectTranByCustomerId(customerId);
    }

    @Override
    public List<Tran> queryTranByCondition(Tran tran) {
        return tranMapper.selectTranByCondition(tran);
    }

    @Override
    public void saveCreateTran(Map<String, Object> map) {
        String customerName = (String) map.get("customerName");
        User user = (User) map.get(Contants.SESSION_USER);
        Date date = new Date();
        Customer customer = customerMapper.selectCustomerByName(customerName);
        if (null == customer){ // 如果用户不存在，新建客户
            customer = new Customer();
            customer.setId(UUIDUtils.getUUID());
            customer.setOwner(user.getId());
            customer.setCreateTime(DateUtils.formateDateTime(date));
            customer.setCreateBy(user.getName());
            customer.setName(customerName);
            customerMapper.insertSelective(customer);
        }

        // 新建交易
        Tran tran = new Tran();
        tran.setId(UUIDUtils.getUUID());
        tran.setStage((String) map.get("stage"));
        tran.setMoney((String) map.get("money"));
        tran.setOwner((String) map.get("owner"));
        tran.setCustomerId(customer.getId());
        tran.setName((String) map.get("name"));
        tran.setActivityId((String) map.get("activityId"));
        tran.setCreateTime(DateUtils.formateDateTime(date));
        tran.setCreateBy(user.getName());
        tran.setExpectedDate((String) map.get("expectedDate"));
        tran.setDescription((String) map.get("description"));
        tran.setContactSummary((String) map.get("contactSummary"));
        tran.setSource((String) map.get("source"));
        tran.setType((String) map.get("type"));
        tran.setContactsId((String) map.get("contactsId"));
        tran.setNextContactTime((String) map.get("nextContactTime"));
        tranMapper.insertSelective(tran);

        // 新建交易历史
        TranHistory tranHistory = new TranHistory();
        tranHistory.setId(UUIDUtils.getUUID());
        tranHistory.setCreateBy(user.getName());
        tranHistory.setCreateTime(DateUtils.formateDateTime(date));
        tranHistory.setTranId(tran.getId());
        tranHistory.setMoney(tran.getMoney());
        tranHistory.setStage(tran.getStage());
        tranHistory.setExpectedDate(tran.getExpectedDate());
        tranHistoryMapper.insertSelective(tranHistory);
    }

    @Override
    public Tran queryTranById(String id) {
        return tranMapper.selectTranById(id);
    }

    @Override
    public List<FunnelVO> queryCountOfTranGroupByStage() {
        return tranMapper.selectCountOfTranGroupByStage();
    }

    @Override
    public void saveEditTran(Tran tran, User user) {
        // 更新交易信息
        tranMapper.updateByPrimaryKeySelective(tran);

        // 新建交易历史
        TranHistory tranHistory = new TranHistory();
        tranHistory.setId(UUIDUtils.getUUID());
        tranHistory.setCreateBy(user.getName());
        tranHistory.setCreateTime(DateUtils.formateDateTime(new Date()));
        tranHistory.setTranId(tran.getId());
        tranHistory.setMoney(tran.getMoney());
        tranHistory.setStage(tran.getStage());
        tranHistory.setExpectedDate(tran.getExpectedDate());
        // 向交易历史阶段里添加
        tranHistoryMapper.insertSelective(tranHistory);
    }

    @Override
    public Tran queryTran(String id) {
        return tranMapper.selectByPrimaryKey(id);
    }

    @Override
    public void deleteTranByIds(String[] ids) {
        // 删除交易
        tranMapper.deleteTranByIds(ids);
        // 删除交易备注
        tranRemarkMapper.deleteTranRemarkByTranId(ids);
        // 删除交易历史
        tranHistoryMapper.deleteTranHistoryByTranId(ids);
    }

    @Override
    public void deleteTranById(String id) {
        // 删除交易
        tranMapper.deleteByPrimaryKey(id);
        // 删除交易备注
        tranRemarkMapper.deleteByPrimaryKey(id);
        // 删除交易历史
        tranHistoryMapper.deleteByPrimaryKey(id);
    }

    @Override
    public List<Tran> queryTranByContactsId(String contactsId) {
        return tranMapper.selectTranByContactsId(contactsId);
    }
}
