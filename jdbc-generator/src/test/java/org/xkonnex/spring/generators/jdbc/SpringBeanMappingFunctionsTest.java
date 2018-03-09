package org.xkonnex.spring.generators.jdbc;

import static org.junit.Assert.assertEquals;

import org.junit.Test;

import com.google.inject.Guice;
import com.google.inject.Injector;

public class SpringBeanMappingFunctionsTest {

	@Test
	public void testUnderscoreName() throws Exception {
		JdbcGeneratorModule moduleOld = new JdbcGeneratorModule("src/gen/java", "./src/test/resources/ColumnMapping.csv");
		moduleOld.setUseOldFieldnameMapping(true);
		Injector oldInjector = Guice.createInjector(moduleOld);
		SpringBeanMappingFunctions oldMappingFunctions = oldInjector.getInstance(SpringBeanMappingFunctions.class);
		assertEquals("FIRST_NAME", oldMappingFunctions.underscoreName("firstName").toUpperCase());
		assertEquals("TEXT_1", oldMappingFunctions.underscoreName("text1").toUpperCase());
		assertEquals("TEXT_1234", oldMappingFunctions.underscoreName("text1234"));

		JdbcGeneratorModule moduleNew = new JdbcGeneratorModule("src/gen/java");
		moduleNew.setUseOldFieldnameMapping(false);
		Injector newInjector = Guice.createInjector(moduleNew);
		SpringBeanMappingFunctions newMappingFunctions = newInjector.getInstance(SpringBeanMappingFunctions.class);
		assertEquals("FIRST_NAME", newMappingFunctions.underscoreName("firstName").toUpperCase());
		assertEquals("TEXT1", newMappingFunctions.underscoreName("text1").toUpperCase());
	}

	@Test
	public void testUnderscoreNameOld() throws Exception {
		SpringBeanMappingFunctions mappingFunctions = new SpringBeanMappingFunctions();
		assertEquals("FIRST_NAME", mappingFunctions.underscoreNameOld("firstName").toUpperCase());
		assertEquals("TEXT_1", mappingFunctions.underscoreNameOld("text1").toUpperCase());
	}

	@Test
	public void testUnderscoreNameNew() throws Exception {
		SpringBeanMappingFunctions mappingFunctions = new SpringBeanMappingFunctions();
		assertEquals("FIRST_NAME", mappingFunctions.underscoreNameNew("firstName").toUpperCase());
		assertEquals("TEXT1", mappingFunctions.underscoreNameNew("text1").toUpperCase());
	}

}
