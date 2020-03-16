package tidemedia.cms.test;

import java.sql.SQLException;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.system.Channel;
import tidemedia.cms.system.CmsCache;
import tidemedia.cms.system.Document;
import tidemedia.cms.system.Tree;
import tidemedia.cms.user.UserInfo;

public class SimpleTestClass {

	public void setUp() {
	 // SampleUtil.doSomething();
	}
	
	public void tearDown() {
	  //SampleUtil.doSomething();
	}
	
	public void testA() {
	  try {
		 Document doc = new Document(11937);
	} catch (MessageException e) {
		e.printStackTrace();
	} catch (SQLException e) {
		e.printStackTrace();
	}
	}
}
