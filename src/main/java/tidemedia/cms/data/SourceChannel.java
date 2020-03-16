/*
 * Created on 2005-8-15
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package tidemedia.cms.data;

import java.util.ArrayList;

/**
 * @author Administrator
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class SourceChannel {

	/**
	 * 
	 */

	private int id;
	private String Name = "";
	private ArrayList ParentChannelNames = new ArrayList();		
	
	public SourceChannel() {

	}
	
	/**
	 * @return Returns the id.
	 */
	public int getId() {
		return id;
	}
	/**
	 * @param id The id to set.
	 */
	public void setId(int id) {
		this.id = id;
	}
	/**
	 * @return Returns the name.
	 */
	public String getName() {
		return Name;
	}
	/**
	 * @param name The name to set.
	 */
	public void setName(String name) {
		Name = name;
	}

	public void addParentChannelName(String name)
	{
		ParentChannelNames.add(name);
	}
	/**
	 * @return Returns the parentChannelNames.
	 */
	public ArrayList getParentChannelNames() {
		return ParentChannelNames;
	}
	/**
	 * @param parentChannelNames The parentChannelNames to set.
	 */
	public void setParentChannelNames(ArrayList parentChannelNames) {
		ParentChannelNames = parentChannelNames;
	}
}
