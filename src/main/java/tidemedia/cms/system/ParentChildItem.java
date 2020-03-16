package tidemedia.cms.system;

import java.sql.SQLException;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.Table;

public class ParentChildItem extends Table{

	private int 	id;
	private int 	parent = 0;
	private int		child = 0;
	private String	Field = "";
	
	public ParentChildItem() throws MessageException, SQLException {
		super();
	}

	public void Add() throws SQLException, MessageException {
	}

	public void Delete(int id) throws SQLException, MessageException {
	}

	public void Update() throws SQLException, MessageException {
	}

	public boolean canAdd() {
		return false;
	}

	public boolean canDelete() {
		return false;
	}

	public boolean canUpdate() {
		return false;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getId() {
		return id;
	}

	public void setParent(int parent) {
		this.parent = parent;
	}

	public int getParent() {
		return parent;
	}

	public void setChild(int child) {
		this.child = child;
	}

	public int getChild() {
		return child;
	}

	public void setField(String field) {
		Field = field;
	}

	public String getField() {
		return Field;
	}

}
