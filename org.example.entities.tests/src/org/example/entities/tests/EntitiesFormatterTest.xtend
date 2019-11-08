package org.example.entities.tests

import org.junit.jupiter.api.^extension.ExtendWith
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import com.google.inject.Inject
import org.eclipse.xtext.testing.formatter.FormatterTestHelper
import org.junit.jupiter.api.Test

@ExtendWith(InjectionExtension)
@InjectWith(EntitiesInjectorProvider)

class EntitiesFormatterTest {
	
	@Inject extension FormatterTestHelper
	
	@Test
	def void testEntitiesFormatter() {
		assertFormatted[
			toBeFormatted = '''
				entity E1 { int i ; string s; boolean b     ; }
				entity  E2 extends E1{}
			'''
			expectation = '''
				entity E1 {
					int i;
					string s;
					boolean b;
				}
				
				entity E2 extends E1 {
				}
			'''
		]		
	}
	
}