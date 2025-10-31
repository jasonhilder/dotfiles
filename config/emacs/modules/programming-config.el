;; Programming Configuration Module
;; Language modes, LSP, and development tools

;; Git interface
(use-package magit
  :ensure t)

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
