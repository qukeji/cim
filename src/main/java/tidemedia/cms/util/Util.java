package tidemedia.cms.util;

import java.sql.SQLException;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.system.CmsCache;

/**
 * @author 李永海
 * 2019/01/22
 *   此类代码可以交付客户，便于二次开发，里面的方法可以在模板中直接使用，通过$util
 */
public class Util extends Util2{

	/**
	 * 根据阅读量，结合算法，生成新的数字。当阅读量=1时，显示35-60间的随机数；
	 * 当阅读量>1时，显示以阅读量为底，3000为对数的对数函数，即log函数；公式：LOG(3000,阅读量)*阅读量*2.75，结果向上取整；
	 * excel公式：=ROUNDUP(LOG(3000,A16)*A16*2.75,0)
	 * @param num
	 * @return
	 * @throws SQLException 
	 * @throws MessageException 
	 */
	public static long getNewReadAmount(long num) throws MessageException, SQLException
	{
		if(CmsCache.getParameter("sys_new_read_amount").getIntValue()==0)
			return num;
		
		if(num == 1) return 1;
		
		long num2 = (long)Math.ceil(Math.log(3000)/Math.log(num)*num*2.75);
		
		return num2;
	}
}