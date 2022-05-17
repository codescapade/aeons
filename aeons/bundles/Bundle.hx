package aeons.bundles;

/**
 * The Bundle class is used to generate the bundles in systems using macros.
 */
@:genericBuild(aeons.core.Macros.buildBundle())
class Bundle<Rest> {}
