;;; prelude-go.el --- Emacs Prelude: Go programming support.
;;
;; Author: Doug MacEachern
;; Version: 1.0.0
;; Keywords: convenience go

;; This file is not part of GNU Emacs.

;;; Commentary:

;; Prelude configuration for Go

;;; License:

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Code:

(require 'prelude-programming)

(prelude-require-packages '(go-mode
                            company-go
                            go-eldoc
                            go-projectile
                            gotest))

(require 'go-projectile)

;; go 文件自动加载go-mode
(add-to-list 'auto-mode-alist '("\\.go\\'" . go-mode))

(setq company-tooltip-limit 20)                      ; bigger popup window
(setq company-idle-delay .3)                         ; decrease delay before autocompletion popup shows
(setq company-echo-delay 0)                          ; remove annoying blinking
(setq company-begin-commands '(self-insert-command)) ; start autocompletion only after typing

;; Ignore go test -c output files
(add-to-list 'completion-ignored-extensions ".test")

(define-key 'help-command (kbd "G") 'godoc)

(eval-after-load 'go-mode
  '(progn
     (defun prelude-go-mode-defaults ()
        (when (memq window-system '(mac ns x))
         (dolist (var '("GOPATH" "GO15VENDOREXPERIMENT"))
           (unless (getenv var)
             (exec-path-from-shell-copy-env var))))
       ;; Go orcale
       (load-file "$GOPATH/src/golang.org/x/tools/cmd/oracle/oracle.el")

       ;; Customize compile command to run go build
       (if (not (string-match "go" compile-command))
           (set (make-local-variable 'compile-command)
                            "go generate && go build -v && go test -v && go vet"))

       ;; Add to default go-mode key bindings
       (let ((map go-mode-map))
         (local-set-key (kbd "M-.") 'godef-jump)
         (local-set-key (kbd "C-c ,") 'pop-tag-mark)
         (define-key map (kbd "C-c a") 'go-test-current-project) ;; current package, really
         (define-key map (kbd "C-c m") 'go-test-current-file)
         (define-key map (kbd "C-c .") 'go-test-current-test)
         (define-key map (kbd "C-c b") 'go-run)
         (define-key map (kbd "C-h f") 'godoc-at-point))

       ;; Prefer goimports to gofmt if installed
       (let ((goimports (executable-find "goimports")))
         (when goimports
           (setq gofmt-command goimports)))

       ;; gofmt on save
       (add-hook 'before-save-hook 'gofmt-before-save nil t)

       ;; stop whitespace being highlighted
       (whitespace-toggle-options '(tabs))

       ;; Company mode settings
       (set (make-local-variable 'company-backends) '(company-go))

       ;; El-doc for Go
       (go-eldoc-setup)

       ;; CamelCase aware editing operations
       (subword-mode +1))

     (setq prelude-go-mode-hook 'prelude-go-mode-defaults)

     (add-hook 'go-mode-hook (lambda ()
                               (run-hooks 'prelude-go-mode-hook)))))

(provide 'prelude-go)
;;; prelude-go.el ends here
