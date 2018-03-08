package org.xkonnex.spring.generators.jdbc;

import static org.junit.Assert.assertEquals;

import org.junit.Test;

public class SpringBeanMappingFunctionsTest {

	@Test
	public void testUnderscoreName() throws Exception {
		SpringBeanMappingFunctions mappingFunctions = new SpringBeanMappingFunctions();
		assertEquals("FIRST_NAME", mappingFunctions.underscoreName("firstName").toUpperCase());
		assertEquals("TEXT_1", mappingFunctions.underscoreName("text1").toUpperCase());
	}

	@Test
	public void testUnderscoreNameNew() throws Exception {
		SpringBeanMappingFunctions mappingFunctions = new SpringBeanMappingFunctions();
		assertEquals("FIRST_NAME", mappingFunctions.underscoreNameNew("firstName").toUpperCase());
		assertEquals("TEXT1", mappingFunctions.underscoreNameNew("text1").toUpperCase());
	}

}
