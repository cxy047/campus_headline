package com.chenxy.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.chenxy.entity.Topic;
import java.util.List;

public interface TopicService {
    /** 前台分页：仅已审核 */
    public IPage<Topic> pageTopics(long var1, long var3);

    /** 后台管理分页：全部状态 */
    public IPage<Topic> pageManage(long var1, long var3);

    public Topic findById(Integer var1);

    public void incrementViews(Integer var1);

    public List<Topic> listHot(int var1);

    public List<Topic> listByUser(Integer var1);

    public long countAll();

    public Topic add(Topic var1);

    public void update(Topic var1);

    public boolean deleteById(Integer var1);

    public void auditPass(Integer var1);

    public void auditReject(Integer var1);
}
