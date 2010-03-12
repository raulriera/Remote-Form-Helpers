# CHANGE LOG
- Version 0.3:
	- Support for `renderRemotePage`.
	- Overall change on how the request are handled. Now jQuery will parse the data sent from the controller (using the renderRemotePage)
	- Made callbacks optional.
	- Code cleanup.

- Version 0.2:
	- Support for `remoteLinkTo`.
	- Reused the code in `endFormTag` for `endRemoteFormTag`.
	- Fixed some typos in the plugin's index file.

- Version 0.1:
	- Initial release.
	- Support for `startRemoteFormTag` and `endRemoteFormTag`.
	- Support for `success` and `error` callbacks.
