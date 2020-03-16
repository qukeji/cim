package tidemedia.cms.publish;

import java.io.BufferedInputStream;
import java.io.ByteArrayInputStream;   
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;   
import java.io.UnsupportedEncodingException;   
import java.sql.SQLException;
  
import org.apache.commons.collections.ExtendedProperties;     
import org.apache.velocity.exception.ResourceNotFoundException;   
import org.apache.velocity.runtime.resource.Resource;   
import org.apache.velocity.runtime.resource.loader.ResourceLoader;   

import tidemedia.cms.base.MessageException;
import tidemedia.cms.util.Util;
import tidemedia.cms.web.Web;
  
public class TideResourceLoader extends ResourceLoader {   
  
 
  
    /**  
     * 得到资源流的最后修改时间  
     *   
     * @param resource  
     * @return Time in millis when the resource has been modified.  
     */  
    public long getLastModified(Resource arg0) {   
        return 0;   
    }   
  
    /**  
     * 得到一个资源输入流。  
     *   
     * @param source  
     * @return The input stream for the requested resource.  
     * @throws ResourceNotFoundException  
     */  
    public InputStream getResourceStream(String str){   
        if (str == null || str.length() == 0) {   
            throw new ResourceNotFoundException(   
                    "Need to specify a template name!");   
        }   
  
        try {   
        	if(str.endsWith(".html"))
        	{
        		FileInputStream fis = new FileInputStream(str);
        		return new BufferedInputStream(fis);
        	}
        	
        	if(str.startsWith("/extra/"))
        	{ 
        		System.out.println("str:"+str);
        		str = str.replace("/extra/","");
        		int[] i = Util.StringToIntArray(str,"/");
        		System.out.println("i:"+i.length);
					try {
						if(i.length==3)	
						{
							Web web = new Web(i[0]);
							str = web.getExtra(i[1],i[2]);
						}
					} catch (MessageException e) {
						e.printStackTrace();
					} catch (SQLException e) {
						e.printStackTrace();
					}
        	}
            return new ByteArrayInputStream(str.getBytes("UTF-8"));
        } catch (UnsupportedEncodingException e) {// 这个异常应该不会发生。   
            System.out.println("读取模板出现问题："+e.getMessage());  
        } catch (FileNotFoundException e) {
        	System.out.println("读取模板出现问题："+e.getMessage()); 
		}
        return null;
    }   
  
    /**  
     * 初始化资源加载器 a resources class.  
     *   
     * @param configuration  
     */  
    @Override  
    public void init(ExtendedProperties arg0) {   
        if (log.isTraceEnabled()) {   
            log.trace("TestResourceLoader : initialization complete.");   
        }   
    }   
  
    /**  
     * 检查资源是否被修改。  
     *   
     * @param resource  
     * @return True if the resource has been modified.  
     */  
    @Override  
    public boolean isSourceModified(Resource arg0) {   
        return false;   
    }   
  
}  
