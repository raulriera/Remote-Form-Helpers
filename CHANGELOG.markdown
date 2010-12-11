# CHANGE LOG
- Version 0.9:
	- Drops support for anything below 1.1
	- Removes obstructive JavaScript from the output.
	- Drops support for all remoteXXX functions, now reuses Wheels current methods and adds "remote=true" as an argument.
	- Includes a "jQuery adapter" (can be switched easily to other framerworks)

- Version 0.8:
	- Support for Wheels 1.1.
	- Added `pageVisualEffect` (requires jQuery's UI library)
	- Fixed a problem with the callbacks, now you you can pass Javascript directly to it
	- Added `pageInsertFlash` (Thanks to Adam Michel).
	- Reworked `renderJavascript` to make use of `pageInsertFlash` (Thanks to Adam Michel).
	- Removed `renderJavascript`, with "provides" this is not needed.
	- Fixed a bunch of issues with ColdFusion 8.
	- Improved the documentation.
- Version 0.7:
	- Fixed for a missing semicolon
	- Fixed more issues with `remoteButtonTo`
	- Added `renderJavascript` (Thanks to Adam Michel)
- Version 0.6:
	- Support for `remoteButtonTo` (Thanks to Adam Michel)
	- Support for `pageRedirectTo`
	- Removed white space from the outputs of each function
	- Improved documentation in the plugin's home.
	
- Version 0.4:
	- Support for Wheels 1.0.5 (Thanks to Joshua Clingenpeel)
	
- Version 0.3:
	- Support for Wheels 1.0.2.
	- Support for `renderRemotePage`.
	- Support for wrapper functions to insert HTML, replace HTML, remove element, show element and hide element (pageInsertHTML, pageReplaceHTML, pageRemove, pageShow, pageHide)
	- Filename convention for remote views is `actionName.js.cfm`
	- Overall change on how the requests are handled. Now jQuery will parse the data sent from the controller (using the renderRemotePage)
	- Made all callbacks optional.
	- Removed the suffix "Callback" from all callbacks.
	- Support for `complete` and `beforeSend` callback.
	- Code cleanup.

- Version 0.2:
	- Support for `remoteLinkTo`.
	- Reused the code in `endFormTag` for `endRemoteFormTag`.
	- Fixed some typos in the plugin's index file.

- Version 0.1:
	- Initial release.
	- Support for `startRemoteFormTag` and `endRemoteFormTag`.
	- Support for `success` and `error` callbacks.
