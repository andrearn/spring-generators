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

import com.google.inject.Binder
import com.google.inject.name.Names
import com.google.inject.util.Providers
import javax.inject.Named
import javax.inject.Singleton
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.JavaIoFileSystemAccess
import org.eclipse.xtext.resource.generic.AbstractGenericResourceRuntimeModule

class JdbcGeneratorModule extends AbstractGenericResourceRuntimeModule {
	
	static val JAVA = "JAVA"
	
	val JavaIoFileSystemAccess fsa
	@Accessors
	var boolean ignorePropertiesWithThrowsClauses = false
	@Accessors
	var boolean ignoreComplexProperties = true
	@Accessors
	var String beanBasePackage
	@Accessors
	var String mapperBasePackage
	@Accessors
	var String parameterSourceAnnotationClass
	@Accessors
	var String rowMapperAnnotationClass
	
	new (String genPath) {
		fsa = new JavaIoFileSystemAccess
		fsa.outputPath = genPath 
	}
	
	@Singleton
	def void configureIFileSystemAccess2(Binder binder) {
		binder.bind (typeof(IFileSystemAccess2) ).toInstance(fsa)
	}
	
	@Named("ignorePropertiesWithThrowsClauses")
	def void configureIgnorePropertiesWithThrowsClauses(Binder binder) {
		binder.bind (typeof(boolean)).annotatedWith(Names.named("ignorePropertiesWithThrowsClauses")).toInstance(ignorePropertiesWithThrowsClauses);
	}
	
	@Named("ignoreComplexProperties")
	def void configureIgnoreComplexProperties(Binder binder) {
		binder.bind (typeof(boolean)).annotatedWith(Names.named("ignoreComplexProperties")).toInstance(ignoreComplexProperties);
	}

	@Named("beanBasePackage")
	def void configureBeanBasePackage(Binder binder) {
		binder.bind (typeof(String)).annotatedWith(Names.named("beanBasePackage")).toProvider(Providers.<String>of(beanBasePackage));
	}

	@Named("mapperBasePackage")
	def void configureMapperBasePackage(Binder binder) {
		binder.bind (typeof(String)).annotatedWith(Names.named("mapperBasePackage")).toProvider(Providers.<String>of(mapperBasePackage));
	}
	@Named("parameterSourceAnnotationClass")
	def void configureParameterSourceAnnotationClass(Binder binder) {
		binder.bind (typeof(String)).annotatedWith(Names.named("parameterSourceAnnotationClass")).toProvider(Providers.<String>of(parameterSourceAnnotationClass));
	}
	@Named("rowMapperAnnotationClass")
	def void configureRowMapperAnnotationClass(Binder binder) {
		binder.bind (typeof(String)).annotatedWith(Names.named("rowMapperAnnotationClass")).toProvider(Providers.<String>of(rowMapperAnnotationClass));
	}
	
	override protected getFileExtensions() {
		"none"
	}
	
	override protected getLanguageName() {
		"none"
	}
	
}