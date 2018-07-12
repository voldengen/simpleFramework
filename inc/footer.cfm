<cfif NOT isDefined("request.attributes.noLayout")>
	</div> <!-- main content -->

    <footer style="margin-top:2em;">
		<nav class="navbar navbar-default">
		    <ul class="nav navbar-nav">
		      <li>With URL Params:</li>
		      <li><a class="nav-item nav-link active" href="/">Home</a></li>
		      <li><a class="nav-item nav-link" href="/sample/?page=one">Sample One</a></li>
		      <li><a class="nav-item nav-link" href="/sample/?page=two">Sample Two</a></li>
		      <li><a class="nav-item nav-link disabled" href="/sample/?page=nolayout&noLayout">No Layout</a></li>
		    </ul>
		</nav>
		<nav class="navbar navbar-default">
		    <ul class="nav navbar-nav">
		      <li>With URL Rewrite:</li>
		      <li><a class="nav-item nav-link active" href="/">Home</a></li>
		      <li><a class="nav-item nav-link" href="/sample/one">Sample One</a></li>
		      <li><a class="nav-item nav-link" href="/sample/two">Sample Two</a></li>
		      <li><a class="nav-item nav-link disabled" href="/sample/nolayout">No Layout</a></li>
		    </ul>
		</nav>
	</footer>


    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
    <script>window.jQuery || document.write('<script src="../../assets/js/vendor/jquery.min.js"><\/script>')</script>
</body>
</html>
</cfif>