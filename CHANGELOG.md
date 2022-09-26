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

## 0.2.0 - 2022-07-17
---
### Changed
- Moved project configuration to a aeons.toml file. On build this will be used to generate the sprite atlases and the
  khafile before building the project with kha.
## 0.1.1 - 2022-07-06
---
### Fixed
- Fixed aeons command in haxelib for macos and linux.

## 0.1.0 - 2022-07-03
---
First Haxelib release.