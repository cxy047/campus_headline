package com.chenxy.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.chenxy.entity.Video;
import java.util.List;

public interface VideoService {
    /** 前台分页：仅已审核 */
    public IPage<Video> pageVideos(long var1, long var3);

    /** 后台管理分页：全部状态 */
    public IPage<Video> pageManage(long var1, long var3);

    public Video findById(Integer var1);

    public void incrementViews(Integer var1);

    public List<Video> listLatest(int var1);

    public List<Video> listByUser(Integer var1);

    public long countAll();

    public Video add(Video var1);

    public void update(Video var1);

    public boolean deleteById(Integer var1);

    public void auditPass(Integer var1);

    public void auditReject(Integer var1);
}
