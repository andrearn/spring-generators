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
import javax.inject.Named
import javax.annotation.Nullable
import java.lang.reflect.Constructor
import java.lang.reflect.Modifier
import java.math.BigInteger

/**
 * Generator for RowMappers that us the same semantics as BeanPropertyRowMappers, but 
 * do not use reflection or bean introspection.
 */
class RowMapperGenerator {
	
	@Inject 
	private IFileSystemAccess2 fsa
	
	@Inject
	private extension JdbcMappingFunctions
	
	@Inject 
	private extension BeanMappingFunctions
	
	@Inject
	private extension BeanIntrospector
	
	@Inject 
	private extension GeneratorExtensions

	@Inject
	private extension SpringBeanMappingFunctions
	
	@Inject @Named("ignoreComplexProperties")
	private Boolean ignoreComplexProperties
	
	@Inject @Named("rowMapperAnnotationClass")
	@Nullable
	private String rowMapperAnnotationClass

	@Inject @Named("withColumnCheck")
	private Boolean withColumnCheck

	@Inject @Named("withPropertyAssignmentCheck")
	private Boolean withPropertyAssignmentCheck
	
	def generate(Class<?> bean) {
		generate(bean, bean.toPackage)
	}
	def generate(Class<?> bean, String packageName) {
		var Constructor<?> constructor = null
		try {
			constructor = bean.getConstructor()
		} catch (Exception e) {
			
		}
		if (!Modifier.isAbstract(bean.getModifiers()) && constructor !== null && !bean.writableProperties.filter[!isComplexProperty || !ignoreComplexProperties].nullOrEmpty) {
			val content = bean.toRowMapper(packageName)
			var rowMapperClassName = packageName + "." + bean.simpleName + "RowMapper"
			val fileName = rowMapperClassName.classNameToFileName
			fsa.generateFile(fileName, content)
		}
	}
		
	def toRowMapper(Class<?> clazz, String packageName) '''
		package «packageName»;
		
		«clazz.toPropertyTypeImports»
		import java.sql.ResultSet;
		import java.sql.ResultSetMetaData;
		import java.sql.SQLException;
		import java.util.ArrayList;
		import java.util.HashSet;
		import java.util.List;
		import java.util.Set;
		
		import «clazz.canonicalName»;
		«IF rowMapperAnnotationClass !== null»
			import «rowMapperAnnotationClass»;
		«ENDIF»
		
		import org.springframework.jdbc.core.RowMapper;
		
		«IF rowMapperAnnotationClass !== null»
			@«rowMapperAnnotationClass.split("\\.").last»
		«ENDIF»
		public class «clazz.simpleName»RowMapper implements RowMapper<«clazz.simpleName»> {
		
			@Override
			public «clazz.simpleName» mapRow(ResultSet rs, int rowNum) throws SQLException {
				«IF withColumnCheck»
					Set<String> cols = new HashSet<>();
					«IF withPropertyAssignmentCheck»
						Set<String> assignedCols = new HashSet<>();
					«ENDIF»
					ResultSetMetaData md = rs.getMetaData();
					for(int i=1; i <= md.getColumnCount(); i++) {
						cols.add(md.getColumnName(i));
					}
				«ENDIF»
				«clazz.simpleName» bo = new «clazz.simpleName»();
				«clazz.writableProperties.filter[!isComplexProperty || !ignoreComplexProperties].map[toPropertyAssignment].join»

				«IF withColumnCheck && withPropertyAssignmentCheck» 
					if (assignedCols.size() != cols.size()) {
						List<String> unAssignedCols = new ArrayList<>(cols);
						for (String col : assignedCols) {
							unAssignedCols.remove(col);
						}
						throw new IllegalStateException("Some columns have not been assigned to properties: " + unAssignedCols);
					}
				«ENDIF»
				return bo;
			}
		}	
	'''
	
	
	def toPropertyAssignment(PropertyDescriptor pd) {
		val columnName = pd.name.underscoreName.toUpperCase
		if (pd.propertyType.isAssignableFrom(typeof(String))) {
			'''
				if (cols.contains("«columnName»")) {
					String «pd.name» = rs.«pd.toResultSetAccessorCall»;
					if («pd.name» != null) {
						bo.«pd.toSetterCall(pd.name)»;
						«IF withColumnCheck && withPropertyAssignmentCheck» 
							assignedCols.add("«columnName»");
						«ENDIF»
					}
				}
			'''
		} else if (pd.propertyType.isAssignableFrom(typeof(BigInteger))) {
			'''
				if (cols.contains("«pd.name.underscoreName.toUpperCase»")) {
					bo.«pd.toSetterCall("BigInteger.valueOf(rs." + pd.toResultSetAccessorCall+")")»;
					«IF withColumnCheck && withPropertyAssignmentCheck» 
						assignedCols.add("«columnName»");
					«ENDIF»
				}
			'''
		} else {
			'''
				if (cols.contains("«pd.name.underscoreName.toUpperCase»")) {
					bo.«pd.toSetterCall("rs." + pd.toResultSetAccessorCall)»;
					«IF withColumnCheck && withPropertyAssignmentCheck» 
						assignedCols.add("«columnName»");
					«ENDIF»
				}
			'''
		}
	}
}