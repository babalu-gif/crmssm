package com.example.crm.workbench.service.impl;

import com.example.crm.commons.contants.Contants;
import com.example.crm.commons.utils.DateUtils;
import com.example.crm.commons.utils.UUIDUtils;
import com.example.crm.settings.entity.User;
import com.example.crm.workbench.entity.*;
import com.example.crm.workbench.mapper.*;
import com.example.crm.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

@Service
public class ClueServiceImpl implements ClueService {

    @Autowired
    private ClueMapper clueMapper;
    @Autowired
    private CustomerMapper customerMapper;
    @Autowired
    private ContactsMapper contactsMapper;
    @Autowired
    private ClueRemarkMapper clueRemarkMapper;
    @Autowired
    private CustomerRemarkMapper customerRemarkMapper;
    @Autowired
    private ContactsRemarkMapper contactsRemarkMapper;
    @Autowired
    private ClueActivityRelationMapper clueActivityRelationMapper;
    @Autowired
    private ContactsActivityRelationMapper contactsActivityRelationMapper;
    @Autowired
    private TranMapper tranMapper;
    @Autowired
    private TranRemarkMapper tranRemarkMapper;

    @Override
    public List<Clue> queryPaginationClues(Clue clue) {
        return clueMapper.selectPaginationClues(clue);
    }

    @Override
    public int saveCreateClue(Clue clue) {
        return clueMapper.insertSelective(clue);
    }

    @Override
    public void deleteClueByIds(String[] ids) {
        // 删除线索
        clueMapper.deleteClueByIds(ids);
        // 删除线索的备注信息
        clueRemarkMapper.deleteClueRemarkByClueIds(ids);
    }

    @Override
    public Clue queryClueById(String id) {
        return clueMapper.selectByPrimaryKey(id);
    }

    @Override
    public int editClueById(Clue clue) {
        return clueMapper.updateByPrimaryKeySelective(clue);
    }

    @Override
    public Clue queryClueOwnerById(String id) {
        return clueMapper.selectClueOwnerById(id);
    }

    @Override
    public void saveConvertClue(Map<String, Object> map) {
        String clueId = (String) map.get("clueId");
        User user = (User) map.get(Contants.SESSION_USER);
        // 根据id查询线索的信息
        Clue clue = clueMapper.selectByPrimaryKey(clueId);

        // 把该线索中有关公司的信息转换到客户表中
        Customer customer = new Customer();
        customer.setId(UUIDUtils.getUUID());
        customer.setContactSummary(clue.getContactSummary());
        customer.setAddress(clue.getAddress());
        customer.setCreateBy(user.getName());
        customer.setCreateTime(DateUtils.formateDateTime(new Date()));
        customer.setDescription(clue.getDescription());
        customer.setName(clue.getCompany());
        customer.setNextContactTime(clue.getNextContactTime());
        customer.setOwner(user.getId());
        customer.setPhone(clue.getPhone());
        customer.setWebsite(clue.getWebsite());
        customerMapper.insertSelective(customer);

        // 把该线索中有关公司的信息转换到联系人表中
        Contacts  contacts = new Contacts();
        contacts.setId(UUIDUtils.getUUID());
        contacts.setContactSummary(clue.getContactSummary());
        contacts.setAddress(clue.getAddress());
        contacts.setCreateBy(user.getName());
        contacts.setCreateTime(DateUtils.formateDateTime(new Date()));
        contacts.setAppellation(clue.getAppellation());
        contacts.setCustomerId(customer.getId());
        contacts.setEmail(clue.getEmail());
        contacts.setFullname(clue.getFullname());
        contacts.setJob(clue.getJob());
        contacts.setMphone(clue.getMphone());
        contacts.setOwner(user.getId());
        contacts.setSource(clue.getSource());
        contacts.setNextContactTime(clue.getNextContactTime());
        contacts.setDescription(clue.getDescription());
        contactsMapper.insertSelective(contacts);

        // 根据clueId查询线索的备注信息
        List<ClueRemark> clueRemarks = clueRemarkMapper.selectClueRemarkByClueId(clueId);
        CustomerRemark customerRemark = null;
        ContactsRemark contactsRemark = null;
        // 判断list集合是否为空
        if (clueRemarks != null && clueRemarks.size() > 0){
            for (ClueRemark clueRemark : clueRemarks){
                customerRemark = new CustomerRemark();
                customerRemark.setCustomerId(customer.getId());
                customerRemark.setCreateBy(user.getCreateBy());
                customerRemark.setCreateTime(DateUtils.formateDateTime(new Date()));
                customerRemark.setId(UUIDUtils.getUUID());
                customerRemark.setEditFlag("0");
                customerRemark.setNoteContent(clueRemark.getNoteContent());
                customerRemarkMapper.insertSelective(customerRemark);
                contactsRemark = new ContactsRemark();
                contactsRemark.setId(UUIDUtils.getUUID());
                contactsRemark.setCreateBy(user.getName());
                contactsRemark.setCreateTime(DateUtils.formateDateTime(new Date()));
                contactsRemark.setEditFlag("0");
                contactsRemark.setNoteContent(clueRemark.getNoteContent());
                contactsRemark.setContactsId(contacts.getId());
                contactsRemarkMapper.insertSelective(contactsRemark);
            }
        }

        // 把该线索和市场活动的关联关系转换联系人和市场活动的关联关系表中
        // 根据clueId查询线索和市场活动的关联关系的activityId
        List<ClueActivityRelation> clueActivityRelations = clueActivityRelationMapper.selectActivityIdByClueId(clueId);
        List<ContactsActivityRelation> contactsActivityRelations = new ArrayList<>();
        ContactsActivityRelation contactsActivityRelation = null;
        if (clueActivityRelations != null && clueActivityRelations.size() > 0){
            for (ClueActivityRelation relation : clueActivityRelations){
                contactsActivityRelation = new ContactsActivityRelation();
                contactsActivityRelation.setId(UUIDUtils.getUUID());
                contactsActivityRelation.setContactsId(contacts.getId());
                contactsActivityRelation.setActivityId(relation.getActivityId());
                contactsActivityRelations.add(contactsActivityRelation);
            }
        }
        contactsActivityRelationMapper.insertContactsActivityRelationByList(contactsActivityRelations);

        // 判断是否需要创建交易，如果需要，往交易表里添加数据,还需要把该线索下的备注转换到交易备注表中一份
        String is = (String) map.get("isCreateTran");
        if ("true".equals(is)){
            Tran tran = new Tran();
            tran.setId(UUIDUtils.getUUID());
            tran.setActivityId((String) map.get("activityId"));
            tran.setCreateBy(user.getName());
            tran.setCreateTime(DateUtils.formateDateTime(new Date()));
            tran.setContactsId(contacts.getId());
            tran.setExpectedDate((String) map.get("expectedDate"));
            tran.setMoney((String) map.get("money"));
            tran.setCustomerId(customer.getId());
            tran.setStage((String) map.get("stage"));
            tran.setName((String) map.get("name"));
            tran.setOwner(user.getId());
            tranMapper.insertSelective(tran);

            // 把该线索下的备注转换到交易备注表中一份
            if (clueRemarks != null && clueRemarks.size() > 0){
                TranRemark tranRemark = null;
                List<TranRemark> tranRemarkList = new ArrayList<>();
                for (ClueRemark clueRemark : clueRemarks){
                    tranRemark = new TranRemark();
                    tranRemark.setId(UUIDUtils.getUUID());
                    tranRemark.setCreateBy(user.getName());
                    tranRemark.setCreateTime(DateUtils.formateDateTime(new Date()));
                    tranRemark.setEditFlag("0");
                    tranRemark.setNoteContent(clueRemark.getNoteContent());
                    tranRemark.setTranId(tran.getId());
                    tranRemarkList.add(tranRemark);
                }
                tranRemarkMapper.insertTranRemarkByList(tranRemarkList);
            }
        }

        // 删除该线索下所有的备注
        clueRemarkMapper.deleteClueRemarkByClueId(clueId);
        // 删除该线索和市场活动的关联关系
        clueActivityRelationMapper.deleteClueActivityRelationByClueId(clueId);
        // 删除该线索
        clueMapper.deleteByPrimaryKey(clueId);
    }
}
