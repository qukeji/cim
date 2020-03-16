package tidemedia.cms.system;

public class ChannelTemplateBean {

	private String		Href = "";//链接

	public void setBean(ChannelTemplate ct)
	{
		setHref(ct.getHref());
	}
	
	public void setHref(String href) {
		Href = href;
	}

	public String getHref() {
		return Href;
	}
	
}
