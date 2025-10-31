;; Core Configuration Module
;; UI enhancements, themes, and completion framework

;; This automatically redirects most package data to etc/ and var/ subdirectories.
;; (use-package no-littering
;;   :ensure t
;;   :config
;;   (setq custom-file (no-littering-expand-etc-file-name "custom.el")))

;; Ensure environment variables are available in Emacs GUI
(use-package exec-path-from-shell
  :ensure t
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

;; Color theme - Kanagawa Wave
(use-package kanagawa-themes
  :ensure t
  :config
  (load-theme 'kanagawa-wave t)) 

;; Visual indentation guides
(use-package indent-bars
  :ensure t
  :hook ((go-mode) . indent-bars-mode)
  :config
  (setq indent-bars-pattern ".")
  (setq indent-bars-color-by-depth '(:palette ("gray") :blend 0.65))
  (setq indent-bars-highlight-current-depth '(:face default :blend 0.4)))

;; Display available keybindings in popup
(use-package which-key
  :ensure t
  :config
  (which-key-mode))

;; Vertico - vertical completion UI for minibuffer
(use-package vertico
  :ensure t
  :init
  (vertico-mode)
  :config
  (setq vertico-count 20)  ; Show 20 candidates
  (vertico-posframe-mode 1))

;; Display Vertico in a centered floating frame
(use-package vertico-posframe
  :ensure t
  :after vertico
  :config
  (setq vertico-posframe-poshandler #'posframe-poshandler-frame-center)
  (setq vertico-posframe-parameters
        '((left-fringe . 8)
          (right-fringe . 8))))

;; Flexible completion matching
(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

;; Enhanced search and navigation commands
(use-package consult
  :ensure t
  :bind (("C-s" . consult-line)      ; Search in current buffer
         ("C-x b" . consult-buffer)  ; Enhanced buffer switching
         ("M-y" . consult-yank-pop))) ; Browse kill ring

;; Rich annotations in minibuffer (file info, descriptions, etc.)
(use-package marginalia
  :ensure t
  :init
  (marginalia-mode))

;; Dired (directory editor) improvements
(use-package dired
  :ensure nil  ; Built-in package
  :config
  ;; Allow reusing same buffer when navigating directories
  (put 'dired-find-alternate-file 'disabled nil)
  (setq dired-kill-when-opening-new-directory-buffer t)
  
  ;; Human-readable file sizes (KB, MB, GB)
  (setq dired-listing-switches "-alh --group-directories-first")
  
  ;; Auto-refresh when files change
  (setq dired-auto-revert-buffer t)
  
  ;; Smart copying/moving between split dired windows
  (setq dired-dwim-target t))

;; Load extra dired features
(require 'dired-x)

(provide 'core-config)
