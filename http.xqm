(:
 : Copyright (c)2006 Elsevier, Inc.
 : Copyright (c)2020 Omar Siam
 : Copyright (c)2020 ACDH-CH ÖAW
 :
 : Licensed under the Apache License, Version 2.0 (the "License");
 : you may not use this file except in compliance with the License.
 : You may obtain a copy of the License at
 :
 : http://www.apache.org/licenses/LICENSE-2.0
 :
 : Unless required by applicable law or agreed to in writing, software
 : distributed under the License is distributed on an "AS IS" BASIS,
 : WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 : See the License for the specific language governing permissions and
 : limitations under the License.
 :
 : The use of the Apache License does not indicate that this project is
 : affiliated with the Apache Software Foundation.
 :)

module namespace http="xqdoc/http";

import module namespace xqdoc-display="http://www.xqdoc.org/1.0/display";

(:~ 
 :  This main module controls the presentation of the home page for
 :  xqDoc.  The home page will list all of the library and main modules
 :  contained in the 'xqDoc' collection.
 :  The mainline function invokes only the
 :  method to generate the HTML for the xqDoc home page.  A parameter of type 
 :  xs:boolean is passed to indicate whether links on the page should be constructed 
 :  to static HTML pages (for off-line viewing) or to XQuery scripts for dynamic
 :  real-time viewing.
 : 
 :  @author Darin McBeath
 :  @since June 9, 2006
 :  @version 1.3
 :)
declare
  %rest:path("/xqdoc/default.xqy")
  %rest:GET
  %rest:produces("text/html")
  %output:method("html")
function http:get-default-html() {
  xqdoc-display:get-default-html(false())
};

(:~ 
 :  It forwards xqdoc as a file and the path xqdoc/ for convenience
 :  to default.html
 :
 :  @author Omar Siam
 :  @since March 8, 2020
 :  @version 1.0
 :)
declare
  %rest:path("/xqdoc")
  %rest:GET
  %rest:produces("text/html")
  %output:method("html")
function http:forward-default-html-static() {
    <rest:response>
      <http:response xmlns:http="http://expath.org/ns/http-client" status="302">
        <http:header name="Location" value="/xqdoc/default.html"/>
      </http:response>
    </rest:response>
};

(:~ 
 :  This main module controls the presentation of the home page for
 :  xqDoc as above. It generates links that are resolved like static html
 :  files using RestXQ.
 :  It forwards xqdoc as a file to the path xqdoc/ for convenience.
 :
 :  @author Omar Siam
 :  @since March 8, 2020
 :  @version 1.0
 :)
declare
  %rest:path("/xqdoc/default.html")
  %rest:GET
  %rest:produces("text/html")
  %output:method("html")
function http:get-default-html-static() {
    xqdoc-display:get-default-html(true())
};

(:~ 
 :  This main module controls the presentation of the xqDoc information
 :  for the module. 
 :  The mainline function invokes only the
 :  method to retrieve the xqDoc information for the specified 'module'. The 'module' 
 :  parameter is extracted from the query-string.  A parameter of type xs:boolean 
 :  is passed to indicate whether links on the page should be constructed 
 :  to static HTML pages (for off-line viewing) or to XQuery scripts for dynamic
 :  real-time viewing.
 : 
 :  @author Darin McBeath
 :  @since June 9, 2006
 :  @version 1.3
 :)
declare
  %rest:path("/xqdoc/get-module.xqy")
  %rest:GET
  %rest:produces("text/html")
  %rest:query-param("module", "{$module}")
  %output:method("html")
function http:get-module-html($module) {
  xqdoc-display:get-module-html($module, false()) 
};

(:~ 
 :  This main module controls the presentation of the xqDoc information
 :  for the module as above.
 :  Info in the static html filename is used here as part of the rest path. 
 : 
 :  @author Omar Siam
 :  @since March 8, 2020
 :  @version 1.0
 :)
declare
  %rest:path("/xqdoc/xqdoc-file-{$index=[0-9]+}.html")
  %rest:GET
  %rest:produces("text/html")
  %output:method("html")
function http:get-module-html-static($index as xs:integer) {
  xqdoc-display:get-module-html(xqdoc-display:get-module-uris()[$index], true()) 
};

(:~ 
 :  This main module controls the presentation of the code for either
 :  an entire mdoule or a particlur function within a module. 
 :  The mainline function invokes only the
 :  method to retrieve the source code.  The 'module' and 'function' parameters
 :  are extracted from the query-string.  If only a 'module' is specified, then
 :  the source code for the entire module will be returned.  If both a 'module'
 :  and a 'function' are specified, only the source code for the specified function
 :  within the module will be returned. A parameter of type xs:boolean 
 :  is passed to indicate whether links on the page should be constructed 
 :  to static HTML pages (for off-line viewing) or to XQuery scripts for dynamic
 :  real-time viewing.
 : 
 :  @author Darin McBeath
 :  @since June 9, 2006
 :  @version 1.3
 :)
declare
  %rest:path("/xqdoc/get-code.xqy")
  %rest:GET
  %rest:produces("text/html")
  %rest:query-param("module", "{$module}")
  %rest:query-param("function", "{$function}")
  %output:method("html")
function http:get-code-html($module, $function) {
  xqdoc-display:get-code-html($module, $function, false())
};

(:~ 
 :  Create the cache collection using RestXQ
 :
 :  @author Omar Siam
 :  @since March 3, 2020
 :)
declare
  %rest:path("/xqdoc/create-cache.xqy")
  %rest:GET
  %rest:produces("text/plain")
  %output:method("text")
  %updating
function http:create-cache() {
  db:create($xqdoc-display:XQDOC_COLLECTION),
  update:output("done")
};

(:~ 
 :  Add xqdoc XMLs to the cache collection using RestXQ
 :
 :  @param $target The root of the directory tree to traverse to find XQuery code. Uses the directory containing http.xqm as default.
 :  @author Omar Siam
 :  @since March 3, 2020
 :)
declare
  %rest:path("/xqdoc/cache-xqdocs.xqy")
  %rest:GET
  %rest:produces("text/plain")
  %rest:query-param("target", "{$target}")
  %output:method("text")
  %updating
function http:cache-xqdocs($target as xs:string?) {
  xqdoc-display:cache-xqdocs(if ($target) then $target else file:parent(static-base-uri())),
  update:output("done")
};

(:~ 
 :  Drop the cache collection using RestXQ
 :
 :  @author Omar Siam
 :  @since March 3, 2020
 :)
declare
  %rest:path("/xqdoc/drop-cache.xqy")
  %rest:GET
  %rest:produces("text/plain")
  %output:method("text")
  %updating
function http:drop-cache() {
  db:drop($xqdoc-display:XQDOC_COLLECTION),
  update:output("done")
};
