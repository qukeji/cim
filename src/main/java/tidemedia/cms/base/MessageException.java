/**
 * $李永海	liyonghai@163.net李永海
 * $Revision: 1.0 $
 * $Date: 2002/06/10 22:13:00 $
 */

package tidemedia.cms.base;


public class MessageException extends Exception
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	public int MessageType= 0;
	//0:Display		1:alert history.back	2:alert close window
	
	public static final int 	DISPLAY = 0;
	public static final int 	ALERT_HISTORY_BACK = 1;
	public static final int		ALERT_CLOSE_WINDOW = 2;
	public static final int		ALERT_HISTORY_BACK_MODAL = 3;//模态对话框使用
	public static final int		ALERT_CLOSE_WINDOW_MODAL = 4;//模态对话框使用
	public static final int		INVALID_LICENSE = 5;
	
	public MessageException()
	{
	}

	public MessageException(String s)
	{
		super(s);
	}

	public MessageException(String s,int type)
	{
		super(s);
		MessageType = type;
	}
	
	public int getMessageType() {
		return MessageType;
	}

	public void setMessageType(int i) {
		MessageType = i;
	}
}