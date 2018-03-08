package org.xkonnex.spring.generators.jdbc;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.Date;
import java.util.List;

public class SampleBean {
	
	private int id;
	private String name;
	private BigDecimal amount;
	private Date birthDate;
	private Long uid;
	private boolean modified;
	private List<String> types;
	private Timestamp aTimestamp;
	private String with_underscore;
	private String text1;
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public BigDecimal getAmount() {
		return amount;
	}
	public void setAmount(BigDecimal amount) {
		this.amount = amount;
	}
	public Date getBirthDate() {
		return birthDate;
	}
	public void setBirthDate(Date birthDate) {
		this.birthDate = birthDate;
	}
	public Long getUid() {
		return uid;
	}
	public void setUid(Long uid) {
		this.uid = uid;
	}
	public boolean isModified() {
		return modified;
	}
	public void setModified(boolean modified) {
		this.modified = modified;
	}
	public List<String> getTypes() {
		return types;
	}
	public void setTypes(List<String> types) {
		this.types = types;
	}
	public Timestamp getaTimestamp() {
		return aTimestamp;
	}
	public void setaTimestamp(Timestamp aTimestamp) {
		this.aTimestamp = aTimestamp;
	}
	public String getWith_underscore() {
		return with_underscore;
	}
	public void setWith_underscore(String with_underscore) {
		this.with_underscore = with_underscore;
	}
	public String getText1() {
		return text1;
	}
	public void setText1(String text1) {
		this.text1 = text1;
	}

}
