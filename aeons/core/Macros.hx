package aeons.core;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

using haxe.macro.Tools;

/**
 * The build system macros are inspired by Cog https://github.com/AustinEast/cog.
 */
class Macros {
  /**
   * @:autobuild function for the event classes.
   * This adds a static object pool for the events, makes all non-static fields public properties with (default, null),
   * adds a static get function with a eventType parameter and all non-static public properties as parameters.
   * Adds an init function to initialize all properties that is called from the get function on the event from the pool.
   * Adds a put function to recycle the events.
   * @return Array<Field>
   */
  static function buildEvent(): Array<Field> {
    // Get all the fields in the event class.
    final fields = Context.getBuildFields();

    // The event class.
    final classType = Context.getLocalClass().get();

    // The event complex type.
    final eventType = Context.getLocalType().toComplexType();

    // The full path to the class.
    final path = classType.pack.concat([classType.name]);

    // Create the 'new Pool(EventClass)'; expresion to initialize the static pool.
    final newPoolExpr = macro new aeons.utils.Pool($p{path});

    var putFunction: Field;
    var hasGet = false;

    // Find the put and get functions if they exist.
    for (field in fields) {
      switch (field.kind) {
        case FFun(func):
          if (field.name == 'put') {
            putFunction = field;
          } else if (field.name == 'get') {
            hasGet = true;
          }

        // Ignore everything else.
        default:
      }
    }

    // Create the static event pool field.
    fields.push({
      name: 'pool',
      access: [APrivate, AStatic],
      pos: Context.currentPos(),
      kind: FVar(null, newPoolExpr)
    });

    // Create a static get function to get an event from the object pool and itinitalize the fields if this function
    // does not exist.
    if (!hasGet) {
      // The first parameter in the get function is the type which is of EventType<EventClass>.
      final typeParam = { name: 'type', type: TPath({ name: 'EventType', pack: ['aeons', 'events'],
          params: [TPType(eventType)] })};

      final paramFields: Array<FunctionArg> = [typeParam];
      for (field in fields) {

        switch (field.kind) {
          case FVar(fType, fExpr):
            if (!field.access.contains(AStatic)) {
              // Make var fields public properties.
              field.access = [APublic];
              field.kind = FProp('default', 'null', fType, fExpr);
              // Get the class as parameter types for the get function.
              paramFields.push({ name: field.name, type: fType, value: fExpr });
            }
          case FProp(get, set, fType, fExpr):
            if (!field.access.contains(AStatic) && field.access.contains(APublic)) {

              // Get the class as parameter types for the get function.
              paramFields.push({ name: field.name, type: fType, value: fExpr });
            }

          default:
        }
      }

      // Create the 'this.variable = variable expressions for each parameter for the init function.
      final assignExprs: Array<Expr> = [];
      for (param in paramFields) {
        final name = param.name;
        assignExprs.push(macro { this.$name = $i{name}; });
      }

      // Create the init function that sets the new values for the event.
      fields.push({
        name: 'init',
        access: [APrivate],
        pos: Context.currentPos(),
        kind: FFun({
          args: paramFields,
          expr: macro $b{ assignExprs }
        })
      });

      final paramNames: Array<Expr> = [];
      for (param in paramFields) {
        paramNames.push(macro $i{param.name});
      }

      // Create the static get function. This has all the non static fields as parameters and calls
      // init with those fields on the event from the pool.
      fields.push({
        name: 'get',
        access: [APublic, AStatic],
        pos: Context.currentPos(),
        kind: FFun({
          args: paramFields,
          expr: macro {
            var event = pool.get();
            event.init($a{paramNames});

            return event;
          },
          ret: eventType

        })
      });

      fields.push({
        name: 'emit',
        access: [APublic, AStatic],
        pos: Context.currentPos(),
        kind: FFun({
          args: paramFields,
          expr: macro {
            var event = get($a{paramNames});

            aeons.Aeons.events.emit(event);
          },
          ret: macro: Void
        })
      });
    }

    // create an override put function and add pool.put(); to is so the event is returned to the pool.
    // if the put function already exists add that to the existing function.
    if (putFunction == null) {
      fields.push({
        name: 'put',
        pos: Context.currentPos(),
        access: [APublic, AOverride],
        kind: FFun({
          args: [],
          expr: macro {
            super.put();
            pool.put(this);
          },
          ret: macro: Void
        })
      });
    } else {
      switch (putFunction.kind) {
        case FFun(func):
          final expr = macro { pool.put(this); };
          func.expr = macro $b{[func.expr, expr]};

        default:
      }
    }

    return fields;
  }

  /**
   * Check if a type already exsits.
   * @param typeName The type to check.
   * @return True if the type exists.
   */
  static function typeExists(typeName: String): Bool {
    try {
      if (Context.getType(typeName) != null) {
        return true;
      }
    } catch (error: String) {

    }

    return false;
  }

  /**
   * Check if one class is a subclass of another.
   * @param sub The sub class.
   * @param parent The parent class to match.
   * @return True if the sub class is derived from the parent class.
   */
  static function isSubClass(sub: ClassType, parent: ClassType): Bool {
    if (sub.superClass == null) {
      return false;
    }

    if (sub.superClass.t.get().name != parent.name) {
      return isSubClass(sub.superClass.t.get(), parent);
    }

    return true;
  }

  /**
   * Macro to build the bundle types in the system classes.
   * @return The updated system fields.
   */
  static function buildSystem(): Array<Field> {
    final fields = Context.getBuildFields();
    var constructor: Field;
    var cleanup: Field;

    // Check if a constructor or cleanup function already exists.
    for (field in fields) {
      switch (field.kind) {
        case FFun(func):
          if (field.name == 'new') {
            constructor = field;
          }

          if (field.name == 'cleanup') {
            cleanup = field;
          }

        default:
      }
    }

    // Create a constructor if it doesn't exist.
    if (constructor == null) {
      constructor = {
        name: 'new',
        pos: Context.currentPos(),
        access: [APrivate],
        kind: FFun({
          args: [],
          expr: macro {super();}
        })
      };
      fields.push(constructor);
    }

    // Create a cleanup function if it doesn't exist.
    if (cleanup == null) {
      cleanup = {
        name: 'cleanup',
        pos: Context.currentPos(),
        access: [AOverride, APublic],
        kind: FFun({
          args: [],
          expr: macro {super.cleanup();},
          ret: macro: Void
        })
      };
      fields.push(cleanup);
    }

    for (field in fields) {
      // Check for @:bundle tags
      var hasBundleTag = false;
      if (field.meta != null) {
        for (tag in field.meta) {
          if (tag.name == ':bundle') {
            hasBundleTag = true;
          }
        }
      }
      if (!hasBundleTag) {
        continue;
      }

      switch (field.kind) {
        case FVar(fType, fExpr):
          final fieldName = field.name;
          // Set the field type to `BundleList<BundleOfType>`.
          field.kind = FieldType.FVar(macro: aeons.core.BundleList<$fType>, fExpr);

          try {
            // toType() can throw an error and break completion so wrapping it in try catch.
            final classType = fType.toType().getClass();
            final typePath = {
              name: classType.name,
              pack: classType.pack
            };

            // Get the fields of the created bundle. This will have the components for that bundle.
            // With these we can add the listeners for these components in the system.
            final bundleFields = fType.toType().getClass().fields.get();
            var componentClasses: Array<String> = [];
            for (bundleField in bundleFields) {
              componentClasses.push(bundleField.type.getClass().module);
            }

            // Initialize the bundleList in the constructor and add listeners for the components in the bundles.
            switch (constructor.kind) {
              case FFun(o):
                final constructorExprs = [o.expr];
                // initialize the bundleList at the end of the system constructor.
                final initBundleExpr = macro { $i{fieldName} = new aeons.core.BundleList<$fType>(); };
                constructorExprs.push(initBundleExpr);

                for (component in componentClasses) {
                  final listenerExpr = macro {
                    // Component added event listener. 
                    aeons.Aeons.events.on('aeons_' + $v{component} + '_added', (event: aeons.events.ComponentEvent) -> {
                      // Check if the entity has all required components.
                      if (event.entity.hasBundleComponents($v{componentClasses})) {
                        // Check if the entity is not already in the bundleList.
                        if (!$i{fieldName}.hasEntity(event.entity)) {
                          var b = new $typePath(event.entity);
                          $i{fieldName}.addBundle(b);
                        }
                      }
                    });

                    // Component removed event listener.
                    aeons.Aeons.events.on('aeons_' + $v{component} + '_removed',
                        (event: aeons.events.ComponentEvent) -> {
                      if ($i{fieldName}.hasEntity(event.entity)) {
                        $i{fieldName}.removeBundle(event.entity);
                      }
                    });
                  }
                  constructorExprs.push(listenerExpr);
                }

                // set the constructor expressions to the newly added lines.
                o.expr = macro $b{constructorExprs};
              default:
            }
          } catch (e) {
          }

        default:
      }
    }

    return fields;
  }

  /**
   * Create a new bundle type.
   * @return The created bundle type.
   */
  static function buildBundle(): ComplexType {
    return switch (Context.getLocalType()) {
      case TInst(_.get() => {name: 'Bundle'}, params):
        buildBundleClass(params);
      default:
        throw false;
    }
  }

  /**
   * Build bundle class type from the parameters. 
   * @param params <Position, Velocity, etc.>.
   * @return The newly created type.
   */
  static function buildBundleClass(params: Array<Type>): ComplexType {
    final names: Array<String> = [];
    for (param in params) {
      // Get the last part of the path which is the class name.
      // example 'aeons.core.Game'. result is 'Game'.
      final name = param.getClass().name.split('.').pop();
      names.push(name);
    }

    // Create a name for the bundle class using all component names together with 'Bundle' in front.
    // Bundle<Position, Velocity> will create class BundlePositionVelocity.
    var paramNames = names.join('');
    var name = 'Bundle$paramNames';

    // Only add a new class if it does not exist yet.
    if (!typeExists('aeons.bundles.$name')) {
      var pos = Context.currentPos();
      var fields:Array<Field> = [];
      var constructorExprs:Array<Expr> = [];
      var regex = ~/(?<!^)([A-Z])/g;

      // Add an Expr to get the 'components' to the constructor
      constructorExprs.push(macro {
        this.entity = entity;
      });

      // Loop through the params and add them to the Node's fields
      for (param in params) {
        var paramClass = param.getClass();

        var componentClass = Context.getType('aeons.core.Component').getClass();
        if (!isSubClass(paramClass, componentClass)) {
          throw('Class ${paramClass.name} does not extend "aeons.core.Component".');
        }

        // Make the param name snake_case
        var paramName = '';
        var testName = paramClass.name;
        while (regex.match(testName)) {
          paramName += regex.matchedLeft() + '_' + regex.matched(1);
          testName = regex.matchedRight();
        }
        paramName += testName;
        paramName = paramName.toLowerCase();

        // Add the Component to the Node's fields
        fields.push({
          name: paramName,
          pos: pos,
          kind: FVar(param.toComplexType()),
          access: [APublic]
        });

        var componentPath = paramClass.pack.concat([paramClass.name]);
        if (componentPath.length <= 1) componentPath.insert(0, paramClass.module);

        // Add an expression to get the component in the Node's constructor
        constructorExprs.push(macro this.$paramName = entity.getComponent($p{componentPath}));
      }

      // Create the Constructor
      fields.push({
        name: 'new',
        access: [APublic],
        pos: pos,
        kind: FFun({
          args: [{name: 'entity', type: TPath({name: 'Entity', pack: ['aeons', 'core']})}],
          expr: macro $b{constructorExprs},
          ret: macro:Void
        })
      });

      // Create the new bundle type.
      Context.defineType({
        pack: ['aeons', 'bundles'],
        name: name,
        pos: pos,
        params: [],
        kind: TDClass({
          pack: ['aeons', 'core'],
          name: 'BundleBase',
        }),
        fields: fields
      });
    }

    // Return the path to the new type.
    return TPath({pack: ['aeons', 'bundles'], name: name, params: []});
  }

  static function buildPool(): Array<Field> {
    final fields = Context.getBuildFields();
    final classMeta = Context.getLocalClass().get().meta.get();

    // Only add object pools to classes with @:poolable metadata.
    var isPoolable = false;
    if (classMeta != null) {
      for (tag in classMeta) {
        if (tag.name == ':poolable') {
          isPoolable = true;
        }
      }
    }

    if (!isPoolable) {
      return fields;
    }

    var constructor: Field;
    var putFunction: Field;

    // Check if a constructor or put function already exists.
    for (field in fields) {
      switch (field.kind) {
        case FFun(func):
          if (field.name == 'new') {
            constructor = field;
          } else if (field.name == 'put') {
            putFunction = field;
          }
        default:
      }
    }

    final classType = Context.getLocalClass().get();
    final complexType = Context.getLocalType().toComplexType();
    final path = classType.pack.concat([classType.name]);
    final poolExpr = macro new aeons.utils.Pool($p{path});

    // Create the static object pool.
    fields.push({
      name: 'pool',
      access: [APrivate, AStatic],
      pos: Context.currentPos(),
      kind: FVar(null, poolExpr)
    });

    // Add a constructor if it doesn't exist.
    if (constructor == null) {
      constructor = {
        name: 'new',
        pos: Context.currentPos(),
        access: [APublic],
        kind: FFun({
          args: [],
          expr: macro {super();}
        })
      };
      fields.push(constructor);
    }

    switch (constructor.kind) {
      case FFun(o):
        var args = o.args;
        var body: Array<Expr> = [];

        // Get the code inside the constructor except for the super(); call to copy it into the reset field.
        // Reset is called automatically when using get().
        o.expr.iter((f: Expr) -> {
          if (f.toString() != 'super()') {
            body.push(f);
          }
        });

        // Activate the component.
        body.push(macro {active = true;});

        // Create the reset function with the same parameters and code inside as the constructor so
        // you can use the constructor to set / reset the variables and it works for get() as well.
        fields.push({
          name: 'reset',
          pos: Context.currentPos(),
          access: [APublic],
          kind: FFun({
            args: args,
            expr: macro $b{body},
            ret: macro: Void
          })
        });

        // Convert the function parameters to variable names to pass into the reset function.
        var paramNames: Array<Expr> = [];
        for (param in args) {
          paramNames.push(macro $i{param.name});
        }

        // Create the static get function to get a component from the object pool.
        fields.push({
          name: 'get',
          access: [APublic, AStatic],
          pos: Context.currentPos(),
          kind: FFun({
            args: args,
            expr: macro {
              var component = pool.get($a{paramNames});
              component.reset($a{paramNames});

              return component;
            },
            ret: complexType
          })
        });

      default:
    }

    // create an override put function and add pool.put(); to is so the event is returned to the pool.
    // if the put function already exists add that to the existing function.
    if (putFunction == null) {
      fields.push({
        name: 'put',
        pos: Context.currentPos(),
        access: [APublic, AOverride],
        kind: FFun({
          args: [],
          expr: macro {
            pool.put(this);
          },
          ret: macro: Void
        })
      });
    } else {
      switch (putFunction.kind) {
        case FFun(func):
          final expr = macro { pool.put(this); };
          func.expr = macro $b{[func.expr, expr]};

        default:
      }
    }

    return fields;
  }
}
#end
