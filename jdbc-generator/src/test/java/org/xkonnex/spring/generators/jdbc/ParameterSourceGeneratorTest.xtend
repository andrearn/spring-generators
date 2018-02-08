package org.xkonnex.spring.generators.jdbc

import com.google.inject.Guice
import java.io.File
import org.junit.Assert
import org.junit.Test

class ParameterSourceGeneratorTest {
	
	@Test
	def testGenerate() {
		val injector = Guice.createInjector(new JdbcGeneratorModule("src/gen/java"))
		val gen = injector.getInstance(ParameterSourceGenerator)
		gen.generate(SampleBean)
		val genFile = new File('''src«File.separator»gen«File.separator»java«File.separator»org«File.separator»xkonnex«File.separator»spring«File.separator»generators«File.separator»jdbc«File.separator»SampleBeanParameterBuilder.java''')
		Assert.assertTrue(genFile.exists)
	}
}
