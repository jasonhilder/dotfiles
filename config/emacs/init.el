;; Emacs Configuration
;; Main init file - loads all modules

;; ------------------------------------------------------------------------
;; Options start
;; ------------------------------------------------------------------------
;; Add custom config directory to load path
(add-to-list 'load-path (expand-file-name "modules" user-emacs-directory))

;; Font configuration
(set-face-attribute 'default nil :family "RobotoMono Nerd Font" :height 120)
(set-face-attribute 'line-number nil :family "RobotoMono Nerd Font" :height 120)
(set-face-attribute 'line-number-current-line nil :family "RobotoMono Nerd Font" :height 120)

;; Startup directory
(setq default-directory "~/")

;; Basic quality of life improvements
(setq inhibit-startup-screen t)      ; No startup screen
(tool-bar-mode -1)                   ; No toolbar
(menu-bar-mode -1)                   ; No menubar
(scroll-bar-mode -1)                 ; No scrollbar
(global-display-line-numbers-mode 1) ; Show line numbers globally
(setq make-backup-files nil)         ; No backup files
(setq-default truncate-lines t)      ; Disable text wrapping
(setq-default indent-tabs-mode nil)  ; Use spaces instead of tabs by default
(setq-default tab-width 4)           ; Set default tab width to 4 spaces
(setq-default c-basic-offset 4)      ; Set basic offset for C-style languages
(setq use-short-answers t)           ; Use y or n instead of yes or no

;; Relative line numbers (Vim-style)
(setq
 display-line-numbers-grow-only   t
 display-line-numbers-type        'relative
 display-line-numbers-width-start t)

;; Disable all bells and visual indicators
(setq ring-bell-function 'ignore)
(setq visible-bell nil)

;; Store auto-save files in a dedicated directory
(setq auto-save-file-name-transforms `((".*" "~/.config/emacs/var/auto-save-list/" t)))
;; ------------------------------------------------------------------------
;; Options end --
;; ------------------------------------------------------------------------

;; ------------------------------------------------------------------------
;; Package management setup
;; ------------------------------------------------------------------------
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(setq package-check-signature nil)  ; Disable signature checking for packages with missing keys
(package-initialize)

;; Install use-package if not already installed
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; ------------------------------------------------------------------------
;; Load modules
;; ------------------------------------------------------------------------
(require 'core-config)        ; Core UI and completion packages
(require 'evil-config)        ; Vim emulation
(require 'project-config)     ; Project management
(require 'terminal-config)    ; Terminal/shell configuration
(require 'programming-config) ; Programming language support

;; ------------------------------------------------------------------------
;; Store custom variables in separate file
;; ------------------------------------------------------------------------
(setq custom-file (expand-file-name "var/custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;; ------------------------------------------------------------------------
;; Store transient data in var directory
;; ------------------------------------------------------------------------
(make-directory (expand-file-name "var/transient" user-emacs-directory) t)
(setq transient-history-file (expand-file-name "var/transient/history.el" user-emacs-directory))
(setq transient-levels-file (expand-file-name "var/transient/levels.el" user-emacs-directory))
(setq transient-values-file (expand-file-name "var/transient/values.el" user-emacs-directory))

(provide 'init)
;; End of config.
