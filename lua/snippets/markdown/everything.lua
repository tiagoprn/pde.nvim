local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt


-- Includes octopress (http://octopress.org/) snippets
-- The suffix `c` stands for "Clipboard".

local snippet = {
  markdown = {
    new_snippet("[", fmt([=[
	[${1:text}](https://${2:address})
]=], { i(1, "text"), i(2, "address") })),

        new_snippet("[*", fmt([=[
	[${1:link}](${2:`@*`})
]=], { i(1, "link"), i(2, "`@*`") })),

        new_snippet("[c", fmt([=[
	[${1:link}](${2:`@+`})
]=], { i(1, "link"), i(2, "`@+`") })),

        new_snippet("["", fmt([=[
	[${1:text}](https://${2:address} "${3:title}")
]=], { i(1, "text"), i(2, "address"), i(3, "title") })),

        new_snippet("["*", fmt([=[
	[${1:link}](${2:`@*`} "${3:title}")
]=], { i(1, "link"), i(2, "`@*`"), i(3, "title") })),

        new_snippet("["c", fmt([=[
	[${1:link}](${2:`@+`} "${3:title}")
]=], { i(1, "link"), i(2, "`@+`"), i(3, "title") })),

        new_snippet("[:", fmt([=[
	[${1:id}]: https://${2:url}
]=], { i(1, "id"), i(2, "url") })),

        new_snippet("[:*", fmt([=[
	[${1:id}]: ${2:`@*`}
]=], { i(1, "id"), i(2, "`@*`") })),

        new_snippet("[:c", fmt([=[
	[${1:id}]: ${2:`@+`}
]=], { i(1, "id"), i(2, "`@+`") })),

        new_snippet("[:"", fmt([=[
	[${1:id}]: https://${2:url} "${3:title}"
]=], { i(1, "id"), i(2, "url"), i(3, "title") })),

        new_snippet("[:"*", fmt([=[
	[${1:id}]: ${2:`@*`} "${3:title}"
]=], { i(1, "id"), i(2, "`@*`"), i(3, "title") })),

        new_snippet("[:"c", fmt([=[
	[${1:id}]: ${2:`@+`} "${3:title}"
]=], { i(1, "id"), i(2, "`@+`"), i(3, "title") })),

        new_snippet("![", fmt([=[
	![${1:alttext}](${2:/images/image.jpg})
]=], { i(1, "alttext"), i(2, "/images/image.jpg") })),

        new_snippet("![*", fmt([=[
	![${1:alt}](${2:`@*`})
]=], { i(1, "alt"), i(2, "`@*`") })),

        new_snippet("![c", fmt([=[
	![${1:alt}](${2:`@+`})
]=], { i(1, "alt"), i(2, "`@+`") })),

        new_snippet("!["", fmt([=[
	![${1:alttext}](${2:/images/image.jpg} "${3:title}")
]=], { i(1, "alttext"), i(2, "/images/image.jpg"), i(3, "title") })),

        new_snippet("!["*", fmt([=[
	![${1:alt}](${2:`@*`} "${3:title}")
]=], { i(1, "alt"), i(2, "`@*`"), i(3, "title") })),

        new_snippet("!["c", fmt([=[
	![${1:alt}](${2:`@+`} "${3:title}")
]=], { i(1, "alt"), i(2, "`@+`"), i(3, "title") })),

        new_snippet("![:", fmt([=[
	![${1:id}]: ${2:url}
]=], { i(1, "id"), i(2, "url") })),

        new_snippet("![:*", fmt([=[
	![${1:id}]: ${2:`@*`}
]=], { i(1, "id"), i(2, "`@*`") })),

        new_snippet("![:"", fmt([=[
	![${1:id}]: ${2:url} "${3:title}"
]=], { i(1, "id"), i(2, "url"), i(3, "title") })),

        new_snippet("![:"*", fmt([=[
	![${1:id}]: ${2:`@*`} "${3:title}"
]=], { i(1, "id"), i(2, "`@*`"), i(3, "title") })),

        new_snippet("![:"c", fmt([=[
	![${1:id}]: ${2:`@+`} "${3:title}"
]=], { i(1, "id"), i(2, "`@+`"), i(3, "title") })),

        new_snippet("<", fmt([=[
	<http://${1:url}>
]=], { i(1, "url") })),

        new_snippet("<*", t([=[
	<`@*`>
]=])),

        new_snippet("<c", t([=[
	<`@+`>
]=])),

        new_snippet("**", fmt([=[
	**${1:bold}**
]=], { i(1, "bold") })),

        new_snippet("__", fmt([=[
	__${1:bold}__
]=], { i(1, "bold") })),

        new_snippet("===", t([=[
	`repeat('=', strlen(getline(line('.') - 3)))`

	${0}
]=])),

        new_snippet("-", t([=[
	-   ${0}
]=])),

        new_snippet("---", t([=[
	`repeat('-', strlen(getline(line('.') - 3)))`

	${0}
]=])),

        new_snippet("blockquote", fmt([=[
	{% blockquote %}
	${0:quote}
	{% endblockquote %}
]=], { i(0, "quote") })),

        new_snippet("blockquote-author", fmt([=[
	{% blockquote ${1:author}, ${2:title} %}
	${0:quote}
	{% endblockquote %}
]=], { i(0, "quote"), i(1, "author"), i(2, "title") })),

        new_snippet("blockquote-link", fmt([=[
	{% blockquote ${1:author} ${2:URL} ${3:link_text} %}
	${0:quote}
	{% endblockquote %}
]=], { i(0, "quote"), i(1, "author"), i(2, "URL"), i(3, "link_text") })),

        new_snippet("```", fmt([=[
	\`\`\`${1}
	${0:${VISUAL}}
	\`\`\`
]=], { i(0, "${VISUAL") })),
        -- language
        new_snippet("```l", fmt([=[
	\`\`\`${1:language}
	${2:code}
	\`\`\`
]=], { i(1, "language"), i(2, "code") })),

        new_snippet("codeblock-short", fmt([=[
	{% codeblock %}
	${0:code_snippet}
	{% endcodeblock %}
]=], { i(0, "code_snippet") })),

        new_snippet("codeblock-full", fmt([=[
	{% codeblock ${1:title} lang:${2:language} ${3:URL} ${4:link_text} %}
	${0:code_snippet}
	{% endcodeblock %}
]=], { i(0, "code_snippet"), i(1, "title"), i(2, "language"), i(3, "URL"), i(4, "link_text") })),

        new_snippet("gist-full", fmt([=[
	{% gist ${1:gist_id} ${0:filename} %}
]=], { i(0, "filename"), i(1, "gist_id") })),

        new_snippet("gist-short", fmt([=[
	{% gist ${0:gist_id} %}
]=], { i(0, "gist_id") })),

        new_snippet("img", fmt([=[
	![${0:reference}](~/images/${1:image.jpg})
]=], { i(0, "reference"), i(1, "image.jpg") })),

        new_snippet("youtube", fmt([=[
	{% youtube ${0:video_id} %}
]=], { i(0, "video_id") })),

        new_snippet("tb", fmt([=[
	|  ${0:factors}      |    ${1:a}       |  ${2:b}   	|
	| ------------- |-------------  | ------- |
	|    ${3:f1}    |    Y          | N       |
	|    ${4:f2}    |    Y          | N       |
]=], { i(0, "factors"), i(1, "a"), i(2, "b"), i(3, "f1"), i(4, "f2") })),

        -- The quote should appear only once in the text. It is inherently part of it.
        -- See http://octopress.org/docs/plugins/pullquote/ for more info.
        new_snippet("pullquote", fmt([=[
	{% pullquote %}
	${1:text} {" ${2:quote} "} ${0:text}
	{% endpullquote %}
]=], { i(0, "text"), i(1, "text"), i(2, "quote") }))
  },
}

return snippet
