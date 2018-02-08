package org.xkonnex.spring.generators.jdbc

import java.io.File
import org.junit.Test

import static org.junit.Assert.*

class GeneratorExtensionsTest {
	@Test 
	
	def void test() {
		val fileName = new GeneratorExtensions().classNameToFileName("org.xkonnex.MyClass")
		assertEquals('''org«File.separator»xkonnex«File.separator»MyClass.java'''.toString, fileName)
	}
}
