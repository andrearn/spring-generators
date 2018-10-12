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
import javax.annotation.Nullable

class BeanMappingFunctions {
	
	@Inject
	extension BeanIntrospector
	
	@Inject @Named("beanBasePackage") 
	@Nullable
	String beanBasePackage
	
	@Inject @Named("mapperBasePackage")
	@Nullable
	String mapperBasePackage
	
	def toSetterCall(PropertyDescriptor pd, String expression) {
		if (pd.writeMethod !== null) {
			'''«pd.writeMethod.name»(«expression»)'''
		} else {
			'''set«pd.name.toFirstUpper»(«expression»)'''
		}
	}
	
	def toGetterCall(PropertyDescriptor pd) {
		if (pd.readMethod !== null) {
			'''«pd.readMethod.name»()'''
		} else if (pd.propertyType.isAssignableFrom(typeof(Boolean)) || pd.propertyType.isAssignableFrom(typeof(boolean))) {
			'''is«pd.name.toFirstUpper»()'''
		} else {
			'''get«pd.name.toFirstUpper»()'''
		}
	}
	
	def toPropertyTypeImports(Class<?> clazz, String ... ignoredTypes) {
		'''
			«FOR type : clazz.importedTypes»
				«IF !ignoredTypes.contains(type)»import «type»;«ENDIF»
			«ENDFOR»
		'''
	}
	
	def toPackage(Class<?> clazz) {
		if (beanBasePackage !== null && mapperBasePackage !== null && clazz.package.name.startsWith(beanBasePackage)) {
			clazz.package.name.replaceFirst(beanBasePackage, mapperBasePackage)
		} else {
			clazz.package.name
		}
	}
}