## 0.4.0 - TBD
---
### Fixed
- Fixed `frameName` not being set in the `CSprite` component.
- Fixed `SNapePhysics` system and added debug drawing to it.
- Fixed rendering things that are parented to the camera.

### Added
- Added `magnitude()` function to `Vector2`.
- Added `CLayer` component.
- Added `percentageComplete` field to the `Tween` class you how can track how far along a tween is.
- Added `updateTarget` function so you can update a target and properties mid tween.
- Added `layersToIgnore` field to the `CCamera` component. This allows you to render only certain layers per camera.
- Added `iteration` field to the `SSimplePhysics` system for more stability. Defaults to 8 iterations per step.

### Removed
- Removed null services because they are not needed.
- Removed zIndex from the `CTransform` component.
- Removed broken timsort implementation.
- Removed `anchorX` and `anchorY` from the `Renderable` interface. Not all renderable components need it.

### Changed
- Instead of sorting using a zIndex, the `SRender` system now uses the `CLayer` component to determine the order.

---
<br>

## 0.3.1 - 2022-09-30
---
### Fixed
- Starter template for aeons create updated to work with 0.3 versions.
- Fixed camera component resetting transform if it was changed before the camera was added.

---
<br>

## 0.3.0 - 2022-09-26
---
### Fixed
- Build not working when there is no atlas entry in the aeons.toml file

### Added
- Added `customIndexFile` option in the html5 export options to allow for a custom index.html file when exporting to html5.
- Added bitmap font support.
- Added call priority when adding systems.
- Added resize callback event and a resize function in the Scene class.
- Added camera shader support.

### Changed
- Changed how you initialize Scenes, Entities, Components and Systems. They now take a Class instead of an instance and use a `create` function for initialization.
- Updated Kha to commit 2de99e5.

---
<br>

## 0.2.0 - 2022-07-17
---
### Changed
- Moved project configuration to a aeons.toml file. On build this will be used to generate the sprite atlases and the
  khafile before building the project with kha.

---
<br>

## 0.1.1 - 2022-07-06
---
### Fixed
- Fixed `aeons` command in haxelib for macos and linux.

---
<br>

## 0.1.0 - 2022-07-03
---
First Haxelib release.

---