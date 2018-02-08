package org.xkonnex.spring.generators.jdbc

import java.io.File

class GeneratorExtensions {
	
	def classNameToFileName(String className) {
		className.replace(".", File.separator) + ".java"
	}
}