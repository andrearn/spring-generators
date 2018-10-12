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

import java.beans.PropertyDescriptor
import javax.inject.Inject
import javax.inject.Named
import org.eclipse.xtext.generator.IFileSystemAccess2
import javax.annotation.Nullable

/**
 * Generator for a builder of MapSqlParaterSources
 */
class ParameterSourceGenerator {
	
	@Inject 
	IFileSystemAccess2 fsa
	
	@Inject 
	extension BeanMappingFunctions
	
	@Inject
	extension BeanIntrospector

	@Inject 
	extension GeneratorExtensions
	
	@Inject
	@Named("ignorePropertiesWithThrowsClauses")
	boolean ignorePropertiesWithThrowsClauses

	@Inject @Named("parameterSourceAnnotationClass")
	@Nullable
	String parameterSourceAnnotationClass
	
	/**
	 * Generate a builder that that build a MapSqlParameterSource based on the 
	 * properties of the given bean class. The builder will be generated in the same
	 * package as the bean class.
	 */
	def generate(Class<?> bean) {
		generate(bean, bean.toPackage)
	}
	
	/**
	 * Generate a builder that that build a MapSqlParameterSource based on the 
	 * properties of the given bean class. The builder will be generated in the given 
	 * package
	 */
	def generate(Class<?> bean, String packageName) {
		if (!bean.readableProperties.nullOrEmpty) {
			val content = bean.toParameterBuilder(packageName)
			var rowMapperClassName = packageName + "." + bean.simpleName + "ParameterBuilder"
			val fileName = rowMapperClassName.classNameToFileName
			fsa.generateFile(fileName, content)
		}
	}
	
	def toParameterBuilder(Class<?> bean, String packageName) {
		'''
			package «packageName»;
			
			import «bean.canonicalName»;
			«IF parameterSourceAnnotationClass !== null»
				import «parameterSourceAnnotationClass»;
			«ENDIF»
			
			import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
			
			«IF parameterSourceAnnotationClass !== null»
				@«parameterSourceAnnotationClass.split("\\.").last»
			«ENDIF»
			public class «bean.simpleName»ParameterBuilder {
				
				public static MapSqlParameterSource toParameterSource(final «bean.simpleName» bean) {
					MapSqlParameterSource params = new MapSqlParameterSource();
					«bean.readableProperties.filterNull.map[toPropertyRegistration("params", "bean")].join»
					return params;
				}
			
			}
			
		'''
	}
	
	def toPropertyRegistration(PropertyDescriptor pd, String paramVarName, String beanVarName) {
		if (!ignorePropertiesWithThrowsClauses && !pd.readMethod.exceptionTypes.nullOrEmpty) {
			'''
				try {
					«paramVarName».addValue("«pd.name»", «beanVarName».«pd.toGetterCall»);
				} catch (Exception e) {
					// Ignore
				}
			'''
		} else {
			'''
				«paramVarName».addValue("«pd.name»", «beanVarName».«pd.toGetterCall»);
			'''
		}
	}
}