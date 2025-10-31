;;; early-init.el --- Early initialization -*- lexical-binding: t -*-

;; Startup performance
(setq gc-cons-threshold 10000000)
(setq byte-compile-warnings '(not obsolete))
(setq warning-suppress-log-types '((comp) (bytecomp)))
(setq native-comp-async-report-warnings-errors 'silent)

;; Silence startup message
(setq inhibit-startup-echo-area-message (user-login-name))

;; Frame configuration
(setq frame-resize-pixelwise t)
(setq default-frame-alist
      '((fullscreen . maximized) 
        (ns-transparent-titlebar . t)))

;; File management - no backups (using version control)
(setq make-backup-files nil)
(setq create-lockfiles nil)

;; Organize auto-generated files
(setq user-emacs-directory "~/.config/emacs/")
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(setq auto-save-list-file-prefix 
      (expand-file-name "auto-save-list/.saves-" user-emacs-directory))

;; Auto-save to var directory
(let ((auto-save-dir (expand-file-name "var/auto-save/" user-emacs-directory)))
  (unless (file-exists-p auto-save-dir)
    (make-directory auto-save-dir t))
  (setq auto-save-file-name-transforms
        `((".*" ,auto-save-dir t))))

;;; early-init.el ends here
