(setenv "ERGOEMACS_KEYBOARD_LAYOUT" "us")
;; (load-file "~/.emacs.d/ergoemacs/site-lisp/site-start.el")
;; (add-to-list 'load-path "~/.emacs.d/init")
;; (load-file "~/.emacs.d/cedet-1.1/common/cedet.el")

;; Add comment according major mode
;; (global-set-key (kbd "M-/") 'comment-dwim)
;; (add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(setq w32-pipe-read-delay 0)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)
(package-initialize)

(defun setup-package ()
  (package-initialize)

  (require 'cl)
  (defvar required-packages
    '(;;company
      ;;company-c-headers
      ;;company-irony
      ;; auto-complete
      ;; auto-complete-c-headers
      ;; flycheck
      ;; flycheck-irony
      ;; ggtags
	ergoemacs-mode
      yasnippet
      ;; sr-speedbar
      ;;iedit
      ;;elscreen
      ;;ecb
      ;;eide
      org
;;      color-theme
  ;;    afternoon-theme
      ;;color-theme-sanityinc-tomorrow
      ;;nyan-mode
    ;;  flymake-google-cpplint
      ;;google-c-style
      ;;arduino-mode
      ;;multiple-cursors
      ;;clean-aindent-mode
      ;;dtrt-indent
 ;;     ws-butler
))

  (defun packages-installed-p ()
    "Packages availability checking."
    (interactive)
    (loop for package in required-packages
          unless (package-installed-p package)
          do (return nil)
          finally (return t)))

  ;; Auto-install packages
  (unless (packages-installed-p)
    (message "%s" "Emacs is now refreshing it's package database...")
    (package-refresh-contents)
    (message "%s" " done.")
    (dolist (package required-packages)
      (unless (package-installed-p package)
        (package-install package))))
  (package-initialize))


(defun setup-global ()
  ;; Display file size/time in mode-line
  (setq display-time-24hr-format t) 
  (display-time-mode             t) 
  (size-indication-mode          t) 

  ;; Clipboard settings
  (setq x-select-enable-clipboard t)

  (setq use-dialog-box     nil) 
  (setq redisplay-dont-pause t) 

  ;; Disable backup/autosave files
  (setq make-backup-files        nil)
  (setq auto-save-default        nil)

  (setq use-dialog-box     nil) 
  (setq redisplay-dont-pause t)
  (setq ring-bell-function 'ignore)

  (setq speedbar-show-unknown-files t) ; show all files
  (setq sr-speedbar-right-side nil) ; put on left side
  (setq speedbar-use-images nil) ; use text for buttons
  ;; (setq sr-speedbar-auto-refresh nil)

  ;; Display the name of the current buffer in the title bar
  (setq frame-title-format "GNU Emacs: %b")

  ;; Show-paren-mode settings
  (show-paren-mode t) ;; {},[],()
  (setq show-paren-style 'expression) ;; {},[],()
  (toggle-truncate-lines)

  ;; IDO plugin
  (require 'ido)
  (ido-mode                      t)
  (icomplete-mode                t)
  (ido-everywhere                t)
  (setq ido-vitrual-buffers      t)
  (setq ido-enable-flex-matching t)
)

(defun setup-bookmark ()
  (require 'bookmark)
  (setq bookmark-save-flag t) ;; автоматически сохранять закладки в файл
  (when (file-exists-p (concat user-emacs-directory "bookmarks"))
    (bookmark-load bookmark-default-file t)) ;; попытаться найти и открыть файл с закладками
  (setq bookmark-default-file (concat user-emacs-directory "bookmarks")) ;; хранить закладки в файл bookmarks в .emacs.d
)

(defun setup-ggtags ()
  (require 'ggtags)
  (add-hook 'c-mode-common-hook
            (lambda ()
              (when (derived-mode-p 'c-mode 'c++-mode 'java-mode 'asm-mode)
                (ggtags-mode 1))))
  (ggtags-mode 1)
  (define-key ggtags-mode-map (kbd "C-c s") 'ggtags-find-other-symbol)
  (define-key ggtags-mode-map (kbd "C-c h") 'ggtags-view-tag-history)
  (define-key ggtags-mode-map (kbd "C-c r") 'ggtags-find-reference)
  (define-key ggtags-mode-map (kbd "C-c f") 'ggtags-find-file)
  (define-key ggtags-mode-map (kbd "C-c c") 'ggtags-create-tags)
  (define-key ggtags-mode-map (kbd "C-c u") 'ggtags-update-tags)
  (define-key ggtags-mode-map (kbd "M-,") 'pop-tag-mark)
;; (ggtags-mode)
)

(defun setup-company ()
  (require 'company)
  (add-hook 'after-init-hook 'global-company-mode)
  (require 'company-gtags)
  (require 'cedet)
  (require 'cc-mode)
  (require 'semantic)
  (require 'semantic/ia)
  (require 'semantic/bovine/gcc)
  (global-semanticdb-minor-mode 1)
  (global-semantic-idle-scheduler-mode 1)
  (global-semantic-stickyfunc-mode 1)
;;  (semantic-load-enable-code-helpers)
;;  (global-srecode-minor-mode 1)

  (semantic-mode 1)
  (add-to-list 'semantic-default-submodes 'global-semanticdb-minor-mode)
  (add-to-list 'semantic-default-submodes 'global-semantic-mru-bookmark-mode)
  (add-to-list 'semantic-default-submodes 'global-semantic-idle-scheduler-mode)
  (add-to-list 'semantic-default-submodes 'global-semantic-highlight-func-mode)
  (add-to-list 'semantic-default-submodes 'global-semantic-idle-completions-mode)
  (add-to-list 'semantic-default-submodes 'global-semantic-show-parser-state-mode)
  (add-to-list 'semantic-default-submodes 'global-semantic-idle-summary-mode)
  (semantic-mode   t)
  (global-ede-mode t)
  (require 'cc-mode)
  (require 'semantic)  
  (require 'ede/generic)
  (ede-enable-generic-projects)
  (require 'company-semantic)
  (require 'company-yasnippet)
  (global-semanticdb-minor-mode 1)
  (global-semantic-idle-scheduler-mode 1)
  (setq semantic-c-obey-conditional-section-parsing-flag nil)
  (require 'semantic/bovine/gcc)
  (global-semanticdb-minor-mode 1)
  (global-semantic-idle-scheduler-mode 1)
  ;; (semantic-add-system-include "C:/Users/avs/mlx/include" 'c++-mode)
  ;; (semantic-add-system-include "C:/Users/avs/mlx/log4cpp" 'c++-mode)
  ;; (semantic-add-system-include "C:/MinGW/include" 'c++-mode)
  ;; (semantic-add-system-include "/opt/mlx/include" 'c++-mode)
  ;; (semantic-add-system-include "/opt/mlx/log4cpp" 'c++-mode)
  (add-hook 'after-init-hook 'global-company-mode)
  (add-hook 'c-mode-common-hook 'hs-minor-mode)
  (eval-after-load 'company
    '(add-to-list 'company-backends 'company-irony))
  ;; (delete 'company-semantic company-backends)
  ;; (define-key c-mode-map  [(tab)] 'company-complete)
  ;; (define-key c++-mode-map  [(tab)] 'company-complete)
  ;; (define-key c-mode-map  [C-tab] 'company-complete)
  ;; (define-key c++-mode-map  [C-tab] 'company-complete)
  (semantic-mode 1)
  (global-ede-mode t)
  (add-to-list 'company-backends 'company-c-headers))

(defun setup-autocomplete ()
  (require 'auto-complete)
  (require 'auto-complete-config)
  (ac-config-default)
  (add-hook 'c++-mode-hook 'my:ac-c-header-init)
  (add-hook 'c-mode-hook 'my:ac-c-header-init)
  (defun my-c++-mode-hook ()
  (setq c-basic-offset 4)
  (c-set-offset 'substatement-open 0))
(add-hook 'c++-mode-hook 'my-c++-mode-hook)
  (semantic-mode 1)
  (defun my:add-semantic-to-autocomplete() 
    (add-to-list 'ac-sources 'ac-source-semantic)
    )
  (require 'auto-complete-c-headers)
  (add-to-list 'ac-sources 'ac-source-c-headers)
  (add-to-list 'achead:include-directories '"C:/Users/avs/mlx/include")
  (add-hook 'c-mode-common-hook 'my:add-semantic-to-autocomplete)
  (global-ede-mode 1)
  (global-semantic-idle-scheduler-mode 1))

(defun setup-irony ()
  (defun my:irony-enable()
    (interactive)
    (when (member major-mode 'irony-known-modes)
      (irony-mode 1)))
  (require 'ac-irony)

  (add-hook 'c++-mode-hook 'my:irony-enable)
  (add-hook 'c-mode-hook 'my:irony-enable)

  (add-hook 'c++-mode-hook 'irony-mode)
  (add-hook 'c-mode-hook 'irony-mode)
  (add-hook 'objc-mode-hook 'irony-mode)

  ;; (define-key irony-mode-map [C-tab] 'irony-completion-at-point-async)
  ;; (define-key irony-mode-map [C-tab] 'irony-completion-at-point-async)

  ;; (defun my-irony-mode-hook ()
  ;;   (define-key irony-mode-map [remap completion-at-point]
  ;;     'irony-completion-at-point-async)
  ;;   (define-key irony-mode-map [remap complete-symbol]
  ;;     'irony-completion-at-point))
 
 ;; (add-hook 'irony-mode-hook 'my-irony-mode-hook)
  ;; (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
)

(defun setup-flycheck ()
  (add-hook 'after-init-hook #'global-flycheck-mode)
)

(defun setup-keys ()
  ;; Easy transition between buffers: M-arrow-keys
  (if (equal nil (equal major-mode 'org-mode))
      (windmove-default-keybindings 'meta))

  ;; Commands:
  ;; Undo
  (global-set-key (kbd "M-z") 'undo)
  ;; Keyboard quit
  (global-set-key (kbd "M-q") 'keyboard-quit)

  ;; Add comment according major mode
  (global-set-key (kbd "M-/") 'comment-dwim)
  ;; Set mark command
  (global-set-key (kbd "M-m") 'set-mark-command)
  ;; Back to indentation
  (global-set-key (kbd "M-\\") 'back-to-indentation)

  ;; Add comment according major mode
  (global-set-key (kbd "M-/") 'comment-dwim)
  ;; Set mark command
  (global-set-key (kbd "M-m") 'set-mark-command)
  ;; Back to indentation
  (global-set-key (kbd "M-\\") 'back-to-indentation)

  (global-set-key (kbd "<f2>") 'bs-show)
  (global-set-key (kbd "<f3>") 'semantic-ia-fast-jump)
  (global-set-key (kbd "<f4>") 'semantic-analyze-proto-impl-toggle)
  (global-set-key (kbd "<f7>") 'kmacro-start-macro)
  (global-set-key (kbd "<f8>") 'kmacro-end-macro)
  (global-set-key (kbd "<f9>") 'kmacro-call-macro)
  ;; (global-set-key (kbd "<f11>") 'ido-dired)
  ;; (global-set-key (kbd "<f11>") 'book)
  (global-set-key (kbd "<f12>") 'sr-speedbar-toggle)
  )

(defun setup-yasnippet ()
  (require 'yasnippet)
  (yas-global-mode 1)
)

(defun setup-imenu ()
  ;; Imenu
  (require 'imenu)

  (setq imenu-auto-rescan      t) ;; автоматически обновлять список функций в буфере
  (setq imenu-use-popup-menu nil) ;; диалоги Imenu только в минибуфере
  (global-set-key (kbd "<f6>") 'imenu) ;; вызов Imenu на F6
)

(defun setup-other ()
  ;; Dired
  (require 'dired)
  (setq dired-recursive-deletes 'top)
  (require 'iedit)
  (global-set-key (kbd "C-c ;") 'iedit-mode)
)

(defun setup-org ()
  (require 'org)
  (global-set-key "\C-ca" 'org-agenda) ;; поределение клавиатурных комбинаций для внутренних
  (global-set-key "\C-cb" 'org-iswitchb) ;; подрежимов org-mode
  (global-set-key "\C-cl" 'org-store-link)
  (add-to-list 'auto-mode-alist '("\\.org$" . Org-mode)) ;; ассоциируем *.org файлы с org-mode
)

(defun setup-flymake-google ()
  (defun my:flymake-google-init () 
    (require 'flymake-google-cpplint)
    (custom-set-variables
     '(flymake-google-cpplint-command "cpplint"))
    (flymake-google-cpplint-load)
    )
  (add-hook 'c-mode-hook 'my:flymake-google-init)
  (add-hook 'c++-mode-hook 'my:flymake-google-init)

; start google-c-style with emacs
  (require 'google-c-style)
  (add-hook 'c-mode-common-hook 'google-set-c-style)
  (add-hook 'c-mode-common-hook 'google-make-newline-indent)
)


(setup-package)
(require 'ergoemacs-mode)
(setup-global)
(setup-bookmark)
;;(setup-other)
(setup-keys)
;;(nyan-mode)
;; (require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

(defun lines ()
  (interactive)
  (toggle-truncate-lines))


(defun activate ()
  (interactive)

  ;; (setup-package)
  ;; (setup-global)
  ;; (setup-bookmark)
  (setup-ggtags)
  (setup-company)
  ;; (setup-autocomplete)
  ;; (setup-irony)
  (setup-flycheck)
  ;; (setup-flycheck)
  ;; (setup-keys)
  (setup-yasnippet)
  ;; (setup-imenu)
  (setup-other)
  ;; (require 'multiple-cursors)
  ;; (global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
  ;; (global-set-key (kbd "C->") 'mc/mark-next-like-this)
  ;; (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
  ;; (global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
  ;; (require 'color-theme-mac-classic)
  ;; (color-theme-mac-classic)
  ;; (nyan-mode)
  ;; (ecb-activate)

  ;; Package: clean-aindent-mode
  ;; (require 'clean-aindent-mode)
  ;; (add-hook 'prog-mode-hook 'clean-aindent-mode)
  ;; (require 'dtrt-indent)
  ;; (dtrt-indent-mode 1)
  ;; (require 'ws-butler)
  ;; (add-hook 'prog-mode-hook 'ws-butler-mode)
  ;; (setup-org)
)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ecb-options-version "2.40")
 '(ergoemacs-ctl-c-or-ctl-x-delay 0.2)
 '(ergoemacs-handle-ctl-c-or-ctl-x (quote both))
 '(ergoemacs-ini-mode t)
 '(ergoemacs-keyboard-layout "us")
 '(ergoemacs-mode nil)
 '(ergoemacs-smart-paste nil)
 '(ergoemacs-theme "standard")
 '(ergoemacs-theme-options nil)
 '(ergoemacs-use-menus t)
 '(initial-scratch-message
   ";; This buffer is for notes you don't want to save, and for Lisp evaluation.
;; If you want to create a file, visit that file with C-x C-f,
;; then enter the text in that file's own buffer.

")
 '(org-CUA-compatible nil)
 '(org-replace-disputed-keys nil)
 '(org-special-ctrl-a/e nil)
 '(org-support-shift-select nil)
 '(scroll-error-top-bottom nil)
 '(set-mark-command-repeat-pop nil)
 '(shift-select-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(completions-common-part ((t (:inherit default :foreground "red"))))
 '(show-paren-match ((((class color) (background light)) (:background "azure2")))))
