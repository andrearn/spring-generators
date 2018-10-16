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
import java.io.BufferedReader
import java.io.FileReader
import java.util.Map
import javax.inject.Named
import javax.inject.Singleton
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.JavaIoFileSystemAccess
import org.eclipse.xtext.resource.generic.AbstractGenericResourceRuntimeModule
import com.google.inject.TypeLiteral

class JdbcGeneratorModule extends AbstractGenericResourceRuntimeModule {
	
	static val CSV_SEPERATORS = "\\s|,|;";
	
	val JavaIoFileSystemAccess fsa
	
	/**
	 * Whether bean properties with accessor methods throwing exceptions shall be ignored
	 */
	@Accessors
	var boolean ignorePropertiesWithThrowsClauses = false
	
	/**
	 * Whether bean properties of complex types shall be ignored
	 */
	@Accessors
	var boolean ignoreComplexProperties = true
	
	@Accessors
	var String beanBasePackage
	
	/**
	 * Base package of generated mappers. The name of the subpackage of beans inside 
	 * beanBasePackage is being appended to the mapperBasePackage 
	 */
	@Accessors
	var String mapperBasePackage
	
	/**
	 * Full qualified class name of the annotation class to mark Factories for SqlParameterSources, 
	 * i.e. ParameterBuilders
	 */
	@Accessors
	var String parameterSourceAnnotationClass
	/**
	 * Full qualified class name of the annotation class to mark RowMappers.
	 */
	@Accessors
	var String rowMapperAnnotationClass
	
	/**
	 * Use the property name to column name mapping used by Spring <= 3.2.6 if true. Defaults to false. Use the
	 * new name mapping scheme as of Spring JDBC 3.2.7 and later otherwise
	 */
	@Accessors
	var boolean useOldFieldnameMapping = false
	
	/**
	 * Whether existing classes should be overwritten
	 */
	@Accessors
	var boolean overrideExistingResources = false
	
	/**
	 * Map of custom property name mapping rules
	 * 
	 * property name -> column name
	 */
	@Accessors
	var Map<String, String> customPropertyToColumnRules = newHashMap
	
	/**
	 * The RowMapper checks if the column to be assigned to a bean property is in the ResultSet
	 */
	@Accessors
	var boolean withColumnCheck = false
	
	@Accessors
	var boolean useConstantsForColumnNames = false
	
	/**
	 * The RowMapper checks if all columns have been assigned to a bean property
	 */
	@Accessors
	var boolean withPropertyAssignmentCheck = false
	
	new (String genPath) {
		fsa = new JavaIoFileSystemAccess
		fsa.outputPath = genPath 
	}
	
	/**
	 * @param genPath path, where to generate mappers
	 * @param configPath location of CSV-file containing custom property name mapping rules
	 */
	new (String genPath, String configPath) {
		fsa = new JavaIoFileSystemAccess
		fsa.outputPath = genPath 
		val br = new BufferedReader(new FileReader(configPath));
		System.out.println("Reading column name mappings listed in file " + configPath);
		var String line = null;
		while ((line = br.readLine()) !== null) {
			val names = line.split(CSV_SEPERATORS);
			if (names.length == 2 && !(line.startsWith("Property") && line.contains("Column"))) {
				customPropertyToColumnRules.put(names.get(0), names.get(1))
			}
		}
	}
	
	@Singleton
	def void configureIFileSystemAccess2(Binder binder) {
		fsa.outputConfigurations.get(IFileSystemAccess2.DEFAULT_OUTPUT).overrideExistingResources = overrideExistingResources
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
	def void configureBeanBasePackage (Binder binder) {
		binder.bind (typeof(String)).annotatedWith(Names.named("beanBasePackage")).toProvider(Providers.<String>of(beanBasePackage));
	}

	@Named("mapperBasePackage")
	def void configureMapperBasePackage (Binder binder) {
		binder.bind (typeof(String)).annotatedWith(Names.named("mapperBasePackage")).toProvider(Providers.<String>of(mapperBasePackage));
	}
	@Named("parameterSourceAnnotationClass")
	def void configureParameterSourceAnnotationClass (Binder binder) {
		binder.bind (typeof(String)).annotatedWith(Names.named("parameterSourceAnnotationClass")).toProvider(Providers.<String>of(parameterSourceAnnotationClass));
	}
	@Named("rowMapperAnnotationClass")
	def void configureRowMapperAnnotationClass (Binder binder) {
		binder.bind (typeof(String)).annotatedWith(Names.named("rowMapperAnnotationClass")).toProvider(Providers.<String>of(rowMapperAnnotationClass));
	}
	@Named("useOldFieldnameMapping")
	def void configureUseOldFieldnameMapping (Binder binder) {
		binder.bind (typeof(boolean)).annotatedWith(Names.named("useOldFieldnameMapping")).toInstance(useOldFieldnameMapping);
	}
	@Named("customPropertyToColumnRules")
	def void configureCustomPropertyToColumnRules (Binder binder) {
		binder.bind (new TypeLiteral<Map<String, String>>() {}).annotatedWith(Names.named("customPropertyToColumnRules")).toInstance(customPropertyToColumnRules);
	}
	@Named("withColumnCheck")
	def void  configureWithColumnCheck (Binder binder) {
		binder.bind (typeof(boolean)).annotatedWith(Names.named("withColumnCheck")).toInstance(withColumnCheck);
	}
	@Named("withPropertyAssignmentCheck")
	def void configureWithPropertyAssignmentCheck (Binder binder) {
		binder.bind (typeof(boolean)).annotatedWith(Names.named("withPropertyAssignmentCheck")).toInstance(withPropertyAssignmentCheck);
	}
	@Named("useConstantsForColumnNames")
	def void configureUseConstantsForColumnNames (Binder binder) {
		binder.bind (typeof(boolean)).annotatedWith(Names.named("useConstantsForColumnNames")).toInstance(useConstantsForColumnNames);
	}
	
	override protected getFileExtensions() {
		"none"
	}
	
	override protected getLanguageName() {
		"none"
	}
	
}