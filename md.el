;;; md-mode --- a markdown mode with extras
;;; Commentary:
;;; be there for me
;;; Code:

(require 'polymode)
(require 'poly-lock)
(require 'markdown-mode)

(defgroup md nil
	"Md's settings."
	:group 'outlines
	:prefix "md-"
	:link '(url-link :tag "Homepage" "https://github.com/chee/md.el"))

(defgroup md-faces nil
	"Morgue faces."
	:group 'md
	:group 'faces
	:link '(url-link :tag "Homepage" "https://chee.party/notebook/docfiles/emacs/packages/md.html"))

(defcustom md-document-root "~/md"
  "The root directory for .md files."
  :type 'string
  :group 'md)

(define-innermode polymd-root-innermode
  :mode nil
  :fallback-mode 'host
  :head-mode 'host
  :tail-mode 'host)

(define-innermode polymd-yaml-frontmatter-innermode polymd-root-innermode
  :mode 'yaml-mode
  :head-matcher (pm-make-text-property-matcher 'markdown-yaml-metadata-start)
  :tail-matcher (pm-make-text-property-matcher 'markdown-yaml-metadata-end)
  :allow-nested nil)

(define-innermode polymd-json-frontmatter-innermode polymd-root-innermode
  :mode 'json-ts-mode
  :head-matcher "^---json$"
  :tail-matcher "^---$"
  :allow-nested nil)

(define-innermode polymd-js-frontmatter-innermode polymd-root-innermode
  :mode 'tsx-ts-mode
  :head-matcher "^---js$"
  :tail-matcher "^---$"
  :allow-nested nil)

(define-auto-innermode polymd-fenced-code-innermode polymd-root-innermode
  :head-matcher (cons "^[ \t]*\\(```[ \t]*{?[[:alpha:].=].*\n\\)" 1)
  :tail-matcher (cons "^[ \t]*\\(```\\)[ \t]*$" 1)
  :mode-matcher (cons "```[ \t]*{?[.=]?\\(?:lang *= *\\)?\\([^ \t\n;=,}]+\\)" 1))

(define-innermode polymd-css-innermode polymd-root-innermode
  "CSS <style/> block."
  :mode 'css-ts-mode
  :head-matcher "<style>"
  :tail-matcher "</style>"
  :allow-nested nil)

(define-innermode polymd-js-innermode polymd-root-innermode
  "JS <script/> block."
  :mode 'tsx-ts-mode
  :head-matcher "<script>"
  :tail-matcher "</script>"
  :allow-nested nil)

;;;###autoload  (autoload 'md-mode "md")
(define-derived-mode md-mode markdown-mode "Md")

(define-hostmode polymd-hostmode :mode 'md-mode)

;;;###autoload  (autoload 'polymd-mode "md")
(define-polymode polymd-mode
  :hostmode 'polymd-hostmode
  :innermodes '(polymd-fenced-code-innermode
                 polymd-yaml-frontmatter-innermode
                 polymd-json-frontmatter-innermode
                 polymd-js-frontmatter-innermode
                 polymd-css-innermode
                 polymd-js-innermode))

(bind-key "s-b" 'markdown-insert-bold 'md-mode-map)
(bind-key "s-i" 'markdown-insert-italic 'md-mode-map)
(bind-key "s-C" 'markdown-insert-code 'md-mode-map)
(bind-key "s-i" 'markdown-insert-italic 'md-mode-map)
(bind-key "s-i" 'markdown-insert-italic 'md-mode-map)

(setq markdown-enable-wiki-links t)
;; todo this should be customizable
(setq markdown-wiki-link-alias-first nil)

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.md\\'" . md-mode))
;;;###autoload
(add-to-list 'auto-mode-alist '("\\.md\\'" . polymd-mode))

(provide 'md)
;;; md ends here
