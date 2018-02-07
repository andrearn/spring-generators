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

import org.eclipse.xtext.generator.IFileSystemAccess2
import javax.inject.Inject
import java.beans.PropertyDescriptor

class RowMapperGenerator {
	
	@Inject 
	private IFileSystemAccess2 fsa
	
	@Inject
	private extension JdbcMappingFunctions
	
	@Inject 
	private extension BeanMappingFunctions
	
	@Inject
	private extension BeanIntrospector
	
	def generate(Class<?> bean) {
		generate(bean, bean.package.name)
	}
	def generate(Class<?> bean, String packageName) {
		val content = bean.toRowMapper(packageName)
		var rowMapperClassName = packageName + "." + bean.simpleName + "RowMapper"
		val fileName = rowMapperClassName.replaceAll("\\/", ".") + ".java"
		fsa.generateFile(fileName, content)
	}
		
	def toRowMapper(Class<?> clazz, String packageName) '''
		package «packageName»;
		
		«clazz.toPropertyTypeImports»
		import java.sql.ResultSet;
		import java.sql.SQLException;
		
		import «clazz.canonicalName»;
		
		import org.springframework.jdbc.core.RowMapper;
		
		public class «clazz.simpleName»RowMapper implements RowMapper<«clazz.simpleName»> {
		
			@Override
			public «clazz.simpleName» mapRow(ResultSet rs, int rowNum) throws SQLException {
				«clazz.simpleName» bo = new «clazz.simpleName»;
				«clazz.readableProperties.map[toPropertyAssignment].join»
				return bo;
			}
		}	
	'''
	
	
	def toPropertyAssignment(PropertyDescriptor pd) {
		if (pd.propertyType.isAssignableFrom(typeof(String))) {
			'''
				String «pd.name» = rs.«pd.toResultSetAccessorCall»;
				if («pd.name» != null) {
					bo.«pd.toSetterCall(pd.name)»;
				}
			'''
		} else {
			'''
				bo.«pd.toSetterCall("rs." + pd.toResultSetAccessorCall)»;
			'''
		}
	}
}