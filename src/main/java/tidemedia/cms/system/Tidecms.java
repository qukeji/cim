package tidemedia.cms.system;

import java.sql.SQLException;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.publish.Publish;

public class Tidecms {

	public Tidecms()
	{
		
	}
	//指定发布模板  附加模板
	public void publishChannelTemplate(int channelTemplateID)
	{
		Publish p;
		
			try {
				p = new Publish();
				p.init();
				p.publishChannelTemplate(channelTemplateID);
			} catch (MessageException e) {
				e.printStackTrace();
			} catch (SQLException e) {
				e.printStackTrace();
			}
			
		
	}
}
