;; Add custom config directory to load path
(add-to-list 'load-path (expand-file-name "modules" user-emacs-directory))

;; Fonts
(set-face-attribute 'default nil :family "RobotoMono Nerd Font" :height 120)
(set-face-attribute 'line-number nil :family "RobotoMono Nerd Font" :height 120)
(set-face-attribute 'line-number-current-line nil :family "RobotoMono Nerd Font" :height 120)

;; Startup directory
(setq default-directory "~/")

;; Basic quality of life
(setq inhibit-startup-screen t)      ; No startup screen
(tool-bar-mode -1)                   ; No toolbar
(menu-bar-mode -1)                   ; No menubar (optional)
(scroll-bar-mode -1)                 ; No scrollbar
(setq make-backup-files nil)         ; No backup files
(global-display-line-numbers-mode 1) ; Line numbers
(setq-default truncate-lines t)      ; Disable text wrapping
(setq-default indent-tabs-mode nil)  ; Use spaces instead of tabs
(setq-default tab-width 4)           ; Set default tab width to 4
(setq-default c-basic-offset 4)      ; Set basic offset (e.g. C, Python, etc.)

;; Relative line numbers (like Vim)
(setq
 display-line-numbers-grow-only   t
 display-line-numbers-type        'relative
 display-line-numbers-width-start t)

;; Disable all bells
(setq ring-bell-function 'ignore)
(setq visible-bell nil)

(setq auto-save-file-name-transforms `((".*" "~/.config/emacs/auto-save-list/" t)))

;; Package management
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Disable signature checking (some packages have missing keys)
(setq package-check-signature nil)
(package-initialize)

;; Install use-package if not already installed
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Enable "modules" 
;; Load Evil configuration (must be loaded before other configs that depend on it)
(require 'evil-config)

;; Load Terminal configuration
(require 'terminal-config)

;; Load Project configuration
(require 'project-config)

;; Ensure path variables are available in emacs
(use-package exec-path-from-shell
  :ensure t
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

;; Theme
(use-package kanagawa-themes
  :ensure t
  :config
  (load-theme 'kanagawa-wave t)) 

;; Indent lines
(use-package indent-bars
  :ensure t
  :config
  :hook ((go-mode) . indent-bars-mode)) 
(setq indent-bars-pattern "." )
(setq indent-bars-color-by-depth '(:palette ("gray") :blend 0.65))
(setq indent-bars-highlight-current-depth '(:face default :blend 0.4))

;; Which-key: shows available keybindings
(use-package which-key
  :ensure t
  :config
  (which-key-mode))

;; Vertico - vertical completion UI
(use-package vertico
  :ensure t
  :init
  (vertico-mode)
  :config
  ;; Center the minibuffer prompt
  (setq vertico-count 20)
  (vertico-posframe-mode 1))

;; Vertico-posframe - display Vertico in a posframe (floating frame)
(use-package vertico-posframe
  :ensure t
  :after vertico
  :config
  (setq vertico-posframe-poshandler #'posframe-poshandler-frame-center)
  (setq vertico-posframe-parameters
        '((left-fringe . 8)
          (right-fringe . 8))))

;; Orderless - flexible completion style
(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

;; Consult - enhanced commands
(use-package consult
  :ensure t
  :bind (("C-s" . consult-line)
         ("C-x b" . consult-buffer)
         ("M-y" . consult-yank-pop)))

;; Marginalia - rich annotations in minibuffer
(use-package marginalia
  :ensure t
  :init
  (marginalia-mode))

;; Dired improvements
(use-package dired
  :ensure nil  ; Built-in
  :config
  ;; Use single buffer for dired
  (put 'dired-find-alternate-file 'disabled nil)
  (setq dired-kill-when-opening-new-directory-buffer t)  ; Kill old buffer when opening new directory
  
  ;; Human-readable file sizes
  (setq dired-listing-switches "-alh")
  
  ;; Auto-refresh dired when files change
  (setq dired-auto-revert-buffer t)
  
  ;; Copy and move files between split dired windows
  (setq dired-dwim-target t))

;; Optional: Dired-x for extra features
(require 'dired-x)

;; Git client
;; (use-package magit
;;   :ensure t)

;; Programming modes
;; Go mode
(use-package go-mode
  :ensure t
  :mode "\\.go\\'"
  :hook ((go-mode . eglot-ensure)
         (go-mode . (lambda ()
                      ;; Use tabs for indentation (Go standard)
                      (setq indent-tabs-mode t)
                      (setq tab-width 4)))))

;; Eglot (built-in LSP client)
(use-package eglot
  :ensure nil  ; Built-in
 :config
  ;; Optional: performance tuning
  (setq eglot-events-buffer-size 0)  ; Disable event logging for performance
  (setq eglot-sync-connect nil)) 

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(indent-tabs-mode t)
 '(package-selected-packages nil))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(provide 'init)
;; End of config.
