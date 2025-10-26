;; terminal-config.el --- Terminal configuration with eat

;;; Commentary:
;; This file configures the eat (Emulate A Terminal) package
;; with convenient functions to open terminals in splits

;;; Code:

;; Eat - Emulate A Terminal
(use-package eat
  :ensure t
  :config
  ;; Close the terminal buffer when the shell exits
  (setq eat-kill-buffer-on-exit t)
  
  ;; Enable mouse support
  (setq eat-enable-mouse t)
  
  ;; Customize eat term name
  (setq eat-term-name "xterm-256color"))

;; Function to open eat terminal in a horizontal split (below)
(defun my/eat-horizontal ()
  "Open eat terminal in a horizontal split below."
  (interactive)
  (split-window-below)
  (other-window 1)
  (eat))

;; Function to open eat terminal in a vertical split (right)
(defun my/eat-vertical ()
  "Open eat terminal in a vertical split to the right."
  (interactive)
  (split-window-right)
  (other-window 1)
  (eat))

;; Function to open eat terminal in current window
(defun my/eat-current ()
  "Open eat terminal in current window."
  (interactive)
  (eat))

;; Function to open eat terminal in project root (horizontal split)
(defun my/eat-project ()
  "Open eat terminal in project root in a horizontal split."
  (interactive)
  (let ((default-directory (or (projectile-project-root) default-directory)))
    (split-window-below)
    (other-window 1)
    (eat)))

;; Evil keybindings for eat-mode
(with-eval-after-load 'evil
  (evil-set-initial-state 'eat-mode 'emacs))

;; Automatically enter insert mode in eat buffers
(add-hook 'eat-mode-hook
          (lambda ()
            (when (bound-and-true-p evil-mode)
              (evil-emacs-state))))

;; Keybindings are added to evil-leader in evil-config.el:
;;
;; "t t" 'my/eat-current       ; Open terminal in current window
;; "t h" 'my/eat-horizontal    ; Open terminal in horizontal split
;; "t v" 'my/eat-vertical      ; Open terminal in vertical split
;; "t p" 'my/eat-project       ; Open terminal in project root

(provide 'terminal-config)
;;; terminal-config.el ends here
