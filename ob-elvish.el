;;; ob-elvish.el --- Org Babel functions for Elvish

;; Copyright (C) 2018  Diego Zamboni

;; Permission is hereby granted, free of charge, to any person obtaining a copy
;; of this software and associated documentation files (the "Software"), to deal
;; in the Software without restriction, including without limitation the rights
;; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
;; copies of the Software, and to permit persons to whom the Software is
;; furnished to do so, subject to the following conditions:
;; The above copyright notice and this permission notice shall be included in
;; all copies or substantial portions of the Software.

;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
;; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
;; THE SOFTWARE.

;; Author: Nick Anderson <nick@cmdln.org>
;; Keywords: tools, convenience
;; Package-Version: 20180102.1012
;; URL: https://github.com/nickanderson/ob-cfengine3
;; Version: 0.0.2

;;; Commentary:
;; Execute CFEngine 3 policy inside org-mode src blocks.

;;; Code:

(defvar ob-elvish-command "elvish"
  "Name of command to use for executing Elvish code.")

(defvar ob-elvish-command-options ""
  "Option string that should be passed to elvish.")

(defconst ob-elvish-header-args-elvish
  '(
    (log . :any)
    (use . :any)
    )
  "Elvish-specific header arguments.")

(defun org-babel-execute:elvish (body params)
  "Execute a block of Elvish code.
This function is called by `org-babel-execute-src-block'.

  A temporary file is constructed containing the BODY of the src
  block. `ob-elvish-command' is used to execute the
  temporary file."

  (let* ((temporary-file-directory ".")
         (log (cdr (assoc :log params)))
	 (use (cdr (assoc :use params)))
         (tempfile (make-temp-file "elvish-")))
    (with-temp-file tempfile
      (when use (insert (mapconcat
			 (apply-partially 'concat "use ")
			 (split-string use ",") "\n")))
      (insert "\n")
      (insert body))
    (unwind-protect
        (shell-command-to-string
         (concat
          ob-elvish-command
          " "
          (when log (concat "--log " log ))
          " "
          ob-elvish-command-options
          " "
          (format "%s" (shell-quote-argument tempfile))))
      (delete-file tempfile))))

(add-to-list 'org-src-lang-modes '("elvish" . elvish))
(add-to-list 'org-babel-tangle-lang-exts '("elvish" . "elv"))

(provide 'ob-elvish)
;;; ob-cfengine3.el ends here
