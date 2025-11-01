;; Programming Configuration Module
;; Language modes, LSP, and development tools

;; Git interface
(use-package magit
  :ensure t)

;; Corfu - in-buffer completion popup
(use-package corfu
  :ensure t
  :init
  (global-corfu-mode)
  :bind
  (:map global-map
   ("C-SPC" . completion-at-point))
  (:map corfu-map
   ("C-n" . corfu-next)
   ("C-p" . corfu-previous)
   ("C-SPC" . corfu-insert)
   ("RET" . nil))  ; Don't complete on Enter
  :config
  (setq corfu-auto t)
  (setq corfu-auto-delay 0.1)
  (setq corfu-auto-prefix 1)
  (setq corfu-cycle t))

;; Cape - additional completion sources
(use-package cape
  :ensure t
  :init
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev))

;; Go programming language support
(use-package go-mode
  :ensure t
  :mode "\\.go\\'"  ; Auto-enable for .go files
  :hook ((go-mode . eglot-ensure)  ; Start LSP server
         (go-mode . (lambda ()
                      ;; Go standard: use tabs for indentation
                      (setq indent-tabs-mode t)
                      (setq tab-width 4)))))

;; Eglot - built-in LSP client for code intelligence
(use-package eglot
  :ensure nil  ; Built-in since Emacs 29
  :config
  ;; Performance optimizations
  (setq eglot-events-buffer-size 0)  ; Disable event logging
  (setq eglot-sync-connect nil))     ; Connect asynchronously

(provide 'programming-config)
