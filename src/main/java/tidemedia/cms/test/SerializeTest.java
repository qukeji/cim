package tidemedia.cms.test;

import java.sql.SQLException;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.system.Document;
import tidemedia.cms.util.SerializeUtil;
import tidemedia.cms.util.Util;

public class SerializeTest {
	public static void main(String[] args)
	{
		/*
		try {
			Document doc = new Document();
			SerializeUtil.serialize(doc);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace(System.out);
		} catch (MessageException e) {
			// TODO Auto-generated catch block
			e.printStackTrace(System.out);
		}*/
		
		String s = "/zaihai/zhongGuoJianZai/51//";
		System.out.println(Util.ClearPath(s));
	}
}
