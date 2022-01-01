package aeons.core;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

using haxe.macro.Tools;

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

    final path = classType.pack.concat([classType.name]);

    // Create the 'new Pool(EventClass)'; expresion to initialize the static pool.
    final newPoolExpr = macro new aeons.utils.Pool($p{ path });

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
        case _:
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
              final classType = fType.toType().getClass();
              paramFields.push({ name: field.name, type: TPath({ name: classType.name, pack: classType.pack }) });
            }

          case FProp(get, set, fType, fExpr):
            if (!field.access.contains(AStatic) && field.access.contains(APublic)) {
              // Get the class as parameter types for the get function.
              var classType = fType.toType().getClass();
              paramFields.push({ name: field.name, type: TPath({ name: classType.name, pack: classType.pack }) });
            }

          case _:
        }
      }

      // Create the 'this.variable = variable expressions for each parameter for the init function.
      final assignExprs: Array<Expr> = [];
      for (param in paramFields) {
        final name = param.name;
        assignExprs.push(macro { this.$name = $i{ name }; });
      }

      // Create the init function that sets the new values for the event.
      fields.push({
        name: 'init',
        access: [APrivate],
        pos: Context.currentPos(),
        kind: FFun({
          args: paramFields,
          expr: macro $b{assignExprs}
        })
      });

      final paramNames: Array<Expr> = [];
      for (param in paramFields) {
        paramNames.push(macro $i{ param.name });
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
            event.init($a{ paramNames });

            return event;
          },
          ret: eventType

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
          func.expr = macro $b{ [func.expr, expr] };
        case _:
      }
    }

    return fields;
  }
}
#end