package tidemedia.tcenter.service.train;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import tidemedia.cms.base.MessageException;
import tidemedia.tcenter.entity.train.TrainingManagerBean;
import tidemedia.tcenter.entity.train.TrainingManagerMini;
import tidemedia.tcenter.mapper.train.TrainingMapper;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

@Service
public class TrainService  {

    @Autowired
    TrainingMapper trainingMapper;



    public TrainingManagerBean getAllTrainManager(int id) throws MessageException, SQLException {
        List<TrainingManagerBean> trainList= trainingMapper.getAllTrainManager(id);
        TrainingManagerBean train=null;
        if(trainList.size()>0){
            train=trainList.get(0);
        }
        return train;
    }


    public List<TrainingManagerMini> getAllTrainManagerMini(int id) throws MessageException, SQLException {
        List<TrainingManagerMini> trainList= trainingMapper.getAllTrainManagerMini(id);
        return trainList;
    }


    public List<HashMap<String, Object>> getAllTrainManagerMiniMap(HashMap<String, Object> map) throws MessageException, SQLException {
        int id=(int)map.get("id");
        String title=(String) map.get("Title");
        int source_type=(int)map.get("source_type");
        Long startDate=(Long)map.get("startDate");
        Long endDate=(Long)map.get("endDate");
        int start=(int)map.get("start");
        int limit=(int)map.get("limit");
        List<HashMap<String, Object>> trainList=trainingMapper.getAllTrainManagerMiniMap(id,title,source_type,startDate,endDate,start,limit);
        return trainList;
    }


    public Integer getAllTrainManagerMiniCount(HashMap<String, Object> map) throws MessageException, SQLException {
        int id=(int)map.get("id");
        String title=(String) map.get("Title");
        int source_type=(int)map.get("source_type");
        Long startDate=(Long)map.get("startDate");
        Long endDate=(Long)map.get("endDate");
        Integer count = trainingMapper.getAllTrainManagerMiniCount(id,title,source_type,startDate,endDate);
        return count;
    }
}
