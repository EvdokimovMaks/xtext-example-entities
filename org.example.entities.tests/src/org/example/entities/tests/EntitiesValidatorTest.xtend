package org.example.entities.tests

import com.google.inject.Inject
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.eclipse.xtext.testing.util.ParseHelper
import org.example.entities.entities.Model
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith
import org.eclipse.xtext.testing.validation.ValidationTestHelper
import org.example.entities.entities.EntitiesPackage
import org.example.entities.validation.EntitiesValidator

@ExtendWith(InjectionExtension)
@InjectWith(EntitiesInjectorProvider)
class EntitiesValidatorTest {
	
	@Inject extension ParseHelper<Model>
	@Inject extension ValidationTestHelper
	
	@Test
	def void testEntityExtendsItself() {
		'''
			entity MyEntity extends MyEntity { }
		'''.parse.assertCycleInHyerarchy("MyEntity")				
	}
	
	def private assertCycleInHyerarchy(Model m, String entityName) {
		m.assertError(
			EntitiesPackage.eINSTANCE.entity,
			EntitiesValidator.HIERARCHY_CYCLE
		)
	}
	
}