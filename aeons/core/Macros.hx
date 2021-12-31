package aeons.core;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

using haxe.macro.Tools;

class Macros {
  static function buildEvent(): Array<Field> {
    var fields = Context.getBuildFields();
    var classType = Context.getLocalClass().get();

    var path = classType.pack.concat([classType.name]);
    var pool = macro new aeons.utils.Pool($p{path});

    fields.push({
      name: 'pool',
      access: [APrivate, AStatic],
      pos: Context.currentPos(),
      kind: FVar(null, pool)
    });

    var putFunction: Field;

    for (field in fields) {
      if (field.name == 'put') {
        putFunction = field;
        break;
      }
    }

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
      
    }

    return fields;
  }
}
#end