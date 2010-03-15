# CHANGE LOG
- Version 0.3:
	- Support for Wheels 1.0.2.
	- Support for `renderRemotePage`.
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
