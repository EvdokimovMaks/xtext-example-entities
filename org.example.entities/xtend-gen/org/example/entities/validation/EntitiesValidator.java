package org.example.entities.validation;

import java.util.HashSet;
import org.eclipse.xtext.validation.Check;
import org.eclipse.xtext.xbase.lib.CollectionLiterals;
import org.example.entities.entities.Attribute;
import org.example.entities.entities.EntitiesPackage;
import org.example.entities.entities.Entity;
import org.example.entities.validation.AbstractEntitiesValidator;

/**
 * This class contains custom validation rules.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#validation
 */
@SuppressWarnings("all")
public class EntitiesValidator extends AbstractEntitiesValidator {
  protected static final String ISSUE_CODE_PREFIX = "org.example.entities.";
  
  public static final String HIERARCHY_CYCLE = (EntitiesValidator.ISSUE_CODE_PREFIX + "HyerarchyCycle");
  
  public static final String INVALID_ENTITY_NAME = (EntitiesValidator.ISSUE_CODE_PREFIX + "InvalidEntityName");
  
  public static final String INVALID_ATTRIBUTE_NAME = (EntitiesValidator.ISSUE_CODE_PREFIX + "InvalidAttributeName");
  
  @Check
  public void checkNoCycleInEntityHierarchy(final Entity entity) {
    Entity _superType = entity.getSuperType();
    boolean _tripleEquals = (_superType == null);
    if (_tripleEquals) {
      return;
    }
    final HashSet<Entity> visitedEntities = CollectionLiterals.<Entity>newHashSet(entity);
    Entity current = entity.getSuperType();
    while ((current != null)) {
      {
        boolean _contains = visitedEntities.contains(current);
        if (_contains) {
          String _name = current.getName();
          String _plus = ("cycle in hierarchy of entity " + _name);
          this.error(_plus, 
            EntitiesPackage.eINSTANCE.getEntity_SuperType(), 
            EntitiesValidator.HIERARCHY_CYCLE, 
            current.getSuperType().getName());
          return;
        }
        visitedEntities.add(current);
        current = current.getSuperType();
      }
    }
  }
  
  @Check
  public void checkEntityNameStartsWithCapital(final Entity entity) {
    boolean _isLowerCase = Character.isLowerCase(entity.getName().charAt(0));
    if (_isLowerCase) {
      this.warning("Entity name should start with capital", 
        EntitiesPackage.eINSTANCE.getEntity_Name(), 
        EntitiesValidator.INVALID_ENTITY_NAME, 
        entity.getName());
    }
  }
  
  @Check
  public void checkAttributeNameStartsWithLowercase(final Attribute attribute) {
    boolean _isUpperCase = Character.isUpperCase(attribute.getName().charAt(0));
    if (_isUpperCase) {
      this.warning("Attribute name should start with lowercase", 
        EntitiesPackage.eINSTANCE.getAttribute_Name(), 
        EntitiesValidator.INVALID_ATTRIBUTE_NAME, 
        attribute.getName());
    }
  }
}
