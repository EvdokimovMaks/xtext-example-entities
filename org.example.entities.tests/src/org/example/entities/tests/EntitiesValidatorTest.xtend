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
	
	@Test
	def void testCicleInEntityHierarchy() {
		'''
			entity A extends B {}
			entity B extends C {}
			entity C extends A {}
		'''.parse => [
			assertCycleInHyerarchy('A')
			assertCycleInHyerarchy('B')
			assertCycleInHyerarchy('C')
		]
	}
	
	@Test
	def void testCycleInHierarchyErrorPosition() {
		val testInput =
		'''
			entity MyEntity extends MyEntity {}
		'''
		testInput.parse.assertError(
			EntitiesPackage.eINSTANCE.entity,
			EntitiesValidator.HIERARCHY_CYCLE,
			testInput.lastIndexOf("MyEntity"),
			"MyEntity".length
		)
	}
	
	@Test
	def void testValidHierarchy() {
		'''
			entity A {}
			entity B extends A {}
		'''.parse.assertNoErrors
	}
	
	def private assertCycleInHyerarchy(Model m, String entityName) {
		m.assertError(
			EntitiesPackage.eINSTANCE.entity,
			EntitiesValidator.HIERARCHY_CYCLE
		)
	}
	
}