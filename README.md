    --no-code                     Do not include source code in the documentation.
-m, --mode                        Define how HTML pages are generated.

          [live-nav]              (Default) Generated docs do not included baked HTML
                                  navigation. Instead a single `nav.json` file is
                                  created and the appropriate navigation is generated
                                  client-side by parsing that and building HTML.
                                        This dramatically reduces the generated size of
                                  the HTML since a large fraction of each static page
                                  is just redundant navigation links.
                                        In this mode, the browser will do a XHR for
                                  nav.json which means that to preview docs locallly,
                                  you will need to enable requesting file:// links in
                                  your browser or run a little local server like
                                  `python -m  SimpleHTTPServer`.
          [static]                Generates completely static HTML containing
                                  everything you need to browse the docs. The only
                                  client side behavior is trivial stuff like syntax
                                  highlighting code, and the find-as-you-type search
                                  box.

    --generate-app-cache          Generates the App Cache manifest file, enabling
                                  offline doc viewing.

    --omit-generation-time        Omits generation timestamp from output.
-v, --verbose                     Print verbose information during generation.
    --include-api                 Include the used API libraries in the generated
                                  documentation. If the --link-api option is used,
                                  this option is ignored.

    --link-api                    Link to the online language API in the generated
                                  documentation. The option overrides inclusion
                                  through --include-api or --include-lib.

    --[no-]show-private           Document private types and members.
    --inherit-from-object         Show members inherited from Object.
    --enable-diagnostic-colors
    --out                         Generates files into directory specified. If
                                  omitted the files are generated into ./docs/

    --include-lib                 Use this option to explicitly specify which
                                  libraries to include in the documentation. If
                                  omitted, all used libraries are included by
                                  default. Specify a comma-separated list of
                                  library names, or call this option multiple times.

    --exclude-lib                 Use this option to explicitly specify which
                                  libraries to exclude from the documentation. If
                                  omitted, no libraries are excluded. Specify a
                                  comma-separated list of library names, or call
                                  this option multiple times.

    --package-root                Sets the package directory to the specified directory.
                                  If omitted the package directory is the closest packages directory to the entrypoint.

    --library-root                Sets the library root directory to the specified directory.
    --pkg                         Deprecated: same as --package-root.
