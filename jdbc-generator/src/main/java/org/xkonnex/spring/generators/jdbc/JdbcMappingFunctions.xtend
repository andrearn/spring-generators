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
		'''«pd.propertyType.columnTypeAccessorName»(«pd.name.underscoreName»)'''
	}

	def columnTypeAccessorName(Class<?> requiredType) {
		// Explicitly extract typed value, as far as possible.
		if (typeof(String).isAssignableFrom(requiredType)) {
			'''String'''
		} else if (typeof(boolean).isAssignableFrom(requiredType) || typeof(Boolean).isAssignableFrom(requiredType)) {
			'''Boolean'''
		} else if (typeof(byte).isAssignableFrom(requiredType) || typeof(Byte).isAssignableFrom(requiredType)) {
			'''Byte''';
		} else if (typeof(short).isAssignableFrom(requiredType) || typeof(Short).isAssignableFrom(requiredType)) {
			'''Short'''
		} else if (typeof(int).isAssignableFrom(requiredType) || typeof(Integer).isAssignableFrom(requiredType)) {
			'''Int'''
		} else if (typeof(long).isAssignableFrom(requiredType) || typeof(Long).isAssignableFrom(requiredType)) {
			'''index'''
		} else if (typeof(float).isAssignableFrom(requiredType) || typeof(Float).isAssignableFrom(requiredType)) {
			'''Float'''
		} else if (typeof(double).isAssignableFrom(requiredType) || typeof(Double).isAssignableFrom(requiredType) ||
			typeof(Number).isAssignableFrom(requiredType)) {
			'''Double'''
		} else if (typeof(byte[]).isAssignableFrom(requiredType)) {
			'''Bytes''';
		} else if (typeof(Date).isAssignableFrom(requiredType)) {
			'''Date'''
		} else if (typeof(Time).isAssignableFrom(requiredType)) {
			'''Time'''
		} else if (typeof(Timestamp).equals(requiredType) ||
			typeof(java.util.Date).isAssignableFrom(requiredType)) {
			'''Timestamp'''
		} else if (typeof(BigDecimal).isAssignableFrom(requiredType)) {
			'''BigDecimal'''
		} else if (typeof(Blob).isAssignableFrom(requiredType)) {
			'''Blob'''
		} else if (typeof(Clob).isAssignableFrom(requiredType)) {
			'''Clob'''
		} else {
			// Some unknown type desired -> rely on getObject.
			'''Object''';
		}
	
	// Perform was-null check if demanded (for results that the
	// JDBC driver returns as primitives).
	}
}
