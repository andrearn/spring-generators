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
import org.eclipse.xtext.generator.IFileSystemAccess2
import java.beans.PropertyDescriptor

class ParameterSourceGenerator {
	
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
		val content = bean.toParameterBuilder(packageName)
		var rowMapperClassName = packageName + "." + bean.simpleName + "ParameterBuilder"
		val fileName = rowMapperClassName.replaceAll("\\/", ".") + ".java"
		fsa.generateFile(fileName, content)
	}
	
	def toParameterBuilder(Class<?> bean, String packageName) {
		'''
			package «packageName»;
			
			import «bean.canonicalName»;
			
			import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
			import org.springframework.jdbc.core.namedparam.SqlParameterSource;
			
			public class «bean.simpleName»ParameterBuilder {
				
				public static SqlParameterSource toParameterSource(«bean.simpleName» bean) {
					MapSqlParameterSource params = new MapSqlParameterSource();
					«bean.readableProperties.map[].join»
					return params;
				}
			
			}
		
		'''
	}
	
	def toPropertyRegistration(PropertyDescriptor pd, String paramVarName, String beanVarName) '''
		«paramVarName».addValue(«pd.name», «beanVarName».«pd.toGetterCall»);
	'''
}