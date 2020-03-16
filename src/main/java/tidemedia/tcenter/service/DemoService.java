package tidemedia.tcenter.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import tidemedia.tcenter.entity.DemoEntity;
import tidemedia.tcenter.mapper.DemoMapper;

import javax.annotation.Resource;

@Service
public class DemoService {

    @Resource
    private DemoMapper demoMapper;

    public List<DemoEntity> getAll() {
        return demoMapper.getAll();
    }

    public void delete(int id) {
        demoMapper.delete(id);
    }
}