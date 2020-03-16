package tidemedia.tcenter.service.company;

import org.springframework.stereotype.Service;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.system.Company;
import tidemedia.cms.system.Product;
import tidemedia.tcenter.entity.company.CompanyRequestEntity;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 */
@Service
public class CompanyRequestService {


    public List<CompanyRequestEntity> getComopanyRequest(int companyid) throws MessageException, SQLException {
        List<CompanyRequestEntity>  list = new ArrayList<>();
        String sql = "select * from company_request where status=0 and companyid="+companyid;
        TableUtil tu_user = new TableUtil("user");
        ResultSet rs = tu_user.executeQuery(sql);
        while(rs.next()){
            CompanyRequestEntity companyRequestEntity = new CompanyRequestEntity();
            getCompanyRequestEntity(companyRequestEntity,rs,tu_user);
            list.add(companyRequestEntity);
        }
        tu_user.closeRs(rs);
        return  list;
        //return  companyRequestMapper.getComopanyRequest(companyid);
    }

    public List<Product> getProducts() throws MessageException, SQLException {
        List<Product>  list = new ArrayList<>();
        String sql = "select * from tide_products where  Status=1 and groupid<5";
        TableUtil tu_user = new TableUtil("user");
        ResultSet rs = tu_user.executeQuery(sql);
        while(rs.next()){
            Product p = new Product();
            p.setId(rs.getInt("id"));
            p.setName(tu_user.convertNull(rs.getString("Name")));
            p.setCode(tu_user.convertNull(rs.getString("Code")));
            p.setLicense(tu_user.convertNull(rs.getString("License")));
            p.setUrl(tu_user.convertNull(rs.getString("Url")));
            p.setStatus(rs.getInt("Status"));
            p.setType(rs.getInt("Type"));
            p.setGroupId(rs.getInt("groupId"));
            p.setLogo(tu_user.convertNull(rs.getString("logo")));
            p.setNewpage(rs.getInt("newpage"));
            p.setIsview(rs.getInt("Isview"));
            p.setSummary(tu_user.convertNull(rs.getString("Summary")));
            list.add(p);
        }
        tu_user.closeRs(rs);
        return  list;
        //return  companyRequestMapper.getProducts();
    }
    /**
     * 申请开通写入数据
     * @param companyRequestEntity
     * @return
     */
    public void  addCompanyRequest(CompanyRequestEntity companyRequestEntity) throws MessageException, SQLException {
        TableUtil tu_user = new TableUtil("user");
        String sql = "insert into company_request(companyId,companyName,productId,productName,Status,requestDate)  values ("
                    +companyRequestEntity.getCompanyId()+",'"+companyRequestEntity.getCompanyName()+
                    "',"+companyRequestEntity.getProductId()+",'"+companyRequestEntity.getProductName()+"',"+companyRequestEntity.getStatus()+
                    ",'"+companyRequestEntity.getRequestDate()+"')";
        tu_user.executeUpdate(sql);
        //companyRequestMapper.addCompanyRequest(companyRequestEntity);
    }

    /**
     * 开通请求
     * @param ids
     */
    public void agreeCompanyRequest(String ids) throws SQLException, MessageException {


        String ids_[] = ids.split(",");
        TableUtil tu_user = new TableUtil("user");
        for (int i = 0; i < ids_.length; i++) {//更新租户产品表
            int id = Integer.parseInt(ids_[i]);
            CompanyRequestEntity c = companyRequestDetails(id);
            int productId = c.getProductId();
            int companyId = c.getCompanyId();
            String products = new Company(companyId).getProducts();
            if("".equals(products)){
                products=productId+"";
            }else{
                products+=","+productId;
            }
            tu_user.executeUpdate("update company_product set productIds='"+products+"' where companyId  ="+companyId);
            tu_user.executeUpdate("update company_request set openDate=now(),status=1 where id ="+id);
            /*companyRequestMapper.updateCompanyRequest(companyId,products);
            companyRequestMapper.agreeCompanyRequest(id);//更新租户请求表*/
        }
    }

    /**
     * 根据id获取产品请求信息
     * @param id
     * @return
     */
    public CompanyRequestEntity companyRequestDetails(int id) throws MessageException, SQLException {
        CompanyRequestEntity companyRequestEntity = new CompanyRequestEntity();
        String sql = "select * from company_request where  id="+id;
        TableUtil tu_user = new TableUtil("user");
        ResultSet rs = tu_user.executeQuery(sql);
        if(rs.next()){
            getCompanyRequestEntity(companyRequestEntity,rs,tu_user);
        }
        tu_user.closeRs(rs);
        return companyRequestEntity;
    }

    /**
     * CompanyRequestEntity对象填充数据
     * @param companyRequestEntity
     * @param rs
     * @param tu_user
     * @return
     * @throws SQLException
     */
    public  void getCompanyRequestEntity(CompanyRequestEntity companyRequestEntity,ResultSet rs,TableUtil tu_user) throws SQLException {
        companyRequestEntity.setId(rs.getInt("id"));
        companyRequestEntity.setCompanyId(rs.getInt("companyId"));
        companyRequestEntity.setCompanyName(tu_user.convertNull(rs.getString("companyName")) );
        companyRequestEntity.setProductId(rs.getInt("productId"));
        companyRequestEntity.setProductName(tu_user.convertNull(rs.getString("productName")) );
        companyRequestEntity.setStatus(rs.getInt("status"));
        companyRequestEntity.setRequestDate(tu_user.convertNull(rs.getString("requestDate")) );
        companyRequestEntity.setOpenDate(tu_user.convertNull(rs.getString("openDate")) );
    }

}