/*
 * Copyright 2018 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.xkonnex.spring.generators.jdbc;

import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.util.StringUtils;

public class SpringBeanMappingFunctions {

	@Inject
	@Named("useOldFieldnameMapping")
	private boolean useOldFieldnameMapping;

	@Inject
	@Named("customPropertyToColumnRules")
	private Map<String, String> customPropertyToColumnRules;

	public String underscoreName(final String name) {
		String customName = customPropertyToColumnRules.get(name);
		if (customName != null) {
			return customName;
		} else if (useOldFieldnameMapping) {
			return underscoreNameOld(name);
		} else {
			return underscoreNameNew(name);
		}
	}

	/**
	 * Copied from Springs BeanPropertyRowMapper Convert a name in camelCase to an underscored name in lower case. Any upper case letters are
	 * converted to lower case with a preceding underscore. Used until Spring 3.2.6
	 * 
	 * @param name
	 *            the string containing original name
	 * @return the converted name
	 */
	public String underscoreNameOld(final String name) {
		StringBuilder result = new StringBuilder();
		if (name != null && name.length() > 0) {
			result.append(name.substring(0, 1).toLowerCase());
			for (int i = 1; i < name.length(); i++) {
				String s = name.substring(i, i + 1);
				if (s.equals(s.toUpperCase())) {
					result.append("_");
					result.append(s.toLowerCase());
				} else {
					result.append(s);
				}
			}
		}
		return result.toString();
	}

	/**
	 * Copied from Springs BeanPropertyRowMapper Convert a name in camelCase to an underscored name in lower case. Any upper case letters are
	 * converted to lower case with a preceding underscore. Used in Spring 3.2.7 and later
	 * 
	 * @param name
	 *            the string containing original name
	 * @return the converted name
	 */
	public String underscoreNameNew(final String name) {
		if (!StringUtils.hasLength(name)) {
			return "";
		}
		StringBuilder result = new StringBuilder();
		result.append(name.substring(0, 1).toLowerCase());
		for (int i = 1; i < name.length(); i++) {
			String s = name.substring(i, i + 1);
			String slc = s.toLowerCase();
			if (!s.equals(slc)) {
				result.append("_").append(slc);
			} else {
				result.append(s);
			}
		}
		return result.toString();
	}

	public boolean isUseOldFieldnameMapping() {
		return useOldFieldnameMapping;
	}

	public void setUseOldFieldnameMapping(final boolean useOldFieldnameMapping) {
		this.useOldFieldnameMapping = useOldFieldnameMapping;
	}
}
