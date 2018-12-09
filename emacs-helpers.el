;; Useful Emacs expressions to help sort through script output
(progn (goto-char 0)
       (replace-regexp "^Getting .*$"               "")
       (goto-char 0)
       (replace-regexp "^.*--:--:--.*$"             "")
       (goto-char 0)
       (replace-regexp "Searching for '.*' on metal-archives.com" "")
       (goto-char 0)
       (replace-regexp "Error fetching '[^']*'" "")
       (goto-char 0)
       (replace-regexp "^Error: No matches for .*$" "")
       (goto-char 0)
       (replace-regexp "^.*Xferd.*$"                "")
       (goto-char 0)
       (replace-regexp "^.* Dload .*$"              "")
       (goto-char 0)
       (replace-regexp "Error: No results for '.*' from '[^']*'" "")

       (goto-char 0)
       (replace-string "curl: (16) Error in the HTTP2 framing layer" "")

       (goto-char 0)
       (replace-string "

" "")
       (goto-char 0)
       (replace-string "

" "")
       (goto-char 0)
       (replace-string "

" "")
       (goto-char 0)
       (replace-string "

" "")
       (goto-char 0)
       (replace-string "

" "")
       (goto-char 0)
       (replace-string "

" "")
       (goto-char 0)
       (replace-string "

" ""))
