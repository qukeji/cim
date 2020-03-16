package tidemedia.tcenter.service.company;

import org.springframework.stereotype.Service;
import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.TableUtil;

import javax.annotation.Resource;
import java.sql.SQLException;

@Service
public class CompanySpaceService {


    //编辑租户总空间接口
    public void update(int id, int space) throws MessageException, SQLException {
        TableUtil tu_user = new TableUtil("user");
        tu_user.executeUpdate("update company set space = "+space+" where id = "+id);
    }
}
