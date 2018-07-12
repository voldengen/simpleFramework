No Layout
<br/><br/>
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