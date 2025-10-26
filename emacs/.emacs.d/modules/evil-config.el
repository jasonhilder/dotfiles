;; evil-config.el --- Evil mode and Vim keybindings configuration

;;; Commentary:
;; This file configures Evil mode (Vim emulation) with various
;; enhancements and integrations for a complete Vim-like experience
;; Works with Vertico/Consult completion system

;;; Code:

;; Evil mode (Vim keybindings)
(use-package evil
  :ensure t
  :init
  (setq evil-want-C-u-scroll t)          ; C-u scrolls up like Vim
  (setq evil-want-integration t)         ; Enable evil-collection
  (setq evil-want-keybinding nil)        ; Disable default keybindings (evil-collection will handle)
  (setq evil-undo-system 'undo-redo)     ; Use built-in undo-redo
  (setq evil-search-module 'evil-search) ; Use Evil's search
  (setq evil-split-window-below t)       ; Split below like Vim
  (setq evil-vsplit-window-right t)      ; Vsplit right like Vim
  :config
  (evil-mode 1)
  
  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line))

;; Evil Collection - Evil bindings for many modes
(use-package evil-collection
  :ensure t
  :after evil
  :config
  (evil-collection-init))

;; Evil Surround - Easily change surrounding characters
;; cs"' to change " to ', ds" to delete ", ysiw" to surround word with "
(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1))

;; Evil Commentary - Easy commenting with gcc, gc
(use-package evil-commentary
  :ensure t
  :config
  (evil-commentary-mode))

;; Evil Leader key
(use-package evil-leader
  :ensure t
  :config
  (global-evil-leader-mode)
  (evil-leader/set-leader "<SPC>")
  (evil-leader/set-key
    ;; Files
    "f f" 'find-file
    "f s" 'save-buffer
    "f d" 'dired
    "f j" 'dired-jump
    "f r" 'consult-recent-file
    "f p" 'projectile-find-file
    
    ;; Buffers
    "b b" 'consult-buffer
    "b d" 'kill-buffer
    "b n" 'next-buffer
    "b p" 'previous-buffer
    "b k" 'kill-this-buffer
    "b i" 'ibuffer
    
    ;; Windows
    "w h" 'evil-window-left
    "w j" 'evil-window-down
    "w k" 'evil-window-up
    "w l" 'evil-window-right
    "w s" 'evil-window-split
    "w v" 'evil-window-vsplit
    "w d" 'evil-window-delete
    "w o" 'delete-other-windows
    
    ;; LSP (Eglot)
    "l r" 'eglot-rename
    "l a" 'eglot-code-actions
    "l f" 'eglot-format-buffer
    "l d" 'xref-find-definitions
    "l D" 'xref-find-references
    "l h" 'eldoc-doc-buffer
    
    ;; Project (using Projectile + Consult)
    "p f" 'projectile-find-file
    "p p" 'projectile-switch-project
    "p s" 'consult-ripgrep
    "p g" 'consult-git-grep
    "p b" 'consult-project-buffer
    "p d" 'projectile-dired
    "p k" 'projectile-kill-buffers
    "p r" 'projectile-recentf
    "p i" 'projectile-invalidate-cache
    
    ;; Search (using Consult)
    "s s" 'consult-line
    "s p" 'consult-ripgrep
    "s g" 'consult-grep
    "s i" 'consult-imenu
    "s o" 'consult-outline
    
    ;; Git (using magit)
    "g g" 'magit-status
    "g b" 'magit-blame
    "g l" 'magit-log-current
    
    ;; Terminal (eat)
    "t t" 'my/eat-current
    "t h" 'my/eat-horizontal
    "t v" 'my/eat-vertical
    "t p" 'my/eat-project

    ;; Other
    "SPC" 'execute-extended-command
    ":" 'eval-expression
    "q q" 'save-buffers-kill-terminal
    "h v" 'describe-variable
    "h f" 'describe-function
    "h k" 'describe-key))

;; Dired keybindings with Evil
(with-eval-after-load 'dired
  (evil-define-key 'normal dired-mode-map
    (kbd "h") 'dired-up-directory
    (kbd "l") 'dired-find-alternate-file
    (kbd "q") 'kill-current-buffer
    (kbd "RET") 'dired-find-alternate-file
    (kbd "o") 'dired-find-file-other-window
    (kbd "v") 'dired-view-file))

(provide 'evil-config)
;;; evil-config.el ends here
