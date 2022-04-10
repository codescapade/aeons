package;

import buddy.Buddy;

import aeons.assets.AssetsTest;
import aeons.core.ComponentTest;
import aeons.core.EntitiesTest;
import aeons.core.EntityTest;
import aeons.utils.TimSortTest;

@colorize
class RunTests implements Buddy<[
  AssetsTest,
  ComponentTest,
  EntitiesTest,
  EntityTest,
  TimSortTest
]> {}
