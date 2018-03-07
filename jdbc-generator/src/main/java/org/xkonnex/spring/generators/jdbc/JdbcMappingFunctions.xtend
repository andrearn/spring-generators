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
package org.xkonnex.spring.generators.jdbc

import javax.inject.Inject
import java.beans.PropertyDescriptor
import java.math.BigDecimal
import java.sql.Blob
import java.sql.Clob
import java.sql.Date
import java.sql.Time
import java.sql.Timestamp

class JdbcMappingFunctions {
	
	@Inject
	private extension SpringBeanMappingFunctions
	
	def toResultSetAccessorCall(PropertyDescriptor pd) {
		'''«pd.propertyType.columnTypeAccessorName»("«pd.name.underscoreName.toUpperCase»")'''
	}

	def columnTypeAccessorName(Class<?> requiredType) {
		// Explicitly extract typed value, as far as possible.
		if (typeof(String).isAssignableFrom(requiredType)) {
			'''getString'''
		} else if (typeof(boolean).equals(requiredType) || typeof(Boolean).equals(requiredType)) {
			'''getBoolean'''
		} else if (typeof(byte).equals(requiredType) || typeof(Byte).equals(requiredType)) {
			'''getByte''';
		} else if (typeof(short).equals(requiredType) || typeof(Short).equals(requiredType)) {
			'''getShort'''
		} else if (typeof(int).equals(requiredType) || typeof(Integer).equals(requiredType)) {
			'''getInt'''
		} else if (typeof(long).equals(requiredType) || typeof(Long).equals(requiredType)) {
			'''getLong'''
		} else if (typeof(float).equals(requiredType) || typeof(Float).equals(requiredType)) {
			'''getFloat'''
		} else if (typeof(double).equals(requiredType) || typeof(Double).equals(requiredType) ||
			typeof(Number).equals(requiredType)) {
			'''getDouble'''
		} else if (typeof(byte[]).equals(requiredType)) {
			'''getBytes''';
		} else if (typeof(Date).equals(requiredType)) {
			'''getDate'''
		} else if (typeof(Time).equals(requiredType)) {
			'''getTime'''
		} else if (typeof(Timestamp).equals(requiredType) ||
			typeof(java.util.Date).equals(requiredType)) {
			'''getTimestamp'''
		} else if (typeof(BigDecimal).equals(requiredType)) {
			'''getBigDecimal'''
		} else if (typeof(Blob).equals(requiredType)) {
			'''getBlob'''
		} else if (typeof(Clob).equals(requiredType)) {
			'''getClob'''
		} else {
			// Some unknown type desired -> rely on getObject.
			'''getObject''';
		}
	
	// Perform was-null check if demanded (for results that the
	// JDBC driver returns as primitives).
	}
	
	def boolean isComplexProperty(PropertyDescriptor pd) {
		pd.propertyType.columnTypeAccessorName.toString == "getObject"
	}
}
