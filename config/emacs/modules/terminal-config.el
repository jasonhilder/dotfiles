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

;; Function to open eat terminal in project root (vertical split)
(defun my/eat-project ()
  "Open eat terminal in project root in a horizontal split."
  (interactive)
  (let ((default-directory (or (projectile-project-root) default-directory)))
    (split-window-right)
    (other-window 1)
    (eat)))

;; Function to close terminal and its window
(defun my/eat-close ()
  "Kill the eat terminal buffer and close its window."
  (interactive)
  (when (eq major-mode 'eat-mode)
    (let ((buf (current-buffer)))
      (when (> (count-windows) 1)
        (delete-window))
      (kill-buffer buf))))

;; Configure eat keybindings in the mode hook
(add-hook 'eat-mode-hook
          (lambda ()
            ;; Enter insert state for Evil (keeps Evil active)
            (when (bound-and-true-p evil-mode)
              (evil-insert-state))))

;; Evil keybindings for eat-mode
(with-eval-after-load 'evil
  ;; Use insert state instead of emacs state to keep Evil active
  (evil-set-initial-state 'eat-mode 'insert)
  
  ;; Make C-w a prefix key in insert state for eat-mode
  (with-eval-after-load 'eat
    ;; Remove C-w from eat's keymaps so Evil can handle it
    (define-key eat-semi-char-mode-map (kbd "C-w") nil)
    (define-key eat-char-mode-map (kbd "C-w") nil)
    
    ;; Define window commands in insert state for eat-mode
    (evil-define-key 'insert eat-mode-map
      (kbd "C-w") evil-window-map
      (kbd "C-w h") 'evil-window-left
      (kbd "C-w j") 'evil-window-down
      (kbd "C-w k") 'evil-window-up
      (kbd "C-w l") 'evil-window-right
      (kbd "C-w s") 'evil-window-split
      (kbd "C-w v") 'evil-window-vsplit
      (kbd "C-w d") 'evil-window-delete
      (kbd "C-w o") 'delete-other-windows
      (kbd "C-w w") 'evil-window-next
      (kbd "C-w W") 'evil-window-prev
      (kbd "C-w q") 'my/eat-close)))  ;; Add this line

;; Keybindings are added to evil-leader in evil-config.el:
;;
;; "t t" 'my/eat-current       ; Open terminal in current window
;; "t h" 'my/eat-horizontal    ; Open terminal in horizontal split
;; "t v" 'my/eat-vertical      ; Open terminal in vertical split

(provide 'terminal-config)
;;; terminal-config.el ends here
