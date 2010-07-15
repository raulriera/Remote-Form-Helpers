<cfcomponent output="false" mixin="controller">

	<cffunction name="init">
		<cfset this.version = "1.0.5,1.0.2,1.0.1,1.0">
		<cfreturn this>
	</cffunction>

	<cffunction name="pageInsertHTML" access="public" hint="Inserts HTML content at the specified position and HTML element">
		<cfargument name="selector" type="string" required="true" hint="The class or ID of the content you wish to insert HTML into" />
		<cfargument name="position" type="string" required="false" default="before" hint="Position to insert the content into" />
		<cfargument name="content" type="string" required="false" hint="HTML to insert into" />
		<cfargument name="partial" type="string" required="false" hint="Partial file containing the HTML you wish to insert to" />

		<cfset var loc = {}>

		<cfswitch expression="#arguments.position#">
			<cfcase value="before">
				<cfset arguments.position = "prepend">
			</cfcase>
			<cfcase value="after">
				<cfset arguments.position = "append">
			</cfcase>
			<cfdefaultcase>
				<!--- Throw informative Wheels error --->
			</cfdefaultcase>
		</cfswitch>

		<cfif StructKeyExists(arguments, "content")>
			<cfset loc.HTMLContent = JSStringFormat(arguments.content)>
		<cfelseif StructKeyExists(arguments, "partial")>
			<cfset loc.HTMLContent = JSStringFormat(includePartial(arguments.partial))>
		<cfelse>
			<!--- Throw informative Wheels error --->
		</cfif>

		<cfset loc.resultHTML = "$('#arguments.selector#').#arguments.position#('#loc.HTMLContent#');">

		<cfreturn loc.resultHTML />
	</cffunction>

	<cffunction name="pageReplaceHTML" access="public" hint="Replace the HTML content of the specified element">
		<cfargument name="selector" type="string" required="true" hint="The class or ID of the content you wish to insert HTML into" />
		<cfargument name="content" type="string" required="false" hint="HTML to replace with" />
		<cfargument name="partial" type="string" required="false" hint="Partial file containing the HTML you wish to replace with" />

		<cfset var loc = {}>

		<cfif StructKeyExists(arguments, "content")>
			<cfset loc.HTMLContent = JSStringFormat(arguments.content)>
		<cfelseif StructKeyExists(arguments, "partial")>
			<cfset loc.HTMLContent = JSStringFormat(includePartial(arguments.partial))>
		<cfelse>
			<!--- Throw informative Wheels error --->
		</cfif>

		<cfset loc.resultHTML = "$('#arguments.selector#').html('#loc.HTMLContent#');">

		<cfreturn loc.resultHTML />
	</cffunction>

	<cffunction name="pageRemove" access="public" hint="Removes the specified element">
		<cfargument name="selector" type="string" required="true" hint="The class or ID of the content you wish to insert HTML into" />
		<!---<cfargument name="options" type="string" required="false" hint="jQuery specific options to the apply to the remove function" />--->

		<cfset var loc = {}>

		<cfset loc.resultHTML = "$('#arguments.selector#').remove();">

		<cfreturn loc.resultHTML />
	</cffunction>

	<cffunction name="pageHide" access="public" hint="Hides the specified element">
		<cfargument name="selector" type="string" required="true" hint="The class or ID of the content you wish to hide" />

		<cfset var loc = {}>

		<cfset loc.resultHTML = "$('#arguments.selector#').hide();">

		<cfreturn loc.resultHTML />
	</cffunction>

	<cffunction name="pageShow" access="public" hint="Shows the specified element">
		<cfargument name="selector" type="string" required="true" hint="The class or ID of the content you wish to show" />

		<cfset var loc = {}>

		<cfset loc.resultHTML = "$('#arguments.selector#').show();">

		<cfreturn loc.resultHTML />
	</cffunction>

	<cffunction name="renderRemotePage" access="public" hint="Renders the specified remote view, it will append a '.js' value to the current action, or the value specified in the 'action' argument. So your filename should be [action].js.cfm">
		<cfargument name="action" type="string" default="#params.action#" />

		<!--- Render the page with no layout and with a suffix of "js" --->
		<cfreturn renderPage(action="#arguments.action#.js", layout=false)>
	</cffunction>

	<cffunction name="startRemoteFormTag" returntype="string" access="public" output="false"
		hint="Builds and returns a string containing the opening form tag. The form's action will be built according to the same rules as `URLFor`.">
		<cfargument name="method" type="string" required="false" default="#application.wheels.functions.startFormTag.method#" hint="See documentation for @startFormTag">
		<cfargument name="route" type="string" required="false" default="" hint="See documentation for @URLFor">
		<cfargument name="controller" type="string" required="false" default="" hint="See documentation for @URLFor">
		<cfargument name="action" type="string" required="false" default="" hint="See documentation for @URLFor">
		<cfargument name="key" type="any" required="false" default="" hint="See documentation for @URLFor">
		<cfargument name="params" type="string" required="false" default="" hint="See documentation for @URLFor">
		<cfargument name="anchor" type="string" required="false" default="" hint="See documentation for @URLFor">
		<cfargument name="onlyPath" type="boolean" required="false" default="#application.wheels.functions.startFormTag.onlyPath#" hint="See documentation for @URLFor">
		<cfargument name="host" type="string" required="false" default="#application.wheels.functions.startFormTag.host#" hint="See documentation for @URLFor">
		<cfargument name="protocol" type="string" required="false" default="#application.wheels.functions.startFormTag.protocol#" hint="See documentation for @URLFor">
		<cfargument name="port" type="numeric" required="false" default="#application.wheels.functions.startFormTag.port#" hint="See documentation for @URLFor">
		<cfargument name="onSuccess" type="string" required="false" hint="Function to execute when the ajax request succeeds" />
		<cfargument name="onError" type="string" required="false" hint="Function to execute when the ajax request fails" />
		<cfargument name="onComplete" type="string" required="false" hint="Function to execute when the ajax request is complete (runs on error and success)" />
		<cfargument name="onBeforeSend" type="string" required="false" hint="Function to execute before the ajax request is sent." />

		<cfscript>
			var loc = {};
			$insertDefaults(name="startFormTag", input=arguments);

			// sets a flag to indicate whether we use get or post on this form, used when obfuscating params
			request.wheels.currentFormMethod = arguments.method;

			// set the form's action attribute to the URL that we want to send to
			arguments.action = URLFor(argumentCollection=arguments);

			// make sure we return XHMTL compliant code
			arguments.action = Replace(arguments.action, "&", "&amp;", "all");

			loc.skip = "route,controller,key,params,anchor,onlyPath,host,protocol,port,onSuccess,onError,onComplete,onBeforeSend";
			if (Len(arguments.route))
				loc.skip = ListAppend(loc.skip, $routeVariables(argumentCollection=arguments)); // variables passed in as route arguments should not be added to the html element
			if (ListFind(loc.skip, "action"))
				loc.skip = ListDeleteAt(loc.skip, ListFind(loc.skip, "action")); // need to re-add action here even if it was removed due to being a route variable above

			// setup the onSubmit attribute
			arguments.onSubmit = $ajaxSetup(argumentCollection=arguments);

			loc.returnValue = $tag(name="form", skip=loc.skip, attributes=arguments);
		</cfscript>
		<cfreturn loc.returnValue>
	</cffunction>

	<cffunction name="endRemoteFormTag" returntype="string" access="public" output="false"
		hint="Builds and returns a string containing the closing `form` tag.">
		<cfreturn endFormTag()>
	</cffunction>

	<cffunction name="remoteLinkTo" returntype="string" access="public" output="false"
		hint="Creates an AJAX link to another page in your application.">
		<cfargument name="text" type="string" required="false" default="" hint="See documentation for @linkTo">
		<cfargument name="confirm" type="string" required="false" default="" hint="See documentation for @linkTo">
		<cfargument name="route" type="string" required="false" default="" hint="See documentation for @URLFor">
		<cfargument name="controller" type="string" required="false" default="" hint="See documentation for @URLFor">
		<cfargument name="action" type="string" required="false" default="" hint="See documentation for @URLFor">
		<cfargument name="key" type="any" required="false" default="" hint="See documentation for @URLFor">
		<cfargument name="params" type="string" required="false" default="" hint="See documentation for @URLFor">
		<cfargument name="anchor" type="string" required="false" default="" hint="See documentation for @URLFor">
		<cfargument name="onlyPath" type="boolean" required="false" default="#application.wheels.functions.linkTo.onlyPath#" hint="See documentation for @URLFor">
		<cfargument name="host" type="string" required="false" default="#application.wheels.functions.linkTo.host#" hint="See documentation for @URLFor">
		<cfargument name="protocol" type="string" required="false" default="#application.wheels.functions.linkTo.protocol#" hint="See documentation for @URLFor">
		<cfargument name="port" type="numeric" required="false" default="#application.wheels.functions.linkTo.port#" hint="See documentation for @URLFor">
		<cfargument name="onSuccess" type="string" required="false" hint="Function to execute when the ajax request succeeds" />
		<cfargument name="onError" type="string" required="false" hint="Function to execute when the ajax request fails" />
		<cfargument name="onComplete" type="string" required="false" hint="Function to execute when the ajax request is complete (runs on error and success)" />
		<cfargument name="onBeforeSend" type="string" required="false" hint="Function to execute before the ajax request is sent." />

		<cfscript>
			var loc = {};
			$insertDefaults(name="linkTo", reserved="href", input=arguments);

			arguments.href = URLFor(argumentCollection=arguments);
			arguments.href = Replace(arguments.href, "&", "&amp;", "all"); // make sure we return XHMTL compliant code

			// Setup the onClick attribute
			arguments.onClick = $ajaxSetup(argumentCollection=arguments);

			if (Len(arguments.confirm)){
				arguments.onClick = "if (!confirm('#arguments.confirm#')) { return false; };" & arguments.onClick;
				/* arguments.onclick = $addToJavaScriptAttribute(name="onclick", content=loc.onclick, attributes=arguments); */
			}

			if (!Len(arguments.text))
				arguments.text = arguments.href;
			loc.skip = "text,confirm,route,controller,action,key,params,anchor,onlyPath,host,protocol,port,onSuccess,onError,onComplete,onBeforeSend";
			if (Len(arguments.route))
				loc.skip = ListAppend(loc.skip, $routeVariables(argumentCollection=arguments)); // variables passed in as route arguments should not be added to the html element

			loc.returnValue = $element(name="a", skip=loc.skip, content=arguments.text, attributes=arguments);
		</cfscript>
		<cfreturn loc.returnValue>
	</cffunction>

	<cffunction name="remoteButtonTo" access="public" returnType="string" output="false"
		hint="Creates an AJAX button to another page in your application.">
		<cfargument name="text" type="string" required="false" hint="The text content of the button.">
		<cfargument name="confirm" type="string" required="false" hint="See documentation for @linkTo.">
		<cfargument name="image" type="string" required="false" hint="If you want to use an image for the button pass in the link to it here (relative from the `images` folder).">
		<cfargument name="disable" type="any" required="false" hint="Pass in `true` if you want the button to be disabled when clicked (can help prevent multiple clicks), or pass in a string if you want the button disabled and the text on the button updated (to ""please wait..."", for example).">
		<cfargument name="route" type="string" required="false" default="" hint="See documentation for @URLFor.">
		<cfargument name="controller" type="string" required="false" default="" hint="See documentation for @URLFor.">
		<cfargument name="action" type="string" required="false" default="" hint="See documentation for @URLFor.">
		<cfargument name="key" type="any" required="false" default="" hint="See documentation for @URLFor.">
		<cfargument name="params" type="string" required="false" default="" hint="See documentation for @URLFor.">
		<cfargument name="anchor" type="string" required="false" default="" hint="See documentation for @URLFor.">
		<cfargument name="onlyPath" type="boolean" required="false" hint="See documentation for @URLFor.">
		<cfargument name="host" type="string" required="false" hint="See documentation for @URLFor.">
		<cfargument name="protocol" type="string" required="false" hint="See documentation for @URLFor.">
		<cfargument name="port" type="numeric" required="false" hint="See documentation for @URLFor.">		
		<cfargument name="onSuccess" type="string" required="false" hint="Function to execute when the ajax request succeeds" />
		<cfargument name="onError" type="string" required="false" hint="Function to execute when the ajax request fails" />
		<cfargument name="onComplete" type="string" required="false" hint="Function to execute when the ajax request is complete (runs on error and success)" />
		<cfargument name="onBeforeSend" type="string" required="false" hint="Function to execute before the ajax request is sent." />
		
		<cfscript>
			var loc = {};
			$insertDefaults(name="buttonTo", input=arguments);
			
			// sets a flag to indicate whether we use get or post on this form, used when obfuscating params
			arguments.method = "post"
			request.wheels.currentFormMethod = arguments.method;
				
			arguments.action = URLFor(argumentCollection=arguments);
			arguments.action = Replace(arguments.action, "&", "&amp;", "all");
			
			if (Len(arguments.confirm))
				arguments.onClick = "if (!confirm('#arguments.confirm#')) { return false; };" & arguments.onClick;
				
			loc.content = submitTag(value=arguments.text, image=arguments.image, disable=arguments.disable);
			
			loc.skip = "confirm,disable,image,route,controller,key,params,anchor,onlyPath,host,protocol,port,onSuccess,onError,onComplete,onBeforeSend,onClick";
			if (Len(arguments.route))
				loc.skip = ListAppend(loc.skip, $routeVariables(argumentCollection=arguments)); // variables passed in as route arguments should not be added to the html element
			if (ListFind(loc.skip, "action"))
				loc.skip = ListDeleteAt(loc.skip, ListFind(loc.skip, "action")); // need to re-add action here even if it was removed due to being a route variable above
			
			// Setup the onSubmit attribute
			arguments.onSubmit = $ajaxSetup(argumentCollection=arguments);
				
			loc.returnValue = $element(name="form", skip=loc.skip, content=loc.content, attributes=arguments);
		</cfscript>
		<cfreturn loc.returnValue>
	</cffunction>

	<cffunction name="$ajaxSetup" access="public" returnType="string" output="false">

		<cfset var loc = {}>

		<!--- setup the .ajax method --->
		<cfset loc.returnValue = "$.ajax({ dataType: 'script'">

		<!--- If this is a form, use the serialize method for the data and the action argument --->
		<cfif NOT StructKeyExists(arguments, "href")>
			<cfset loc.returnValue = loc.returnValue & ", type: '#arguments.method#', url: '#arguments.action#', data: $(this).serialize()">
		<cfelse>
			<cfset loc.returnValue = loc.returnValue & ", url: '#arguments.href#'">
		</cfif>

		<!--- add only the passed in callbacks --->
		<cfif StructKeyExists(arguments, "onSuccess")>
			<cfset loc.returnValue = loc.returnValue & ", success: function(data, textStatus){#arguments.onSuccess#(data, textStatus);}">
		</cfif>
		<cfif StructKeyExists(arguments, "onError")>
			<cfset loc.returnValue = loc.returnValue & ", error: function(XMLHttpRequest, textStatus, errorThrown){#arguments.onError#(XMLHttpRequest, textStatus, errorThrown);}">
		</cfif>
		<cfif StructKeyExists(arguments, "onBeforeSend")>
			<cfset loc.returnValue = loc.returnValue & ", beforeSend: function(XMLHttpRequest){#arguments.onBeforeSend#(XMLHttpRequest);}">
		</cfif>
		<cfif StructKeyExists(arguments, "onComplete")>
			<cfset loc.returnValue = loc.returnValue & ", complete: function(XMLHttpRequest, textStatus){#arguments.onComplete#(XMLHttpRequest, textStatus);}">
		</cfif>

		<!--- Close the line --->
		<cfset loc.returnValue = loc.returnValue & "}); return false;">

		<cfreturn loc.returnValue />
	</cffunction>

	<!--- Overwrite to the $includeFile function, a simple remove of the SpanExcluding in the loc.fileName variable --->
	<cffunction name="$includeFile" returntype="string" access="public" output="false">
		<cfargument name="$name" type="any" required="true">
		<cfargument name="$type" type="string" required="true">
		<cfscript>
			var loc = {};
			loc.include = application.wheels.viewPath;
			loc.fileName = Reverse(ListFirst(Reverse(arguments.$name), "/")) & ".cfm"; // extracts the file part of the path and replace ending ".cfm"
			if (arguments.$type == "partial")
				loc.fileName = Replace("_" & loc.fileName, "__", "_", "one"); // replaces leading "_" when the file is a partial
			loc.folderName = Reverse(ListRest(Reverse(arguments.$name), "/"));
			if (Left(arguments.$name, 1) == "/")
				loc.include = loc.include & loc.folderName & "/" & loc.fileName; // Include a file in a sub folder to views
			else if (arguments.$name Contains "/")
				loc.include = loc.include & "/" & variables.params.controller & "/" & loc.folderName & "/" & loc.fileName; // Include a file in a sub folder of the current controller
			else
				loc.include = loc.include & "/" & variables.params.controller & "/" & loc.fileName; // Include a file in the current controller's view folder
			arguments.$template = loc.include;
			if (arguments.$type == "partial")
			{
				if (StructKeyExists(arguments, "query") && IsQuery(arguments.query))
				{
					loc.query = arguments.query;
					StructDelete(arguments, "query");
					loc.returnValue = "";
					loc.iEnd = loc.query.recordCount;
					if (Len(arguments.$group))
					{
						// we want to group based on a column so loop through the rows until we find, this will break if the query is not ordered by the grouped column
						loc.tempSpacer = "}|{";
						loc.groupValue = "";
						loc.groupQueryCount = 1;
						arguments.group = QueryNew(loc.query.columnList);
						if (application.wheels.showErrorInformation && !ListFindNoCase(loc.query.columnList, arguments.$group))
							$throw(type="Wheels.GroupColumnNotFound", message="Wheels couldn't find a query column with the name of `#arguments.$group#`.", extendedInfo="Make sure your finder method has the column `#arguments.$group#` specified in the `select` argument. If the column does not exist, create it.");
						for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
						{
							if (loc.i == 1)
							{
								loc.groupValue = loc.query[arguments.$group][loc.i];
							}
							else if (loc.groupValue != loc.query[arguments.$group][loc.i])
							{
								// we have a different group for this row so output what we have
								loc.returnValue = loc.returnValue & $includeAndReturnOutput(argumentCollection=arguments);
								if (StructKeyExists(arguments, "$spacer"))
									loc.returnValue = loc.returnValue & loc.tempSpacer;
								loc.groupValue = loc.query[arguments.$group][loc.i];
								arguments.group = QueryNew(loc.query.columnList);
								loc.groupQueryCount = 1;
							}
							loc.dump = QueryAddRow(arguments.group);
							loc.jEnd = ListLen(loc.query.columnList);
							for (loc.j=1; loc.j <= loc.jEnd; loc.j++)
							{
								loc.property = ListGetAt(loc.query.columnList, loc.j);
								arguments[loc.property] = loc.query[loc.property][loc.i];
								loc.dump = QuerySetCell(arguments.group, loc.property, loc.query[loc.property][loc.i], loc.groupQueryCount);
							}
							arguments.current = (loc.i+1) - arguments.group.recordCount;
							loc.groupQueryCount++;
						}
						// if we have anything left at the end we need to render it too
						if (arguments.group.RecordCount > 0)
						{
							loc.returnValue = loc.returnValue & $includeAndReturnOutput(argumentCollection=arguments);
							if (StructKeyExists(arguments, "$spacer") && loc.i < loc.iEnd)
								loc.returnValue = loc.returnValue & loc.tempSpacer;
						}
						// now remove the last temp spacer and replace the tempSpacer with $spacer
						if (Right(loc.returnValue, 3) == loc.tempSpacer)
							loc.returnValue = Left(loc.returnValue, Len(loc.returnValue) - 3);
						loc.returnValue = Replace(loc.returnValue, loc.tempSpacer, arguments.$spacer, "all");
					}
					else
					{
						for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
						{
							arguments.current = loc.i;
							loc.jEnd = ListLen(loc.query.columnList);
							for (loc.j=1; loc.j <= loc.jEnd; loc.j++)
							{
								loc.property = ListGetAt(loc.query.columnList, loc.j);
								arguments[loc.property] = loc.query[loc.property][loc.i];
							}
							loc.returnValue = loc.returnValue & $includeAndReturnOutput(argumentCollection=arguments);
							if (StructKeyExists(arguments, "$spacer") && loc.i < loc.iEnd)
								loc.returnValue = loc.returnValue & arguments.$spacer;
						}
					}
				}
				else if (StructKeyExists(arguments, "object") && IsObject(arguments.object))
				{
					loc.object = arguments.object;
					StructDelete(arguments, "object");
					StructAppend(arguments, loc.object.properties(), false);
				}
				else if (StructKeyExists(arguments, "objects") && IsArray(arguments.objects))
				{
					loc.originalArguments = Duplicate(arguments);
					loc.array = arguments.objects;
					StructDelete(arguments, "objects");
					loc.returnValue = "";
					loc.iEnd = ArrayLen(loc.array);
					for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
					{
						arguments.current = loc.i;
						loc.properties = loc.array[loc.i].properties();
						for (loc.key in loc.originalArguments)
							if (StructKeyExists(loc.properties, loc.key))
								StructDelete(loc.properties, loc.key);
						StructAppend(arguments, loc.properties, true);
						loc.returnValue = loc.returnValue & $includeAndReturnOutput(argumentCollection=arguments);
						if (StructKeyExists(arguments, "$spacer") && loc.i < loc.iEnd)
							loc.returnValue = loc.returnValue & arguments.$spacer;
					}
				}
			}
			if (!StructKeyExists(loc, "returnValue"))
				loc.returnValue = $includeAndReturnOutput(argumentCollection=arguments);
		</cfscript>
		<cfreturn loc.returnValue>
	</cffunction>

</cfcomponent>