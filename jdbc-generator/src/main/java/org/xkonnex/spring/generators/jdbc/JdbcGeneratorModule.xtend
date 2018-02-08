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
import javax.inject.Singleton
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.JavaIoFileSystemAccess
import org.eclipse.xtext.generator.OutputConfiguration
import org.eclipse.xtext.resource.generic.AbstractGenericResourceRuntimeModule

class JdbcGeneratorModule extends AbstractGenericResourceRuntimeModule {
	
	static val JAVA = "JAVA"
	
	val JavaIoFileSystemAccess fsa 
	
	new (String genPath) {
		fsa = new JavaIoFileSystemAccess
		fsa.outputPath = genPath 
	}
	
	@Singleton
	def void configureIFileSystemAccess2(Binder binder) {
		binder.bind (typeof(IFileSystemAccess2) ).toInstance(fsa)
	}
	
	override protected getFileExtensions() {
		"none"
	}
	
	override protected getLanguageName() {
		"none"
	}
	
}