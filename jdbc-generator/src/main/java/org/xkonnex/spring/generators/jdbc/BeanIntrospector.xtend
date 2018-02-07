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

import java.beans.Introspector
import java.beans.PropertyDescriptor

class BeanIntrospector {

	def getReadableProperties(Class<?> clazz) {
		val beanInfo = Introspector.getBeanInfo(clazz, typeof(Object))
		beanInfo.propertyDescriptors.filter[readMethod !== null].toList
	}

	def getWritableProperties(Class<?> clazz) {
		val beanInfo = Introspector.getBeanInfo(clazz, typeof(Object))
		beanInfo.propertyDescriptors.filter[writeMethod !== null].toList
	}

	def getImportedTypes(Class<?> clazz) {
		clazz.getReadableProperties.map[propertyType].filter[!isPrimitive && !canonicalName.startsWith("java.lang")].
			map[canonicalName].toSet.sort
	}

}
